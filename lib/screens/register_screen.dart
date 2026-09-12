import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/services/firebase_service.dart';

class RegisterScreen extends ConsumerWidget {
  static const routeName = '/register';

  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  var form = GlobalKey<FormState>();

  Future<void> register(BuildContext context, WidgetRef ref) async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password and Confirm Password does not match!'),
          ),
        );
      } else {
        try {
          FirebaseService firebaseService = ref.read(firebaseServiceProvider);
          await firebaseService.register(username!, email!, password!);

          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Registered successfully!')),
          );

          await firebaseService.sendVerificationEmail();
          Navigator.of(context).pushNamed("/login");
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.code)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Form(
            key: form,
            child: Column(
              children: [
                Image.asset("images/Tp_text.png", height: 100, width: 200),
                Image.asset(
                  "images/Steady_Study_Logo.png",
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 24.0, fontFamily: 'Kode Mono'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",

                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Kode Mono',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF3D2D2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                label: Text(
                                  'Email',
                                  style: TextStyle(fontFamily: "Kode Mono"),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return "Please provide an email address.";
                                } else if (!value.contains('@')) {
                                  return "Please provide a valid email address.";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                email = value;
                              },
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Username",

                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Kode Mono',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF3D2D2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                label: Text(
                                  'Username',
                                  style: TextStyle(fontFamily: "Kode Mono"),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return "Please provide a username.";
                                } else if (value.length < 3) {
                                  return "Username must be at least 3 characters.";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                username = value;
                              },
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password",

                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Kode Mono',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF3D2D2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                label: Text(
                                  'Password',
                                  style: TextStyle(fontFamily: "Kode Mono"),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please provide a password.';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters.';
                                } else
                                  return null;
                              },
                              onSaved: (value) {
                                password = value;
                              },
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Confirm Password",

                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Kode Mono',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF3D2D2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                label: Text(
                                  'Confirm Password',
                                  style: TextStyle(fontFamily: "Kode Mono"),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please provide a confirm password.';
                                } else if (value.length < 6) {
                                  return 'Confirm password must be at least 6 characters.';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                confirmPassword = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/login");
                              },
                              child: const Text(
                                "Have an account? Login Here!",
                                style: TextStyle(fontFamily: "Kode Mono"),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 50),
                              ),
                              onPressed: () {
                                register(context, ref);
                              },
                              label: const Text(
                                'Register',
                                style: TextStyle(fontFamily: "Kode Mono"),
                              ),
                              icon: Icon(Icons.login),
                              iconAlignment: IconAlignment.end,
                            ),
                            SizedBox(height: 20),

                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed("/");
                              },
                              child: const Text(
                                'Back to Welcome Screen',
                                style: TextStyle(fontFamily: "Kode Mono"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
