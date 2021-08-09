import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';
import 'package:koocho/forms/form_class.dart';
import 'package:koocho/forms/user_review_screen.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/services/firebase_services.dart';
import 'package:koocho/widgets/imagePicker_widget.dart';

class FormsScreen extends StatefulWidget {
  static const String id = 'form-screen';

  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  FormClass _formClass = FormClass();
  final _formKey = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();

  var _brandText = TextEditingController();
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _typeText = TextEditingController();
  var _bedrooms = TextEditingController();
  var _bathrooms = TextEditingController();
  var _furnishing = TextEditingController();
  var _consStatus = TextEditingController();
  var _buildingSqft = TextEditingController();
  var _carpetSqft = TextEditingController();
  var _totalFloors = TextEditingController();

  validate(CategoryProvider provider) {
    if ((_formKey.currentState.validate())) {
      //If all the fields are filled
      //And if

      if (provider.urlList.isNotEmpty) {
        //Should have image

        provider.dataToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCat': provider.selectedSubCat,
          'brand ': _brandText.text,
          'type ': _typeText.text,
          'price': _priceController.text,
          'title': _titleController.text,
          'bedrooms': _bedrooms.text,
          'bathrooms': _bathrooms.text,
          'furnishing': _furnishing.text,
          'ConstructionStatus': _consStatus.text,
          'buildingSqft': _buildingSqft.text,
          'carpetSqft': _carpetSqft.text,
          'totalFloors': _totalFloors.text,
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

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showBrandDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _textController.text = list[i];
                              });

                              Navigator.pop(context);
                            },
                            title: Text(list[i]),
                          );
                        }),
                  ),
                ],
              ),
            );
          });
    }

    showFormDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _textController.text = list[i];
                            });

                            Navigator.pop(context);
                          },
                          title: Text(list[i]),
                        );
                      }),
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${_provider.selectedCategory} > ${_provider.selectedSubCat}'),
                //This brand should  show only for paintings
                if (_provider.selectedSubCat == "Paintings")
                  InkWell(
                    onTap: () {
                      //We need to get some brands
                      showBrandDialog(_provider.doc['brands'], _brandText);
                    },
                    child: TextFormField(
                      controller: _brandText,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Painting type',
                      ),
                    ),
                  ),
                if (_provider.selectedSubCat == "Digital Art" ||
                    _provider.selectedSubCat == 'Abstract Art' ||
                    _provider.selectedSubCat == 'Baby items' ||
                    _provider.selectedSubCat == 'Kids items')
                  InkWell(
                    onTap: () {
                      //We need to get some brands to show
                      if (_provider.selectedSubCat == 'Abstract Art') {
                        return showFormDialog(
                            _formClass.tabType, _typeText); //Change these
                        // showFormDialog(_formClass.accessories, _typeText);
                      }
                      if (_provider.selectedSubCat == 'Baby items' ||
                          _provider.selectedSubCat == 'Kids items') {
                        return showFormDialog(
                            _formClass.apartmentType, _typeText); //Change these
                      }
                      showFormDialog(_formClass.accessories, _typeText);
                    },
                    child: TextFormField(
                      controller: _typeText,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Item type',
                      ),
                    ),
                  ),

                if (_provider.selectedSubCat == 'Baby items' ||
                    _provider.selectedSubCat == 'Kids items')
                  Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            //We need to get some brands to show

                            showFormDialog(
                                _formClass.number, _bedrooms); //Change this
                          },
                          child: TextFormField(
                            controller: _bedrooms,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText:
                                  'Do Items have a reciept?', //change this
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //We need to get some brands to show

                            showFormDialog(_formClass.number, _bathrooms);
                          },
                          child: TextFormField(
                            controller: _bathrooms,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Are clothes Brand new or old?',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //We need to get some brands to show

                            showFormDialog(_formClass.furnishing,
                                _furnishing); //Change this
                          },
                          child: TextFormField(
                            controller: _furnishing,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Please indicate size range',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //We need to get some brands to show

                            showFormDialog(_formClass.consStatus,
                                _consStatus); //Change this
                          },
                          child: TextFormField(
                            controller: _consStatus,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Indicate barter class',
                            ),
                          ),
                        ),
                        TextFormField(
                          //Change this
                          controller: _buildingSqft,
                          decoration: InputDecoration(
                            labelText: 'Note your other barter option',
                          ),
                        ),
                        TextFormField(
                          //Change this
                          controller: _carpetSqft,
                          decoration: InputDecoration(
                            labelText: 'Note your other barter option',
                          ),
                        ),
                        TextFormField(
                          //Change this
                          // keyboardType: TextInputType.number,
                          controller: _totalFloors,
                          decoration: InputDecoration(
                            labelText: 'Note your other barter option',
                          ),
                        ),
                      ],
                    ),
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
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: "Note your other barter option",
                    // helperText: 'Mention the key features',
                    // prefixText: "Rs"
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please complete required field";
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
                  child: _provider.urlList.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "No image selected",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GalleryImage(
                          imageUrls: _provider.urlList,
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
                        child: Text(_provider.urlList.length > 0
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
                  validate(_provider);
                  // print(_provider.dataToFirestore);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
