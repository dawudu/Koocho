import 'package:provider/provider.dart';
import 'package:koocho/provider/product_provider.dart';
import 'package:koocho/screens/home_screen.dart';
import 'package:koocho/screens/location_screen.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koocho/screens/location_screen.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:koocho/services/search_service.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseService _service = FirebaseService();

  SearchService _search = SearchService();
  static List<Products> products = [];

  String address = '';

  DocumentSnapshot sellerDetails;

  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          products.add(
            Products(
                document: doc,
                title: doc['title'],
                category: doc['category'],
                description: doc['description'],
                subCat: doc['subCat'],
                postedDate: doc['postedAt'],
                price: doc['price']),
          );

          getSellerAddress(doc['sellerUid']);
        });
      });
    });
    super.initState();
  }

  getSellerAddress(sellerId) {
    _service.getSellerData(sellerId).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    // https://firebase.flutter.dev/docs/firestore/usage/#one-time-read
    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData && !snapshot.data.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data.data();
          if (data['address'] == null) {
            // then will check next data
            GeoPoint latLong = data['location'];
            _service
                .getAddress(latLong.latitude, latLong.longitude)
                .then((adres) {
              // this address will show in app bar.
              // will design one appbar
              return appBar(adres, context, _provider, sellerDetails);
            });
          } else {
            return appBar(data['address'], context, _provider, sellerDetails);
          }
          // return appBar('Update Location', context);
        }

        // return Text('Fetching location..');
        print(snapshot.connectionState);

        return appBar(
            'Fetching location...', context, _provider, sellerDetails);
      },
    );
  }

  Widget appBar(address, context, _provider, sellerDetails) {
    return AppBar(
      // now need to bring those address here in appbar
      // title: Text(locationData.latitude.toString()),
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LocationScreen(
                      popScreen: HomeScreen.id,
                    )),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Icon(CupertinoIcons.location_solid,
                    color: Colors.black, size: 18),
                // fix text overflow
                Flexible(
                  child: Text(
                    address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onTap: () {
                          _search.search(
                              context: context,
                              productList: products,
                              address: address,
                              provider: _provider,
                              sellerDetails: sellerDetails);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            labelText:
                                "Barter products, skills, chores & much more!",
                            labelStyle: TextStyle(fontSize: 12),
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.notifications_none),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
