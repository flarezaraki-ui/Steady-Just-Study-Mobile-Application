import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/screens/change_password.dart';
import 'package:steady_just_study/screens/login_screen.dart';
import 'package:steady_just_study/screens/register_screen.dart';
import '../services/firebase_service.dart';

class WelcomeScreen extends ConsumerWidget {
  Future<void> GoogleLogin(BuildContext context, WidgetRef ref) async {
    try {
      FirebaseService firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.signInWithGoogle();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User logged in successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> MicrosoftLogin(BuildContext context, WidgetRef ref) async {
    try {
      FirebaseService firebaseService = ref.read(firebaseServiceProvider);
      final userCredential = await firebaseService.signInWithMicrosoft();
      if (userCredential != null) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User logged in successfully!')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sign in was canceled.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/Tp_text.png", height: 100, width: 200),
            Image.asset(
              "images/Steady_Study_Logo.png",
              height: 100,
              width: 100,
            ),
            const Text(
              "Steady Just Study",
              style: TextStyle(fontSize: 24.0, fontFamily: 'Kode Mono'),
            ),
            const SizedBox(height: 20),
            const Text(
              "The TP Study App",
              style: TextStyle(fontSize: 16.0, fontFamily: 'Kode Mono'),
            ),
            SizedBox(height: 10),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 2.0),
                    left: BorderSide(color: Colors.black, width: 2.0),
                    right: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 50),
                        ),
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(LoginScreen.routeName);
                        },
                        label: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Kode Mono',
                            fontSize: 20.0,
                          ),
                        ),
                        icon: Icon(Icons.login),
                        iconAlignment: IconAlignment.end,
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(ChangePassword.routeName);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: 'Kode Mono',
                            fontSize: 16.0,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Color(0xFF7BB1D2),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 50),
                        ),
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(RegisterScreen.routeName);
                        },
                        label: Text(
                          "Register",
                          style: TextStyle(
                            fontFamily: 'Kode Mono',
                            fontSize: 20.0,
                          ),
                        ),
                        icon: Icon(Icons.login),
                        iconAlignment: IconAlignment.end,
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                        ),
                        onPressed: () {
                          GoogleLogin(context, ref);
                        },
                        label: const Text(
                          'Login with Google',
                          style: TextStyle(
                            fontFamily: 'Kode Mono',
                            fontSize: 20.0,
                          ),
                        ),
                        icon: Image.asset(
                          "images/google_logo.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                        ),
                        onPressed: () {
                          MicrosoftLogin(context, ref);
                        },
                        label: const Text(
                          "Login with Microsoft",
                          style: TextStyle(
                            fontFamily: 'Kode Mono',
                            fontSize: 20.0,
                          ),
                        ),
                        icon: Image.asset(
                          "images/microsoft_logo.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
