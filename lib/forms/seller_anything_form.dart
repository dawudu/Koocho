import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';
import 'package:koocho/forms/user_review_screen.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:koocho/widgets/imagePicker_widget.dart';

class SellerAnythingForm extends StatefulWidget {
  static const String id = 'anything-form';

  @override
  _SellerAnythingFormState createState() => _SellerAnythingFormState();
}

class _SellerAnythingFormState extends State<SellerAnythingForm> {
  final _formKey = GlobalKey<FormState>();

  FirebaseService _service = FirebaseService();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _kmController = TextEditingController();
  var _titleController = TextEditingController();
  var _noOfOwnerController = TextEditingController();
  var _descController = TextEditingController();

  //We wil have maximum data here in this textController

  validate(CategoryProvider provider) {
    if ((_formKey.currentState.validate())) {
      //If all the fields are filled
      //And if

      if (provider.urlList.isNotEmpty) {
        //Should have image

        provider.dataToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCat': provider.selectedSubCat,
          'brand ': _brandController.text,
          'year': _yearController.text,
          'price': _priceController.text,
          'fuel': _fuelController.text,
          'transmission': _transmissionController.text,
          'kmDrive': _kmController.text,
          'noOfOwners': _noOfOwnerController.text,
          'title': _titleController.text,
          'description': _descController.text,
          'sellerUid': _service.user.uid,
          'images': provider.urlList, // Should be as list
          'postedAt': DateTime.now().microsecondsSinceEpoch
        });

        //once saved all  data to provider, we need to check user contact details again and
        //To confirm all details are there  so we need togo to the profile screen

        Navigator.pushNamed(context, UserReviewScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image not uploaded'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields..'),
        ),
      );
    }
  }

  List<String> _fuelList = ['Yes', 'No', 'Not applicable']; // For Fuel list
  List<String> _transmission = [
    'Brand new',
    'Old',
    'Not applicable'
  ]; // For Trasnmission list
  List<String> _noOfOwners = [
    'Class A(Local)',
    'Class B(Continental)',
    'Class C(International)'
  ]; // For No of owners

  @override
  void didChangeDependencies() {
    //to get context you can use didchangedepend
    var _catProvider = Provider.of<CategoryProvider>(context);

    setState(() {
      _brandController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['brand'];
      _yearController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['year'];
      _priceController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['price'];
      _fuelController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['fuel'];
      _transmissionController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['transmission'];
      _kmController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['kmDrive'];
      _noOfOwnerController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['noOfOwners'];
      _titleController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['title'];
      _descController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['description'];
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldValue) {
      return AppBar(
        elevation: 0.0,
        // backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        title: Text("$title > $fieldValue",
            style: TextStyle(color: Colors.black, fontSize: 14)),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                  itemCount: _catProvider.doc['models'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _brandController.text =
                              _catProvider.doc['models'][index];
                        });

                        Navigator.pop(context);
                      },
                      title: Text(_catProvider.doc['models'][index]),
                    );
                  }),
            ),
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                })
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          "Add some details",
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What would you like to offer?)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //Lets show list of items to select instead of manual typing
                      //List from firebase// Get list from firebase under models

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      controller: _brandController,
                      enabled: false,
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }

                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    // autofocus: false,
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "When?",
                        hintText: "Indicate your barter date"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "What are you offering?",
                        hintText: "e.g. I'm offering apples(1 kg)"
                        // prefixText: "Rs"
                        ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }

                      if (value.length < 5) {
                        //Price should atleast be above 10000
                        return 'Required minimum price';
                      }

                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Item/service has a receipt?',
                                list: _fuelList,
                                textController: _fuelController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _fuelController,
                      decoration: InputDecoration(
                        labelText: "Item/service has a receipt?",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }

                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Item/service nwew or old?',
                                list: _transmission,
                                textController: _transmissionController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      decoration: InputDecoration(
                        labelText: 'Item/service new or old?',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }

                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _kmController,
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Note your other barter option",
                        hintText: "e.g. I need size 7 sneakers"
                        // prefixText: "Rs"
                        ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }

                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Koocho team',
                                list: _noOfOwners,
                                textController: _noOfOwnerController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      decoration: InputDecoration(
                        labelText: 'Koocho team',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }

                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: InputDecoration(
                        labelText: "Note your other barter option",
                        hintText: "e.g. I need a painting for my house"
                        // helperText: 'Mention the key features',
                        // prefixText: "Rs"
                        ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }

                      if (value.length < 10) {
                        return 'Needs at lest 10 characters';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descController,
                    // keyboardType: TextInputType.number,
                    maxLength: 4000,
                    minLines: 1,
                    maxLines: 30,
                    decoration: InputDecoration(
                      labelText: "Describe your product & barter interests",
                      helperText: 'Include conditions/remarks',
                      // prefixText: "Rs"
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }

                      if (value.length < 30) {
                        return 'Needs at least 30 characters';
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),

                  //Show this only if images are available

                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(4)),
                    child: _catProvider.urlList.length == 0
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "No image selected",
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GalleryImage(
                            imageUrls: _catProvider.urlList,
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      //Upload images from here

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImagePickerWidget();
                          });
                    },
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        border: NeumorphicBorder(
                            color: Theme.of(context).primaryColor),
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(_catProvider.urlList.length > 0
                              ? 'Upload more images'
                              : "Upload Images"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Next",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  validate(_catProvider);
                  print(_catProvider.dataToFirestore);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
