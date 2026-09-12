import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/providers/firebase_provider.dart';
import 'package:steady_just_study/services/firebase_service.dart';

class ModifyPassword extends ConsumerWidget {
  static String routeName = '/modify_password';
  var form = GlobalKey<FormState>();

  String? newPassword;
  String? oldPassword;

  Future<void> changePassword(BuildContext context, WidgetRef ref) async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      try {
        form.currentState!.save();
        FirebaseService firebaseService = ref.read(firebaseServiceProvider);

        await firebaseService.changePassword(oldPassword!, newPassword!);

        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password has been changed!')),
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
      appBar: AppBar(
        title: Text(
          "Modify Password",
          style: TextStyle(fontFamily: "Kode Mono"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(fontFamily: 'Kode Mono'),
                  filled: true,
                  fillColor: Color(0xFFF3D2D2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide your current password.";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters long.";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  oldPassword = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(fontFamily: 'Kode Mono'),
                  filled: true,
                  fillColor: Color(0xFFF3D2D2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),

                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please provide your current password.";
                  } else if (value.length < 6) {
                    return "password must be at least 6 characters long";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  newPassword = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  changePassword(context, ref);
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "Kode Mono",
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
