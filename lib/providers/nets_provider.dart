import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:steady_just_study/models/nets_state.dart';
import 'package:steady_just_study/services/firebase_service.dart';
import 'package:steady_just_study/services/nets_service.dart';

final netsServiceProvider = Provider<NETSService>((ref) {
  return NETSService();
});

final netsProvider = StateNotifierProvider<NetsController, NetsState>((ref) {
  final service = ref.read(netsServiceProvider);
  return NetsController(service);
});

class NetsController extends StateNotifier<NetsState> {
  final NETSService service;

  Timer? _timer;

  NetsController(this.service) : super(NetsState());

  // 1. Generate QR
  Future<void> generateQR() async {
    state = state.copyWith(status: "loading");

    final decoded = await service.requestQR(2.0);

    final qr = base64Decode(decoded['qrCode']);
    final txnRef = decoded['txnRef'];

    state = state.copyWith(
      qrCode: qr,
      status: "idle",
      timeLeft: 300,
      txnRef: txnRef,
      message: null,
    );

    startTimer(txnRef);
    startWebhookListener(txnRef);
  }

  // 2. Countdown timer
  void startTimer(String txnRef) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        timer.cancel();
        checkPayment(txnRef);
      }
    });
  }

  // 3. SSE listener
  void startWebhookListener(String txnRef) async {
    await for (final data in service.webhookStream(txnRef)) {
      if (!mounted) return;

      if (data.contains("QR code scanned")) {
        state = state.copyWith(message: "QR code scanned");
        checkPayment(txnRef);
        break;
      }
    }
  }

  // 4. Final payment check
  Future<void> checkPayment(String txnRef) async {
    final decoded = await service.checkPayment(txnRef);

    final code = decoded['response_code'] ?? "99";
    final message = decoded['message'];

    state = state.copyWith(message: message);

    if (code == '00') {
      state = state.copyWith(status: "success");
      await FirebaseService().markUserAsPaid();
      await Future.delayed(const Duration(seconds: 10));

      state = state.copyWith(status: "complete");
    } else {
      state = state.copyWith(status: "fail");
    }
  }

  void cleanup() {
    _timer?.cancel();
    state = NetsState();
  }
}
