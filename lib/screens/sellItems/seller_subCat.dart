import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koocho/forms/forms_screen.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/services/firebase_services.dart';

class SellerSubCatList extends StatelessWidget {
  static const String id = 'seller-subCat-screen';

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot args = ModalRoute.of(context).settings.arguments;
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
          args['catName'],
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data['subCat'];

            return Container(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ListTile(
                      onTap: () {
                        //Here we will open next form to sell
                        // We will use one form for all other categories but modify as per categories
                        _catProvider.getSubCategory(data[index]);
                        Navigator.pushNamed(context, FormsScreen.id);
                      },
                      title: Text(
                        data[index],
                        style: TextStyle(fontSize: 15),
                      ),
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
