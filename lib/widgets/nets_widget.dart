import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/nets_provider.dart';
import 'package:steady_just_study/widgets/nets_fail_widget.dart';
import 'package:steady_just_study/widgets/nets_success_widget.dart';

class NETSWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<NETSWidget> createState() => _NETSWidgetState();
}

class _NETSWidgetState extends ConsumerState<NETSWidget> {
  @override
  void initState() {
    super.initState();

    // Calls generateQR when the widget is first built to display the QR code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(netsProvider.notifier).generateQR();
    });
  }

  // Format seconds into mm:ss
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(netsProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (state.status == "idle" && state.qrCode != null)
            Text(
              "Opps this is a paid feature!\n Pay to compete!\nFee: \$2.00 \nScan the QR code below with TWallet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

          // Show QR code when available
          if (state.status == "idle" && state.qrCode != null)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Image.memory(
                state.qrCode!,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),

          if (state.status == "idle" && state.qrCode != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Image.asset(
                'images/nets_qr_info.png',
                width: 500,
                height: 200,
              ),
            ),

          // Show status messages
          if (state.status == "loading") const CircularProgressIndicator(),

          // Show success message
          if (state.status == "success") NETSSuccessWidget(),

          // Show failure message
          if (state.status == "fail") NETSFailWidget(),

          // Show time left when QR is active
          if (state.status == "idle" && state.qrCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Time left: ${formatTime(state.timeLeft)}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

          // Show time left when QR is active
          if (state.status == "idle" && state.qrCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/");
                },
                child: Text("Cancel Payment"),
              ),
            ),
        ],
      ),
    );
  }
}
