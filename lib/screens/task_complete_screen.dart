import 'package:flutter/material.dart';

class TaskCompleteScreen extends StatelessWidget {
  static String routeName = '/complete_task';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Kode Mono",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("+ 10 medal points", style: TextStyle(fontSize: 14.0)),
            SizedBox(height: 40),
            Image.asset("images/Medal.png", height: 250),
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  "YOU COMPLETED",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Kode Mono",
                  ),
                ),
                Text(
                  "THE TASK!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Kode Mono",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Task Completed:", style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 10),
            Text("MBAP HIGH FI Screens", style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xff7BB1D2), // Border color
                  width: 2.0, // Border thickness
                ),
                fixedSize: const Size(400, 50),
                backgroundColor: Color(0xffDEF3FC),
              ),

              child: Text(
                "Continue",
                style: TextStyle(fontSize: 16.0, fontFamily: "Kode Mono"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
