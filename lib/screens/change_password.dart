import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/firebase_provider.dart';
import '../services/firebase_service.dart';

class ChangePassword extends ConsumerWidget {
  static String routeName = '/change_password';

  String? email;
  var form = GlobalKey<FormState>();

  Future<void> resetPassword(BuildContext context, WidgetRef ref) async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      try {
        FirebaseService firebaseService = ref.read(firebaseServiceProvider);
        await firebaseService.forgotPassword(email!);

        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please check your email to reset your password!'),
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.code)));
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
              SizedBox(height: 10),
              const Text(
                "Forgot Password",
                style: TextStyle(fontSize: 24.0, fontFamily: 'Kode Mono'),
              ),
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
                            child: Text("Email"),
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
                                style: TextStyle(fontFamily: 'Kode Mono'),
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
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => resetPassword(context, ref),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 50),
                            ),
                            label: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Kode Mono",
                              ),
                            ),
                            icon: Icon(Icons.login),
                            iconAlignment: IconAlignment.end,
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed("/");
                            },
                            child: const Text(
                              'Back to welcome screen',
                              style: TextStyle(fontFamily: 'Kode Mono'),
                            ), //change
                          ),
                          SizedBox(height: 400),
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
