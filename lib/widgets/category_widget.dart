import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koocho/screens/sellItems/seller_category_list.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/screens/categories/category_list.dart';
import 'package:koocho/screens/categories/subCat_screen.dart';
import 'package:koocho/screens/sellItems/product_by_category_screen.dart';
import 'package:koocho/screens/sellItems/seller_subCat.dart';
import 'package:koocho/services/firebase_services.dart';

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              _service.categories.orderBy('sortId', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Show complete list of categories

                          Navigator.pushNamed(context, CategoryListScreen.id);
                        },
                        child: Row(
                          children: [
                            Text(
                              "See all",
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 12, color: Colors.black),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Show complete list of categories

                          //This button is for adding products for the seller
                          //so it will open first category screen to select the screen, where item belong to '
                          Navigator.pushNamed(context, SellerCategory.id);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Upload more products",
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 12, color: Colors.black),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var doc = snapshot.data.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              //subCategories
                              _catProvider.getCategory(doc['catName']);
                              _catProvider.getCatSnapshot(doc);
                              if (doc['subCat'] == null) {
                                //Means anything= car category
                                //Here now we need to use th provider

                                // _catProvider.getSubCategory(null);

                                _catProvider.getSubCategory(null);

                                return Navigator.pushNamed(
                                    context, ProductByCategory.id);
                              }
                              Navigator.pushNamed(context, SubCatList.id,
                                  arguments: doc);
                            },
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Column(
                                children: [
                                  Image.network(doc['image']),
                                  Flexible(
                                    child: Text(
                                      doc['catName'].toUpperCase(),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
