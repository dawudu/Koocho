import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koocho/forms/seller_anything_form.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/screens/categories/subCat_screen.dart';
import 'package:koocho/screens/sellItems/seller_subCat.dart';
import 'package:koocho/services/firebase_services.dart';

class SellerCategory extends StatelessWidget {
  static const String id = 'seller-category-list-screen';
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Choose Categories",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              _service.categories.orderBy('sortId', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        //subCategories
                        _catProvider.getCategory(doc['catName']);
                        _catProvider.getCatSnapshot(doc);
                        if (doc['subCat'] == null) {
                          //Means anything= car category
                          //Here now we need to use th provider

                          return Navigator.pushNamed(
                              context, SellerAnythingForm.id);
                        }
                        Navigator.pushNamed(context, SellerSubCatList.id,
                            arguments: doc);
                      },
                      leading: Image.network(
                        doc['image'],
                        width: 40,
                      ),
                      title: Text(
                        doc['catName'],
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: doc['subCat'] == null
                          ? null
                          : Icon(Icons.arrow_forward_ios, size: 12),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
