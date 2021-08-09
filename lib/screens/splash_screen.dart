import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:koocho/screens/location_screen.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 5,
        ), () {
      //Duration
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          //Not Signedin
          return Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          //SingedIn
          return Navigator.pushReplacementNamed(context, LocationScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // const colorizeColors = [
    //   Colors.black,
    //   Colors.black,
    // ];

    // const colorizeTextStyle = TextStyle(
    //   fontSize: 50.0,
    //   fontFamily: 'Horizon',
    // );

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/koochopng.png",
              // color: Colors.black,
            ),
            SizedBox(
              height: 10.0,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('Trade by Barter!'),
                  WavyAnimatedText('Trade Your Products & Skills!'),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
