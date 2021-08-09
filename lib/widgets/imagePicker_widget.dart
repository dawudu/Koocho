// import 'dart:html' as html;
import 'dart:ui';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:koocho/provider/cat_provider.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File _image;
  bool _uploading = false;
  ImagePicker picker = ImagePicker();

  Future getImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    // var pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (picker != null) {
        _image = File(image.path);
      } else {
        print("No images selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    //Image upload to storage
    Future<String> uploadFile() async {
      File file = File(_image.path);

      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String downloadUrl;
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();

        if (downloadUrl != null) {
          setState(() {
            _image = null;
            //add this uploaded url to provide url list
            _provider.getImages(downloadUrl); // Added to this list
          });
        }
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cancelled"),
          ),
        );
      }

      return downloadUrl;
    }

    return Dialog(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.yellow,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Upload Images",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                        ),
                      ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image == null
                            ? Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.black,
                              )
                            : Image.file(_image),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (_provider.urlList.length >
                    0) //if urlList has data only show this
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(4)),
                    child: GalleryImage(
                      imageUrls: _provider.urlList,
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              _uploading = true;
                              uploadFile().then((url) {
                                if (url != null) {
                                  setState(() {
                                    _uploading = false;
                                  });
                                }
                              });
                            });
                          },
                          child: Text(
                            "Save",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.red),
                          onPressed: () {},
                          child: Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImage,
                        style: NeumorphicStyle(
                          color: Colors.yellow,
                        ),
                        child: Text(
                          _provider.urlList.length > 0
                              ? 'Upload more images'
                              : "Uplaod image",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (_uploading)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
