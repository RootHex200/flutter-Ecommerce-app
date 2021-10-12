import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomarce/const/AppColors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _decController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Product');
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  var url;
  captureimage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = photo;
    });
  }
    Future<void> uploadFile() async {
    File file = File(image!.path);
    final String fileName = path.basename(image!.path);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('product_image/${fileName}')
          .putFile(file);
      downloadURLExample(fileName);
    } catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
  }
  
  Future<void> downloadURLExample(fileName) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('product_image/${fileName}')
        .getDownloadURL();
    print("this is return value of ur;${downloadURL}");
    setState(() {
      url = downloadURL;
    });
    print(url);
  }

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new us
    return users
        .add({
          "description": _decController.text,
          "product-name": _nameController.text,
          "product-price": _priceController.text,
          "product": _productController.text,
          "product-img": [url],
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: [
          Container(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _nameController,
              decoration: InputDecoration(hintText: "enter product name: "),
                              toolbarOptions: ToolbarOptions(
                  paste: true,
                  cut: true,
                  copy: true,
                  selectAll: true,
                )
            ),
          ),
          Container(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _priceController,
              decoration: InputDecoration(hintText: "enter product price: "),
                              toolbarOptions: ToolbarOptions(
                  paste: true,
                  cut: true,
                  copy: true,
                  selectAll: true,
                )
            ),
          ),
          Container(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _productController,
              decoration: InputDecoration(hintText: "enter product: "),
                              toolbarOptions: ToolbarOptions(
                  paste: true,
                  cut: true,
                  copy: true,
                  selectAll: true,
                )
            ),
          ),
          Container(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _decController,
              decoration:
                  InputDecoration(hintText: "enter product Description: "),
                                  toolbarOptions: ToolbarOptions(
                  paste: true,
                  cut: true,
                  copy: true,
                  selectAll: true,
                )
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: () {
                addUser();
              },
              child: Text(
                "Upload New Proudt Data",
                style: TextStyle(color: AppColors.deep_orange),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
            Container(
            child: RaisedButton(onPressed: () => {captureimage()},child: Text("pick image"),),
          ),
          SizedBox(width:3),
                      Container(
            child: RaisedButton(onPressed: () => {uploadFile()},child: Text("Upload image"),),
          ),
            ],
          ),
          Container(
            height: 100,
            child: image == null ? Text("") : Image.file(File(image!.path)),
          ),
          Container(
            child: url == null ? Text("no data found") : Text("data found succefully"),
          ),

        ],
      ),
    );
  }
}
