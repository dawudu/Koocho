import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koocho/forms/forms_screen.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/provider/product_provider.dart';
import 'package:koocho/screens/authentication/email_auth_screen.dart';
import 'package:koocho/screens/authentication/email_verification_screen.dart';
import 'package:koocho/screens/authentication/reset_password_screen.dart';
import 'package:koocho/screens/categories/category_list.dart';
import 'package:koocho/screens/categories/subCat_screen.dart';
import 'package:koocho/screens/home_screen.dart';
import 'package:koocho/screens/location_screen.dart';
import 'package:koocho/screens/login_screen.dart';
import 'package:koocho/screens/authentication/phoneauth_screen.dart';
import 'package:koocho/screens/product_details_screen.dart';
import 'package:koocho/screens/sellItems/product_by_category_screen.dart';
import 'package:koocho/screens/sellItems/seller_category_list.dart';
// import 'package:toola/screens/sellItems/category_list.dart';
import 'package:koocho/screens/sellItems/seller_subCat.dart';
import 'package:koocho/screens/splash_screen.dart';
import 'package:koocho/services/firebase_services.dart';

import 'forms/seller_anything_form.dart';
import 'forms/user_review_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => CategoryProvider()),
        Provider(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,

        // fontFamily: ,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        EmailAuthScreen.id: (context) => EmailAuthScreen(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCatList.id: (context) => SubCatList(),
        MainScreen.id: (context) => MainScreen(),
        SellerSubCatList.id: (context) => SellerSubCatList(),
        SellerCategory.id: (context) => SellerCategory(),
        SellerAnythingForm.id: (context) => SellerAnythingForm(),
        UserReviewScreen.id: (context) => UserReviewScreen(),
        FormsScreen.id: (context) => FormsScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
        ProductByCategory.id: (context) => ProductByCategory(),
      },
    );

    // return FutureBuilder(
    //   // Replace the 3 second delay with your initialization code:
    //   future: Future.delayed(Duration(
    //       seconds: 10)), //After 3 seconds screen will move to next screen
    //   builder: (context, AsyncSnapshot snapshot) {
    //     // Show splash screen while waiting for app resources to load:
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // If its connecting screen will go to splash
    //       return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           theme: ThemeData(
    //             primaryColor: Colors.cyan,
    //             // fontFamily: ,
    //           ),
    //           home: SplashScreen());
    //     } else {
    //       // Loading is done, return the app:
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(
    //           primaryColor: Colors.cyan,
    //           // fontFamily: ,
    //         ),
    //         home: LoginScreen(),
    //         routes: {
    //           LoginScreen.id: (context) => LoginScreen(),
    //           PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
    //           LocationScreen.id: (context) => LocationScreen(),
    //         },
    //       );
    //     }
    //   },
    // );
  }
}
