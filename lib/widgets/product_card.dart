import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/product_provider.dart';
import 'package:koocho/screens/product_details_screen.dart';
import 'package:koocho/services/firebase_services.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key key,
    @required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object> data;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseService _service = FirebaseService();

  String address = '';

  DocumentSnapshot sellerDetails;

  @override
  void initState() {
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return InkWell(
      //Now whe user presses on a product
      onTap: () {
        //All productd data  will save in the provider
        _provider.getProductDetails(widget.data);
        _provider.getSellerDetails(sellerDetails);
        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          child: Center(
                            child: Image.network(
                                widget.data['images'][0]), //Only first image
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //Price
                        // Text(
                        //   _formattedPrice,
                        //   style: TextStyle(fontWeight: FontWeight.bold),
                        // ),

                        Text(
                          widget.data['price'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        widget.data['category'] == 'Anything'
                            ? Text(
                                '${widget.data['year']}-${widget.data['kmDrive']}')
                            : Text(''),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  //Address

                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 14,
                        color: Colors.blue,
                      ),
                      Flexible(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //We will work on this in another video

              Positioned(
                right: 0.0,
                child: CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Center(
                    child: LikeButton(
                      circleColor: CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
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
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.8),
            ),
            borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
