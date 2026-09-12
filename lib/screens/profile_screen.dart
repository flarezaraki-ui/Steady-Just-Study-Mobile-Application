import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/screens/calendar.dart';
import 'package:steady_just_study/screens/progress_tracker.dart';
import 'package:steady_just_study/screens/ranked_screen.dart';
import 'package:steady_just_study/services/firebase_service.dart';
import 'package:steady_just_study/widgets/assessment_display.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? oldPassword;
  String? newPassword;

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await ref.read(firebaseServiceProvider).getCurrentUserData();
    if (!mounted) return;
    setState(() {
      _userData = data;
    });
  }

  Future<void> logout(BuildContext context) async {
    try {
      FirebaseService firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.logOut();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User logged out successfully!')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _userData?['username'] as String? ?? 'User';
    final points = _userData?['points'] ?? 0;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Image.asset(
                  "images/Steady_Study_Logo.png",
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome $username",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "You have been logged out",
                            style: TextStyle(fontFamily: "Kode Mono"),
                          ),
                          content: Text(
                            "You have been logged out successfully.",
                            style: TextStyle(fontFamily: "Kode Mono"),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                logout(context);
                                Navigator.of(context).pushNamed("/");
                              },
                              child: Text("Login"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 20.0,
                    color: Color(0xFF000000),
                  ),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF000000)),
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/Medal.png", width: 60, height: 60),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Medal Points : $points",
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const Text(
                        "DIPLOMA : ITO",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      const Text(
                        "Modules Done : 12",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(ProgressTracker.routeName);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 50),
                  backgroundColor: Color(0xFFFFFFFF),
                  side: const BorderSide(color: Color(0xFF908C8C), width: 2),
                ),
                label: const Text(
                  "Tracker",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "Kode Mono",
                  ),
                ),
                icon: const Icon(Icons.check_circle, color: Color(0xFF000000)),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 50),
                  backgroundColor: Color(0xFFFFFFFF),
                  side: const BorderSide(color: Color(0xFF908C8C), width: 2),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CalendarScreen.routeName);
                },
                label: const Text(
                  "Calendar",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "Kode Mono",
                  ),
                ),
                icon: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(360, 50),
              backgroundColor: Color(0xFFFFFFFF),
              side: const BorderSide(color: Color(0xFF7BB1D2), width: 2),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(RankedScreen.routeName);
            },
            icon: Image.asset("images/trophy.png", width: 40, height: 40),
            label: const Text(
              "View Current Rank",
              style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "Kode Mono",
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(180, 30),
              backgroundColor: Color(0xFFFFFFFF),
              side: const BorderSide(color: Color(0xFF908C8C), width: 2),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/modify_password');
            },
            label: const Text(
              "Change Password",
              style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "Kode Mono",
              ),
            ),
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF908C8C),
                      width: 2.0,
                    ),
                  ),
                  child: const Text(
                    'COMPLETED/UNCOMPLETED ASSESSMENTS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF908C8C),
                      width: 2.0,
                    ),
                  ),
                  child: AssessmentDisplay(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
