import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:steady_just_study/models/tasks.dart';
import 'package:steady_just_study/screens/chatbot.dart';
import 'package:steady_just_study/services/firebase_service.dart';
import 'dart:async';

class StopwatchSection extends StatefulWidget {
  const StopwatchSection({super.key});

  @override
  State<StopwatchSection> createState() => _StopwatchSectionState();
}

class _StopwatchSectionState extends State<StopwatchSection> {
  final Stopwatch studyStopwatch = Stopwatch();
  Timer? _timer;

  void _startStopwatch() {
    if (!studyStopwatch.isRunning) {
      studyStopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
  }

  void _pauseStopwatch() {
    if (studyStopwatch.isRunning) {
      studyStopwatch.stop();
      _timer?.cancel();
      setState(() {});
    }
  }

  void _resetStopwatch() {
    studyStopwatch.reset();
    _timer?.cancel();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatElapsedTime(studyStopwatch.elapsed);

    return Column(
      children: [
        Text(
          "Time spent : $formattedTime",
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xff7BB1D2), width: 2.0),
                fixedSize: const Size(100, 50),
                backgroundColor: Color(0xffDEF3FC),
              ),
              onPressed: studyStopwatch.isRunning
                  ? _pauseStopwatch
                  : _startStopwatch,
              child: Text(
                studyStopwatch.isRunning ? 'Pause' : 'Start',
                style: TextStyle(fontFamily: 'Kode Mono'),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xff7BB1D2), width: 2.0),
                fixedSize: const Size(100, 50),
                backgroundColor: Color(0xffDEF3FC),
              ),
              onPressed: _resetStopwatch,
              child: const Text(
                'Reset',
                style: TextStyle(fontFamily: 'Kode Mono'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Study_screen extends ConsumerStatefulWidget {
  static String routeName = '/Study_screen';

  @override
  ConsumerState<Study_screen> createState() => _Study_screenState();
}

class _Study_screenState extends ConsumerState<Study_screen> {
  Task? currentTask;

  @override
  Widget build(BuildContext context) {
    currentTask = ModalRoute.of(context)?.settings.arguments as Task;

    if (currentTask == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Screen')),
        body: const Center(child: Text("No task selected")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Study Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Study Page", style: TextStyle(fontSize: 28.0)),
            SizedBox(height: 40),
            Text("Assessment Status", style: TextStyle(fontSize: 24.0)),
            SizedBox(height: 20),
            Container(
              width: 360,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              //dynamically display progress bar
              child: LinearProgressIndicator(
                minHeight: 40,
                //prevent the progress bar from exceeding 100% and going below 0
                value: (currentTask!.progress / 100).clamp(0.00, 1.0),
                backgroundColor: Color(0xFFFF8F8F),
                color: Color(0xFF7BB1D2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Progress: ${currentTask!.progress.toInt()}%",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Text(
              "Task : ${currentTask!.name}",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Text(
              "Module : ${currentTask!.module}",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Text(
              "Due date : ${DateFormat('dd/M/yyyy').format(currentTask!.dueDate)}",
              style: TextStyle(fontSize: 20.0),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xff7BB1D2), width: 2.0),
                fixedSize: const Size(360, 50),
                backgroundColor: Color(0xffDEF3FC),
              ),
              onPressed: () {
                Navigator.pushNamed(context, ChatbotScreen.routeName);
              },
              label: Text(
                "Talk with Brodie",
                style: TextStyle(
                  fontFamily: 'Kode Mono',
                  fontSize: 20.0,
                  color: Color(0xff000000),
                ),
              ),
              icon: Icon(Icons.chat_bubble, color: Color(0xff000000)),
            ),
            Text("Need help?"),
            SizedBox(height: 20),
            //call the stopwatch function
            const StopwatchSection(),
            SizedBox(height: 20),
            Text(
              "Completion : +10 Medal Points",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xff7BB1D2), width: 2.0),
                fixedSize: const Size(360, 50),
                backgroundColor: Color(0xffDEF3FC),
              ),
              onPressed: () {
                final CompletionMsg = SnackBar(
                  content: const Text('Well done! Task Completed'),
                );
                ScaffoldMessenger.of(context).showSnackBar(CompletionMsg);
                FirebaseService().checkPoints(10, currentTask!.id);
                Navigator.of(context).pushNamed('/complete_task');
              },
              label: Text(
                "Task Complete",
                style: TextStyle(
                  fontFamily: 'Kode Mono',
                  fontSize: 20.0,
                  color: Color(0xff000000),
                ),
              ),
              icon: Icon(Icons.check, color: Color(0xff000000)),
              iconAlignment: IconAlignment.end,
            ),
          ],
        ),
      ),
    );
  }
}
