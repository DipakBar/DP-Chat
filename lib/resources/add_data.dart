// import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// final FirebaseStorage _storage = FirebaseStorage.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// class StoreData {
//   Future<String> UploadImageToStorage(Uint8List file) async {
//     Reference ref = _storage.ref().child('profileImage');
//     UploadTask uploadTask = ref.putData(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     print(downloadUrl);
//     return downloadUrl;
//   }

//   Future<String> saveData(
//       {required String id,
//       required String name,
//       required String email,
//       required String bio,
//       required Uint8List file}) async {
//     String resp = "Some error occoured";
//     try {
//       if (name.isNotEmpty || bio.isNotEmpty) {
//         String imageUrl = await UploadImageToStorage(file);
//         print(imageUrl);
//         await _firestore.collection('userprofile').add({
//           'id': id,
//           'name': name,
//           'email': email,
//           'bio': bio,
//           'imageLink': imageUrl
//         });
//         resp = 'success';
//       }
//     } catch (err) {
//       resp = err.toString();
//     }
//     return resp;
//   }
// }
