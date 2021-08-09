import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/provider/product_provider.dart';
import 'package:intl/intl.dart';
import 'package:koocho/screens/chat/chat_conversation_screen.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = 'product-details-screen';
  const ProductDetailsScreen({Key key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  GoogleMapController _controller;
  FirebaseService _service = FirebaseService();

  bool _loading = true; //When screen open loading is true

  int _index = 0;

  // final _formate = NumberFormat();

  @override
  void initState() {
    //When screen open
    Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  _mapLauncher(location) async {
    final availableMaps = await launcher.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: "Seller's location is here",
    );
  }

  _callSeller(number) {
    launch(number);
  }

  createChatRoom(ProductProvider _provider) {
    //We need some data to store, pull from firebase
    Map<String, dynamic> product = {
      'productId': _provider.productData.id,
      'productImage': _provider.productData['images'][0], //Only first image
      'price': _provider.productData['price'],
      'title': _provider.productData['title'],
    };

    List<String> users = [
      //Seller(koocho) and buyer(kachim)

      _provider.sellerDetails['uid'],
      _service.user.uid // buyer
    ];

    String chatRoomId =
        '${_provider.sellerDetails['uid']}.${_service.user.uid}.${_provider.productData.id}';

    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'read': false,
      'product': product,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
    };

    _service.createChatRoom(
      chatData: chatData,
    );

    //Save all details

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChatConversations(
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);

    GeoPoint _location = _productProvider.sellerDetails['location'];

    var data = _productProvider.productData;

    var date = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);

    var _date = DateFormat.yMMMd().format(date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          LikeButton(
            circleColor:
                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.yellow.shade100,
                  //If loading , this will happen
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Loading your Ad"),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                backgroundDecoration: BoxDecoration(
                                  color: Colors.yellow.shade100,
                                ),
                                imageProvider:
                                    NetworkImage(data['images'][_index]),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data['images'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index = i;
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        // color: Colors.white,
                                        child: Image.network(data['images'][i]),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                _loading
                    ? Container()
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['title'].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                if (data['category'] == 'Anything')
                                  Text('( ${(data['year'])})'),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              data["price"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (data['category'] ==
                                'Anything') // Only for 'Anything' category
                              Container(
                                color: Colors.yellow.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.filter_alt_outlined,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                data['fuel'],
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.av_timer_outlined,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                data['kmDrive'],
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.account_tree_outlined,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                data['transmission'],
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.yellow.shade100,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 12,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  data['noOfOwners'],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: AbsorbPointer(
                                                  absorbing:
                                                      true, //Disable button
                                                  child: TextButton.icon(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                        alignment:
                                                            Alignment.center),
                                                    icon: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 12,
                                                    ),
                                                    label: Flexible(
                                                      child: Text(
                                                          _productProvider
                                                                      .sellerDetails ==
                                                                  null
                                                              ? ''
                                                              : _productProvider
                                                                      .sellerDetails[
                                                                  'address'],
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "POSTED DATE",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Text(
                                                    _date,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ) //Date requires conversion
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.yellow.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(data['description']),

                                          // if (data['subCat'] == null ||
                                          //     data['subCat'] ==
                                          //         "Paintings") //Only for Art/Painting
                                          //   Text('Brand: ${data['brand']}'),
                                          // if (data['subCat'] == "Digital Art" ||
                                          //     data['subCat'] == 'Abstract Art' ||
                                          //     data['subCat'] == 'Baby items' ||
                                          //     data['subCat'] == 'Kids items')
                                          //   Text('Type: ${data['type']}'),
                                          // if (data['subCat'] == 'Baby items' ||
                                          //     data['subCat'] == 'Kids items')
                                          //   Text('Bedrooms: ${data['bedrooms']}'),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(data['description']),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(data[
                                              'description']), // This is any product

                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Posted at:$_date'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.yellow.shade300),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 40,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 38,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 60,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      _productProvider.sellerDetails == null
                                          ? ''
                                          : _productProvider
                                              .sellerDetails['name']
                                              .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "See profile",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.yellow.shade300,
                            ),
                            Text(
                              "Ad posted At",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 200,
                              color: Colors.yellow.shade300,
                              child: Stack(
                                children: [
                                  Center(
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(_location.latitude,
                                              _location.longitude),
                                          zoom: 15),
                                      mapType: MapType.normal,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        setState(() {
                                          _controller = controller;
                                        });
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.black12,
                                    ),
                                  ),
                                  Positioned(
                                    right: 4.0,
                                    top: 4.0,
                                    child: Material(
                                      elevation: 4,
                                      shape: Border.all(
                                        color: Colors.yellow.shade100,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.alt_route_outlined),
                                        onPressed: () {
                                          //Launch location in google maps

                                          _mapLauncher(_location);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ), //Seller/Koochu/  location in google
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'AD ID": ${data['postedAt']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "REPORT THIS AD",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _productProvider.productData['sellerUid'] == _service.user.uid
              ? Row(
                  children: [
                    //Seller should not be able to create a chat room
                    //Only the user can click on the chat button

                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {},
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Edit Product",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    //Seller should not be able to create a chat room
                    //Only the user can click on the chat button

                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {
                          createChatRoom(_productProvider);
                        },
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Chat",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {
                          //Call seller

                          _callSeller(
                              'tel: ${_productProvider.sellerDetails['mobile']}');
                        },
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.phone,
                                size: 16,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Call",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
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
