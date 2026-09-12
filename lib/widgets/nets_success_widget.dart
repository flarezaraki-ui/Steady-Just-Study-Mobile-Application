import 'dart:async';
import 'package:flutter/material.dart';

class NETSSuccessWidget extends StatefulWidget {
  @override
  State<NETSSuccessWidget> createState() => _NETSSuccessWidgetState();
}

class _NETSSuccessWidgetState extends State<NETSSuccessWidget> {
  Timer? _timer;
  int _countdown = 10;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('images/Steady_Study_Logo.png', width: 200, height: 200),

        SizedBox(height: 10),

        //display successful payment
        const Text(
          "Payment Successful",
          style: TextStyle(
            fontFamily: "Kode Mono",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          "Returning to Profile in $_countdown seconds",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
