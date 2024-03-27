import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class Mobile {
//   static String mobile = '';
//   Mobile(e) {
//     mobile = e;
//   }
// }

class VerifyId {
  static String verify = '';
  VerifyId(v) {
    verify = v;
  }
}

class Details {
  String userid = '';
  String name = '';
  String mobile = '';
  String bio = '';
  String photo = '';
  String email = '';

  Details(
      this.userid, this.name, this.mobile, this.bio, this.photo, this.email);
}

class AllUsers {
  AllUsers({
    required this.userId,
    required this.productImage,
    required this.mobile,
    required this.name,
    required this.bio,
    required this.email,
  });
  late String userId;
  late String productImage;
  late String mobile;
  late String name;
  late String bio;
  late String email;

  AllUsers.fromJson(Map<String, dynamic> json) {
    userId = json['user_Id'] ?? '';
    productImage = json['product_image'] ?? '';
    mobile = json['mobile'] ?? '';
    name = json['name'] ?? '';
    bio = json['bio'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_Id'] = userId;
    data['product_image'] = productImage;
    data['mobile'] = mobile;
    data['name'] = name;
    data['bio'] = bio;
    data['email'] = email;
    return data;
  }
}

class SpecificUser {
  String userid = '';
  String photo = '';
  String mobile = '';
  String name = '';
  String bio = '';
  String email = '';

  SpecificUser(
      {required this.userid,
      required this.photo,
      required this.mobile,
      required this.name,
      required this.bio,
      required this.email});
}

class User {
  final String userId;
  final String productImage;
  final String mobile;
  final String name;
  final String bio;
  final String email;
  User({
    required this.userId,
    required this.productImage,
    required this.mobile,
    required this.name,
    required this.bio,
    required this.email,
  });

  toJson() {
    return {"name": name, "mobile": mobile};
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return User(
        userId: data['user_Id'],
        productImage: data['product_image'],
        mobile: data['mobile'],
        name: data['name'],
        bio: data['bio'],
        email: data['email']);
  }
}
