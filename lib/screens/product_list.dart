import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:koocho/widgets/product_card.dart';

class ProductList extends StatelessWidget {
  final bool proScreen;

  ProductList(this.proScreen);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    // final _format = NumberFormat('##,##,##0');

    // String _kmformatted(km) {
    //   var _km = int.parse(km);// converted to int
    //   var _formattedKm = _format.format(_km);
    //   return _formattedKm;
    // }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _catProvider.selectedCategory == 'Anything'
              ? _service.products
                  .orderBy('postedAt')
                  .where('category', isEqualTo: _catProvider.selectedCategory)
                  .get()
              : _service.products
                  .orderBy('postedAt')
                  .where('subCat', isEqualTo: _catProvider.selectedSubCat)
                  .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140, right: 140),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.yellow.shade200,
                ),
              );
            }

            if (snapshot.data.docs.length == 0) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text(
                    "No items added\n under selected category",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proScreen == false)
                  Container(
                      height: 56,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Fresh Recommendations",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
              ],
            );
          },
        ),
      ),
    );
  }
}
