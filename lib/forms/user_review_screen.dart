import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';
import 'package:koocho/screens/home_screen.dart';
import 'package:koocho/screens/location_screen.dart';
import 'package:koocho/screens/main_screen.dart';
import 'package:koocho/services/firebase_services.dart';

class UserReviewScreen extends StatefulWidget {
  static const String id = 'user-review-screen';

  @override
  _UserReviewScreenState createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  FirebaseService _service = FirebaseService();

  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+27');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();

  Future<void> updateUser(provider, Map<String, dynamic> data, context) {
    //First we will update data
    return _service.users.doc(_service.user.uid).update(data).then(
      (value) {
        //The save your new product details
        saveProductToDb(provider, context);
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<void> saveProductToDb(CategoryProvider provider, context) {
    return _service.products.add(provider.dataToFirestore).then(
      (value) {
        provider.clearData(); //Need to clear all the data save data from mobile

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('We have recieved your item'),
          ),
        );

        Navigator.pushReplacementNamed(context, MainScreen.id);
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showConfirmDialog() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("Are you sure, you want to save the below item"),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      leading:
                          Image.network(_provider.dataToFirestore['images'][0]),
                      title: Text(
                        _provider.dataToFirestore['title'],
                        maxLines: 1,
                      ),
                      subtitle: Text(_provider.dataToFirestore['price']),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeumorphicButton(
                          onPressed: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          style: NeumorphicStyle(
                              border: NeumorphicBorder(
                                  color: Theme.of(context).primaryColor),
                              color: Colors.transparent),
                          child: Text("Cancel"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        NeumorphicButton(
                            style: NeumorphicStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              "Confirm",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              updateUser(
                                      _provider,
                                      {
                                        'contactDetails': {
                                          'contactMobile':
                                              _phoneController.text,
                                          'contactEmail': _emailController.text,
                                        },
                                        'name': _nameController.text,
                                      },
                                      context)
                                  .then((value) {
                                setState(() {
                                  _loading = false;
                                });
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_loading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                  ],
                ),
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
          "Review your details",
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.getUserData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            }
            //Here we will show all that deleted details, if exists
            _nameController.text = snapshot.data['name'];
            // _phoneController.text =
            //     snapshot.data['mobile'].substring(3); //Remove +91
            _phoneController.text = snapshot.data['mobile']; //Remove +91
            _emailController.text = snapshot.data['email'];
            _addressController.text = snapshot.data['address'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 40,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 38,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 60,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Your Name",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Contact Details",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _countryCodeController,
                            enabled:
                                false, //If you want to change country code you can delete this

                            decoration: InputDecoration(
                                labelText: 'Country', helperText: ''),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Mobile number',
                              helperText: 'Enter mobile contact number',
                            ),
                            maxLength: 10,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter mobile number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        helperText: 'Enter contact email',
                      ),
                      validator: (value) {
                        // Check if the Email entered is valid or not
                        final bool isValid =
                            EmailValidator.validate(_emailController.text);
                        if (value == null || value.isEmpty) {
                          return 'Enter Email';
                        }
                        if (value.isNotEmpty && isValid == false) {
                          return 'Enter valid email';
                        }

                        return null;
                      },
                      //If you want to change address before confirming
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            minLines: 2,
                            maxLines: 4,
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: "Address",
                              helperText: 'Contact address',

                              // counterText: 'Seller address',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LocationScreen(
                                  popScreen: UserReviewScreen.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    //First need to update user details before saving product data
                    //Lets ask for confirmation before save

                    return showConfirmDialog();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter required fields'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
