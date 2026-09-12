import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/screens/change_password.dart';
import 'package:steady_just_study/screens/register_screen.dart';
import '../providers/firebase_provider.dart';
import '../services/firebase_service.dart';

class LoginScreen extends ConsumerWidget {
  static String routeName = '/login';

  String? username;
  String? password;
  var form = GlobalKey<FormState>();

  Future<void> login(BuildContext context, WidgetRef ref) async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      try {
        FirebaseService firebaseService = ref.read(firebaseServiceProvider);

        await firebaseService.login(username!, password!);

        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User logged in successfully!')),
        );
        Navigator.of(context).pushNamed("/");
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.code)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again. $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
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
              const Text(
                "Login",
                style: TextStyle(fontSize: 24.0, fontFamily: 'Kode Mono'),
              ),
              const SizedBox(height: 20),
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
                                style: TextStyle(fontFamily: 'Kode Mono'),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                          const SizedBox(height: 40),
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
                                style: TextStyle(fontFamily: 'Kode Mono'),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Please provide a password.';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters.';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              password = value;
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {
                              login(context, ref);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 50),
                            ),

                            label: const Text(
                              'Login',
                              style: TextStyle(fontFamily: "Kode Mono"),
                            ),
                            icon: Icon(Icons.login),
                            iconAlignment: IconAlignment.end,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(RegisterScreen.routeName);
                            },
                            child: const Text(
                              'No account? Register here!',
                              style: TextStyle(fontFamily: "Kode Mono"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(ChangePassword.routeName);
                            },
                            child: const Text(
                              'Forgotten Password?',
                              style: TextStyle(fontFamily: "Kode Mono"),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/");
                            },
                            child: const Text(
                              'Login with Google or microsoft',
                              style: TextStyle(fontFamily: "Kode Mono"),
                            ),
                          ),
                          SizedBox(height: 100),
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
    );
  }
}
