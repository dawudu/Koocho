import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'email_auth_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String id = 'password-reset-screen';

  @override
  Widget build(BuildContext context) {
    var _emailController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: Colors.yellow, size: 75),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Forgot\nPassword?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    labelText: 'Registered Email',
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  validator: (value) {
                    // Check if the Email entered is valid or not
                    final bool isValid =
                        EmailValidator.validate(_emailController.text);
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    }
                    if (value.isNotEmpty && isValid == false) {
                      return 'Enter valid email';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Send us your email, \n we will send a link to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.yellow,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Send",
            style: TextStyle(color: Colors.black),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            //Check if you have enetered email or not
            FirebaseAuth.instance
                .sendPasswordResetEmail(email: _emailController.text)
                .then((value) {
              Navigator.pushReplacementNamed(context, EmailAuthScreen.id);
            });
          }
        },
      ),
    );
  }
}
