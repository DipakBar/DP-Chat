import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseInstanc = FirebaseFirestore.instance;

  final FirebaseInstance = FirebaseFirestore.instance;
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  Future<void> addNewProduct(Map productdata, File image) async {
    var pathimage = image.toString();
    var temp = pathimage.lastIndexOf('/');
    var result = pathimage.substring(temp + 1);
    print(result);
    final ref =
        FirebaseStorage.instance.ref().child('profile_images').child(result);
    var response = await ref.putFile(image);
    print("Updated $response");
    var imageUrl = await ref.getDownloadURL();

    try {
      // CommanDialog.showLoading();
      var response = await FirebaseInstance.collection('userprofile').add({
        'name': productdata['name'],
        'mobile': productdata['mobile'],
        'email': productdata['email'],
        "bio": productdata['bio'],
        'product_image': imageUrl,
        'user_Id': id,
      });
      print("Firebase response1111 $response");
      Get.back();
    } catch (exception) {
      print("Error Saving Data at firestore $exception");
    }
  }

  // ignore: non_constant_identifier_names
  // Future<User> SingleUser(String mobile) async {
  //   print(mobile);

  //   final response = await FirebaseInstanc.collection('userprofile')
  //       .where('mobile', isEqualTo: mobile)
  //       .get();
  //   final userdata = response.docs.map((e) => User.fromSnapshot(e)).single;
  //   return userdata;

  // }
}
