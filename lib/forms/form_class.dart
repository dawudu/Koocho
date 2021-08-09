import 'package:flutter/material.dart';
import 'package:koocho/provider/cat_provider.dart';

class FormClass {
  List accessories = [
    'Motion Graphics',
    'Motion Design'
  ]; //Digital Art types-- change this name

  List tabType = [
    'Surrealism',
    'Dadaism'
  ]; // Absatract Art types -- change this name

  List apartmentType = [
    'Baby clothes',
    'Baby shoes',
    'Baby remedies'
  ]; // Baby items types -- change this name

  List furnishing = [
    '0-6 months',
    '6 months -1 year',
    '1- 2years'
  ]; //  -- change this name them

  List consStatus = [
    //Change this
    'Class A(Local)',
    'Class A(Continental)',
    'Class A(International)'
  ]; //  -- change this name them

  List number = ['New', 'Old', 'Unsure']; // -- change this name

  Widget appBar(CategoryProvider _provider) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.yellow,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(bottom: BorderSide(color: Colors.black)),
      title: Text(
        _provider.selectedSubCat,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
