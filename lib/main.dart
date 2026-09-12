import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/firebase_options.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/providers/theme_provider.dart';
import 'package:steady_just_study/screens/add_task_screen.dart';
import 'package:steady_just_study/screens/calendar.dart';
import 'package:steady_just_study/screens/change_password.dart';
import 'package:steady_just_study/screens/chatbot.dart';
import 'package:steady_just_study/screens/login_screen.dart';
import 'package:steady_just_study/screens/modify_password.dart';
import 'package:steady_just_study/screens/modify_task_screen.dart';
import 'package:steady_just_study/screens/notificationsTest.dart';
import 'package:steady_just_study/screens/progress_tracker.dart';
import 'package:steady_just_study/screens/ranked_screen.dart';
import 'package:steady_just_study/screens/register_screen.dart';
import 'package:steady_just_study/screens/study_screen.dart';
import 'package:steady_just_study/screens/task_complete_screen.dart';
import 'package:steady_just_study/screens/welcome_screen.dart';
import 'package:steady_just_study/services/notification_service.dart';
import 'package:steady_just_study/widgets/bottom_navbar.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '../providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.init();
  usePathUrlStrategy();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontFamily: "Kode Mono"),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        useMaterial3: true,
      ),

      home: authState.when(
        data: (user) {
          return user != null ? bottom_navbar() : WelcomeScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            const Scaffold(body: Center(child: Text('Something went wrong'))),
      ),
      routes: {
        ChatbotScreen.routeName: (_) {
          return ChatbotScreen();
        },
        Study_screen.routeName: (_) {
          return Study_screen();
        },

        AddTaskScreen.routeName: (_) {
          return AddTaskScreen();
        },
        ModifyTaskScreen.routeName: (_) {
          return ModifyTaskScreen();
        },
        TaskCompleteScreen.routeName: (_) {
          return TaskCompleteScreen();
        },
        RegisterScreen.routeName: (_) {
          return RegisterScreen();
        },
        LoginScreen.routeName: (_) {
          return LoginScreen();
        },
        ChangePassword.routeName: (_) {
          return ChangePassword();
        },
        ModifyPassword.routeName: (_) {
          return ModifyPassword();
        },
        ProgressTracker.routeName: (_) {
          return ProgressTracker();
        },
        CalendarScreen.routeName: (_) {
          return CalendarScreen();
        },
        RankedScreen.routeName: (_) {
          return RankedScreen();
        },
        Notificationstest.routeName: (_) {
          return Notificationstest();
        },
      },
    );
  }
}

class MainScreen extends ConsumerWidget {
  static String routeName = '/main';

  bool backfilled = false;

  Future<void> backfillReminders(WidgetRef ref) async {
    if (backfilled) return;
    backfilled = true;

    final tasks = await ref.read(taskProvider.future);
    for (final task in tasks) {
      if (task.reminderOn) {
        await NotificationService.instance.scheduleTaskReminder(
          taskId: task.id,
          taskName: task.name,
          dueDate: task.dueDate,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.read(themeProvider.notifier);
    final authState = ref.watch(authStateProvider);
    authState.when(
      data: (user) {
        if (user != null) {
          backfillReminders(ref);
        }
        return bottom_navbar();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          const Scaffold(body: Center(child: Text('Something went wrong'))),
    );
    return Center(
      child: Column(
        children: [
          Text(
            "Welcome Back",
            style: TextStyle(fontSize: 28.0, color: Color(0xFF000000)),
          ),
          Image.asset("images/TP_logo.png", height: 80, width: 80),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF7BB1D2), width: 2),
              fixedSize: const Size(320, 80),
              backgroundColor: Color(0xffFFFFFF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/Star.png", width: 50, height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "URGENT",
                      style: TextStyle(
                        fontFamily: "Kode Mono",
                        color: Color(0xFFE21F27),
                      ),
                    ),
                    Text(
                      "ASSIGNMENT DUE IN 2 DAYS",
                      style: TextStyle(
                        fontFamily: "Kode Mono",
                        color: Color(0xFF000000),
                      ),
                    ),
                    Text(
                      "PROGRESS : 70%",
                      style: TextStyle(
                        fontFamily: "Kode Mono",
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 320,
            height: 80,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF7BB1D2),
                  spreadRadius: 2, // Extends the shadow area
                  blurRadius: 8, // Softens the shadow
                  offset: const Offset(4, 4),
                ),
              ],
              border: Border.all(color: Color(0xFF7BB1D2), width: 2),
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffFFFFFF),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Start Studying",
                  style: TextStyle(
                    fontFamily: "Kode Mono",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                Text(
                  "Task : MBAP HIGH FI SCREENS",
                  style: TextStyle(
                    fontFamily: "Kode Mono",
                    color: Color(0xFF000000),
                  ),
                ),
                Text(
                  "Current Progress : 60%",
                  style: TextStyle(
                    fontFamily: "Kode Mono",
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(ProgressTracker.routeName);
                },
                label: Text(
                  "Tracker",
                  style: TextStyle(
                    fontFamily: "Kode Mono",
                    color: Color(0xFF000000),
                  ),
                ),
                icon: Icon(Icons.check_circle, color: Color(0xFF000000)),

                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7BB1D2), width: 2),
                  fixedSize: const Size(200, 50),
                  backgroundColor: Color(0xffFFFFFF),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(CalendarScreen.routeName);
                },
                label: Text(
                  "Calendar",
                  style: TextStyle(
                    fontFamily: "Kode Mono",
                    color: Color(0xFF000000),
                  ),
                ),
                icon: Icon(Icons.calendar_today, color: Color(0xFF000000)),

                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7BB1D2), width: 2),
                  fixedSize: const Size(200, 50),
                  backgroundColor: Color(0xffFFFFFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //allow users to choose their prefered theme
              children: [
                const Text('Themes'),
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 138, 178, 246),
                  ),
                  onTap: () => themeController.setTheme(
                    Color.fromARGB(255, 138, 178, 246),
                    'Base',
                  ),
                ),
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onTap: () => themeController.setTheme(
                    Color.fromARGB(255, 255, 255, 255),
                    'white',
                  ),
                ),
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 83, 96, 76),
                  ),
                  onTap: () => themeController.setTheme(
                    const Color.fromARGB(255, 25, 25, 25),
                    'grey',
                  ),
                ),
                GestureDetector(
                  child: const CircleAvatar(backgroundColor: Colors.red),
                  onTap: () => themeController.setTheme(Colors.red, 'red'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
