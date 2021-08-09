import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:koocho/screens/product_details_screen.dart';
import 'package:koocho/screens/product_list.dart';

import 'package:intl/intl.dart';

class Products {
  final String title, description, category, subCat, price;
  final num postedDate;
  final DocumentSnapshot document;

  Products(
      {this.title,
      this.description,
      this.category,
      this.subCat,
      this.price,
      this.postedDate,
      this.document});
}

class SearchService {
  search({context, productList, address, provider, sellerDetails}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
        onQueryUpdate: (s) => print(s),
        items: productList,
        searchLabel: 'Search products',
        suggestion: SingleChildScrollView(child: ProductList(true)),
        failure: Center(
          child: Text('No products found :('),
        ),
        filter: (product) => [
          product.title,
          product.description,
          product.subCat,
          product.category,
        ],
        builder: (product) {
          var date = DateTime.fromMicrosecondsSinceEpoch(product.postedDate);

          var _date = DateFormat.yMMMd().format(date);

          return InkWell(
            onTap: () {
              provider.getProductDetails(product.document);
              provider.getSellerDetails(sellerDetails);
              Navigator.pushNamed(context, ProductDetailsScreen.id);
            },
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 120,
                        child: Image.network(
                            product.document['images'][0]), //Only one image
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.price,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(product.title)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Posted at: $_date'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.blue,
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          148,
                                      child: Text(address,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
