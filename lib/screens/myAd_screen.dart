import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:koocho/widgets/product_card.dart';

class MyAdsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    // final _format = NumberFormat('##,##,##0');

    // String _kmformatted(km) {
    //   var _km = int.parse(km);// converted to int
    //   var _formattedKm = _format.format(_km);
    //   return _formattedKm;
    // }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.yellow,
            elevation: 0.0,
            title: Text(
              "My Ads",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.blue,
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              indicatorWeight: 6,
              tabs: [
                Tab(
                  child: Text(
                    "ADS",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "FAVOURITES",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.products
                      .where('sellerUid', isEqualTo: _service.user.uid)
                      .orderBy('postedAt')
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 140, right: 140),
                        child: Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.yellow.shade200,
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "My Ads",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data.size,
                            itemBuilder: (BuildContext context, int i) {
                              var data = snapshot.data.docs[i];

                              // var price = int.parse(data['price']);// Convert to int if price is number in firebase its a string
                              // var km = int.parse(data['kmDrive']);// Convert to int if price is number in firebase its a string
                              // String formattedPrice = '\$${_format.format(_price)}';
                              // String formattedkm = '\$${_format.format(_km)}';
                              return ProductCard(data: data);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Text("My Favourites"),
            ),
          ],
        ),
      ),
    );
  }
}
