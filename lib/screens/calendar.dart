// screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/widgets/calendarTaskDisplay.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static String routeName = '/calendar';

  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final DateTime _firstDay = DateTime.utc(2026, 1, 1);
  final DateTime _lastDay = DateTime.utc(2030, 12, 31);

  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Watch the selected date from Riverpod state
    final selectedDay = ref.watch(selectedDateProvider);

    // Watch all tasks to populate the calendar marker dots dynamically
    final allTasksAsync = ref.watch(calendarTaskProvider(selectedDay));

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Display')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),

            // Dynamically loads marker dots for days with tasks
            eventLoader: (day) {
              return allTasksAsync
                  .where((task) => isSameDay(task.dueDate, day))
                  .toList();
            },

            onDaySelected: (newSelectedDay, focusedDay) {
              if (!isSameDay(selectedDay, newSelectedDay)) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                // Update Riverpod state so calendarTaskProvider updates automatically
                ref.read(selectedDateProvider.notifier).state = newSelectedDay;
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.brown,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(child: Calendartaskdisplay(selectedDate: _focusedDay)),

          // Display tasks corresponding to selected date
        ],
      ),
    );
  }
}
