import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/screens/location_screen.dart';
import 'package:koocho/screens/login_screen.dart';
import 'package:koocho/screens/product_list.dart';
import 'package:koocho/widgets/banner_widget.dart';
import 'package:koocho/widgets/category_widget.dart';
import 'package:koocho/widgets/custom_appBar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  // final LocationData locationData;
  // HomeScreen({this.locationData});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = 'South Africa';

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.clearSelectedCat(); // clear selected category from provider

    return Scaffold(
      backgroundColor: Colors.yellow.shade300,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: CustomAppBar(),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Column(
                  children: [
                    //Banner
                    BannerWigdet(),
                    //Categories
                    CategoryWidget(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //Product list

            ProductList(false),
          ],
        ),
      ),
    );
  }
}
