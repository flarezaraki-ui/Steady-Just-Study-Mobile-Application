import 'package:flutter/material.dart';
import 'package:steady_just_study/models/tasks.dart';
import 'package:steady_just_study/screens/calendar.dart';
import 'package:steady_just_study/screens/modify_task_screen.dart';
import 'package:steady_just_study/widgets/mytasks.dart';

class TasksList extends StatelessWidget {
  static String routeName = '/TasksList';

  @override
  Widget build(BuildContext context) {
    return TasksListView();
  }
}

class TasksListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildModuleCard(),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed("/add_task");
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                backgroundColor: Color(0xFFFFFFFF),
                side: const BorderSide(color: Color(0xFF908C8C), width: 2),
              ),
              label: Text(
                "Add New Task",
                style: TextStyle(color: Color(0xFF000000)),
              ),
              icon: Icon(Icons.assignment_add, color: Color(0xFF000000)),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(CalendarScreen.routeName);
              },
              label: Text(
                "Calendar",
                style: TextStyle(color: Color(0xFF000000)),
              ),
              icon: Icon(Icons.calendar_today, color: Color(0xFF000000)),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                backgroundColor: Color(0xFFFFFFFF),
                side: const BorderSide(color: Color(0xFF908C8C), width: 2),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF908C8C), width: 2.0),
                  ),
                  child: Mytasks(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildModuleCard() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFB0D9D7), width: 2.0),
            ),
            child: const Text(
              'Modules',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFB0D9D7), width: 2.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: const [
                        Text(
                          'Graded',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'MBAP\nCADV\nAMDT\nAPSEC\nECOMM',
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(color: Color(0xFFB0D9D7), width: 5, height: 150),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: const [
                        Text(
                          'Pass/Fail',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'INNOVA\nGS\nLEADACT',
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
