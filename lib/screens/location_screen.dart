import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';
import 'package:koocho/screens/home_screen.dart';
import 'package:koocho/screens/login_screen.dart';
// import 'package:toola/screens/main_screen.dart';
import 'package:koocho/services/firebase_services.dart';

import 'main_screen.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';

  final String popScreen;

  LocationScreen(
      {this.popScreen}); // Here we will design to which screen we need to pop back

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  FirebaseService _service = FirebaseService();

  bool _loading = true;
  // https://pub.dev/packages/location
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String _address;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String manualAddress;

  // we get current location details here
  Future<LocationData> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // not sure I really need this : https://stackoverflow.com/questions/55346223/app-sandbox-capability-missing-in-xcode-project
    // https://stackoverflow.com/questions/24842594/ios-simulator-location-not-working
    _locationData = await location.getLocation();
    // print(_locationData);

    // https://pub.dev/packages/geocoder
    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      _address = first.addressLine;
      countryValue = first.countryName;
    });

    return _locationData;
  }

  @override
  void initState() {
    //Fetching location from firestore
    if (widget.popScreen == null) {
      _service.users
          .doc(_service.user.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          // print(document.data());
          if (document['address'] != null) {
            // print('address is not null');
            // means location has already updated
            if (mounted) {
              setState(() {
                _loading = true;
              });
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
          } else {
            // print('address is null');
            setState(() {
              _loading = false;
            });
          }
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut().then((value) {
    //   Navigator.pushReplacementNamed(context, LoginScreen.id);
    // });
    // https://firebase.flutter.dev/docs/firestore/usage/#document--query-snapshots

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    showBottomScreen(context) {
      getLocation().then((location) {
        if (location != null) {
          // only after fetch location only bottom screen will open
          progressDialog.dismiss();
          showModalBottomSheet(
            // need to make it full screen
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (context) {
              return Column(
                children: [
                  SizedBox(height: 26),
                  AppBar(
                    automaticallyImplyLeading: false,
                    iconTheme: IconThemeData(color: Colors.black),
                    elevation: 1,
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        SizedBox(width: 10),
                        Text('Location', style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Search City, area or neighbourhood',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      // save address to firestore
                      progressDialog.show();
                      getLocation().then((value) {
                        if (value != null) {
                          _service.updateUser({
                            'location':
                                GeoPoint(value.latitude, value.longitude),
                            'address': _address,
                          }, context, widget.popScreen).then((value) {
                            progressDialog.dismiss();
                            // return Navigator.pushNamed(
                            //     context, widget.popScreen);
                          });
                        }
                      });
                    },
                    horizontalTitleGap: 0.0,
                    leading: Icon(Icons.my_location, color: Colors.yellow),
                    title: Text(
                      'Use current location',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      // location == null ? 'Fetching location' : 'Address',
                      location == null ? 'Fetching location' : _address,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width, // screen size
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 4, top: 4),
                      child: Text('CHOOSE CITY',
                          style: TextStyle(
                              color: Colors.blueGrey.shade900, fontSize: 12)),
                    ),
                  ),
                  // will use a package to select country, state, and city
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    // https://pub.dev/packages/csc_picker
                    // we can select address here now. now we need to send that address
                    // to next screen. for that we will use provider.
                    child: CSCPicker(
                      layout: Layout.vertical,
                      flagState: CountryFlag.DISABLE,
                      dropdownDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      defaultCountry: DefaultCountry.South_Africa,
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        // if (stateValue == "") {
                        //   return ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('Select state..')),
                        //   );
                        // }
                        setState(() {
                          cityValue = value;
                          // _address = '$cityValue, $stateValue, $countryValue';
                          manualAddress =
                              '$cityValue, $stateValue, $countryValue';
                        });
                        // send this address to firestore too.
                        // here can send data to provide and move to next screen.
                        if (value != null) {
                          _service.updateUser({
                            'address': manualAddress,
                            'state': stateValue,
                            'city': cityValue,
                            'country': countryValue,
                          }, context, widget.popScreen);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          progressDialog.dismiss();
        }
      });
    }

    return Expanded(
      child: Scaffold(
        // body: Center(
        //   child: ElevatedButton(
        //     child: Text('Sign Out'),
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut().then((value) {
        //         Navigator.pushReplacementNamed(context, LoginScreen.id);
        //       });
        //     },
        //   ),
        // ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: 30),
            Image.asset('assets/images/koochopng.png'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Choose your barter location\n & start trading your items!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Barter your skills for products, products for services!\ndescribe your products, upload pictures and start trading!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 30),
            _loading
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Finding location...'),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: _loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                    ))
                                  : ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .primaryColor)),
                                      icon: Icon(
                                        CupertinoIcons.location,
                                        color: Colors.blue,
                                      ),
                                      label: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          'Barter in my community',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        progressDialog.show();

                                        getLocation().then((value) {
                                          // print(_locationData.latitude);
                                          if (value != null) {
                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (BuildContext context) =>
                                            //         HomeScreen(
                                            //       locationData: _locationData,
                                            //     ),
                                            //   ),
                                            // );
                                            _service.updateUser({
                                              'address': _address,
                                              'location': GeoPoint(
                                                  value.latitude,
                                                  value.longitude),
                                            }, context, widget.popScreen);
                                            // .whenComplete(() {
                                            //   ProgressDialog.dismiss();
                                            // });
                                          }
                                        });
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          progressDialog.show();
                          showBottomScreen(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2))),
                            child: Text(
                              'Set location manually',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
