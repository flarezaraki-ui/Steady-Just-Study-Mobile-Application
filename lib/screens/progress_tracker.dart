import 'package:flutter/material.dart';
import 'package:steady_just_study/models/tasks.dart';
import 'package:steady_just_study/screens/chatbot.dart';
import 'package:steady_just_study/widgets/completedTasks.dart';
import 'package:steady_just_study/widgets/week_point_chart.dart';

class ProgressTracker extends StatelessWidget {
  static String routeName = '/progress_tracker';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consistency Tracker',
          style: TextStyle(
            fontFamily: "Kode Mono",
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 340, child: WeeklyPointsChart()),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF908C8C), width: 2.0),
              ),
              child: Text(
                "Completed Tasks",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF908C8C), width: 2.0),
                ),
                child: Completedtasks(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xff7BB1D2), width: 2.0),
                fixedSize: const Size(400, 50),
                backgroundColor: Color(0xffDEF3FC),
              ),
              onPressed: () {
                Navigator.pushNamed(context, ChatbotScreen.routeName);
              },
              label: Text(
                "Talk with Brodie",
                style: TextStyle(
                  fontFamily: 'Kode Mono',
                  fontSize: 16.0,
                  color: Color(0xff000000),
                ),
              ),
              icon: Icon(Icons.chat_bubble, color: Color(0xff000000)),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
