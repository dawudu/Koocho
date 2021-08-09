import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koocho/screens/location_screen.dart';
import 'package:koocho/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-scree';
  @override
  Widget build(BuildContext context) {
    // Duration
    // FirebaseAuth.instance.authStateChanges().listen((User user) {
    //   if (user == null) {
    //     //Not Signedin
    //     Navigator.pushReplacementNamed(context, LoginScreen.id);
    //   } else {
    //     //SingedIn
    //     Navigator.pushReplacementNamed(context, LocationScreen.id);
    //   }
    // });

    return Scaffold(
      backgroundColor: Colors.yellow,

      //Removing the flutter banner on the top right corner
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Image.asset(
                    "assets/images/koochopng.png",
                    // color: Colors.yellow,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Trade like King Solomon",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: AuthUi(),
            ),
          ),
          Text(
            "If you continue, you are accepting\n Terms and Conditions and Privacy Policy",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
