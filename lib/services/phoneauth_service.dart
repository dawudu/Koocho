import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koocho/screens/authentication/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koocho/screens/location_screen.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(context, uid) async {
    // Call the user's CollectionReference to add a new user

    final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();

    List<DocumentSnapshot> document = result.docs; // List of the user data

    if (document.length > 0) {
      //User data exists
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    } else {
      //User data does not exist
      //Add User data to firestore
      return users.doc(user.uid).set({
        'uid': user.uid, // User uid
        'mobile': user.phoneNumber, // User phone number
        'email': user.email, // User email
        // 'name': null,
        // 'address': null // User email
      }).then((value) {
        //Add data to firebase and go to the next screen

        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(
          credential); //After verificatio completed need to sign in
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

      print("The error is ${e.code}");
    };

    final PhoneCodeSent codeSent = (String verId, int resendToken) async {
      //If OTP send now new screen to should open to enter OPT.
      //Design new screen

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number,
            verId: verId,
          ),
        ),
      );
    };

    try {
      auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verificationId) {
            print(verificationId);
          });
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }
}
