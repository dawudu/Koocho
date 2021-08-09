import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/screens/product_list.dart';

class ProductByCategory extends StatelessWidget {
  static const String id = 'product-by-cat';

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedSubCat == null
              ? 'Anything'
              : '${_catProvider.selectedSubCat} > ${_catProvider.selectedSubCat}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(child: ProductList(true)),
    );
  }
}
