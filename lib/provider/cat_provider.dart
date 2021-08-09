import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:koocho/services/firebase_services.dart';

class CategoryProvider with ChangeNotifier {
  FirebaseService _service = FirebaseService();
  DocumentSnapshot doc;
  DocumentSnapshot userDetails;
  String selectedCategory;
  String selectedSubCat;
  List<String> urlList = []; // We wil add url to this list

  Map<String, dynamic> dataToFirestore =
      {}; // This is the data we are going to upload to firestore

  getCategory(selectedCat) {
    this.selectedCategory = selectedCat;

    notifyListeners();
  }

  getSubCategory(selectedsubCat) {
    this.selectedSubCat = selectedsubCat;

    notifyListeners();
  }

  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore = data;
    notifyListeners();
  }

  getUserDetails() {
    //Here we get complete userdata
    _service.getUserData().then((value) {
      this.userDetails = value;
      notifyListeners();
    });
  }

  clearData() {
    this.urlList = [];
    dataToFirestore = {};
    notifyListeners();
  }

  clearSelectedCat() {
    this.selectedCategory = null;
    this.selectedSubCat = null;
    notifyListeners();
  }
}
