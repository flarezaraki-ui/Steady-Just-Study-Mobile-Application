// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // How many days out the window covers, inclusive of the due date itself.
  static const int _windowDays = 7;

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    final localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<bool> requestExactAlarmAccess() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestExactAlarmsPermission() ?? true;
  }

  // One notification id per (task, day-offset) pair, 0..7.
  int _idFor(String taskId, int dayOffset) =>
      ('$taskId-$dayOffset').hashCode & 0x7fffffff;

  // Schedules a daily reminder for every day the task is within 7 days
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskName,
    required DateTime dueDate,
  }) async {
    await cancelReminder(taskId); // clear any previous schedule first

    final canExact = await requestExactAlarmAccess();
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final now = tz.TZDateTime.now(tz.local);
    final dueDay = tz.TZDateTime(
      tz.local,
      dueDate.year,
      dueDate.month,
      dueDate.day,
    );

    var scheduledAny = false;

    // dayOffset 0 = 7 days before due date, ... dayOffset 7 = due date itself.
    for (int dayOffset = 0; dayOffset <= _windowDays; dayOffset++) {
      final daysBeforeDue = _windowDays - dayOffset;
      final reminderTime = tz.TZDateTime(
        tz.local,
        dueDay.year,
        dueDay.month,
        dueDay.day - daysBeforeDue,
        9,
        0, // 9am each day
      );

      if (reminderTime.isBefore(now))
        continue; // that day's slot already passed

      await _plugin.zonedSchedule(
        _idFor(taskId, dayOffset),
        daysBeforeDue == 0
            ? 'Task due today'
            : 'Task due in $daysBeforeDue day${daysBeforeDue == 1 ? '' : 's'}',
        '"$taskName" is due on ${_fmt(dueDate)}',
        reminderTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminders',
            'Task Reminders',
            channelDescription: 'Daily reminders for tasks due within 7 days',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: scheduleMode,
      );
      scheduledAny = true;
    }

    //For if Task is already due today or overdue — fire one immediately
    if (!scheduledAny) {
      await _plugin.zonedSchedule(
        _idFor(taskId, 99),
        'Task due',
        '"$taskName" was due on ${_fmt(dueDate)}',
        now.add(const Duration(seconds: 10)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminders',
            'Task Reminders',
            channelDescription: 'Daily reminders for tasks due within 7 days',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: scheduleMode,
      );
    }
  }

  /// Cancels every reminder (all day-offsets + the fallback id) for a task.
  Future<void> cancelReminder(String taskId) async {
    for (int dayOffset = 0; dayOffset <= _windowDays; dayOffset++) {
      await _plugin.cancel(_idFor(taskId, dayOffset));
    }
    await _plugin.cancel(_idFor(taskId, 99));
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> showTestNotification() async {
    await _plugin.show(
      999,
      'Test notification',
      'If you see this, notifications are working.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Daily reminders for tasks due within 7 days',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
