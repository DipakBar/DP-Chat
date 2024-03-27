// import 'dart:convert';
// import 'dart:io';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_application_1/pages/Loadingdialog_page.dart';
// import 'package:flutter_application_1/pages/details.dart';
// import 'package:flutter_application_1/pages/login.dart';
// import 'package:flutter_application_1/pages/mainchat.dart';
// import 'package:flutter_application_1/utils.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class profileinfoEx extends StatefulWidget {
//   @override
//   State<profileinfoEx> createState() => _profileinfoExState();
// }

// class _profileinfoExState extends State<profileinfoEx> {
//   late SharedPreferences sp;

//   final GlobalKey<FormState> formkey = GlobalKey();
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController bio = TextEditingController();
//   File? pickedImage;
//   imagePickerOption() {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
//           height: 180,
//           child: Column(
//             children: [
//               Text(
//                 "Pic Image From",
//                 style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   pickImage(ImageSource.camera);
//                 },
//                 icon: const Icon(
//                   Icons.camera,
//                   color: Colors.black,
//                 ),
//                 label: const Text(
//                   "CAMERA",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   pickImage(ImageSource.gallery);
//                 },
//                 icon: const Icon(
//                   Icons.image,
//                   color: Colors.black,
//                 ),
//                 label: const Text(
//                   "GALLERY",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 icon: const Icon(
//                   Icons.close,
//                   color: Colors.black,
//                 ),
//                 label: const Text(
//                   "CANCEL",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   pickImage(ImageSource imageType) async {
//     try {
//       final photo = await ImagePicker().pickImage(source: imageType);
//       if (photo == null) return;
//       final tempImage = File(photo.path);
//       setState(() {
//         pickedImage = tempImage;
//       });

//       Get.back();
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }

//   Future createprofile(
//     File? uphoto,
//     String uphone,
//     String uname,
//     String uemail,
//     String ubio,
//   ) async {
//     try {
//       var request = http.MultipartRequest(
//           "POST", Uri.parse(MyUrl.fullurl + "update_profile.php"));

//       if (uphoto != null)
//         request.files.add(await http.MultipartFile.fromBytes(
//             'u_image', uphoto.readAsBytesSync(),
//             filename: uphoto.path.split("/").last));

//       request.fields['u_phone'] = uphone;
//       request.fields['u_name'] = uname;
//       request.fields['u_email'] = uemail;
//       request.fields['u_bio'] = ubio;

//       var response = await request.send();
//       var responded = await http.Response.fromStream(response);
//       var jsondata = jsonDecode(responded.body);

//       if (jsondata['status'] == true) {
//         // ignore: unused_local_variable
//         Details fatchdata = Details(
//             jsondata["userid"],
//             jsondata["username"],
//             jsondata["mobile"],
//             jsondata["bio"],
//             jsondata["uploadpic"].toString(),
//             jsondata["email"]);
//         sp = await SharedPreferences.getInstance();
//         sp.setString("userid", jsondata['userid']);
//         sp.setString("name", jsondata['username']);
//         sp.setString("mobile", jsondata['mobile']);
//         sp.setString("bio", jsondata['bio']);
//         sp.setString("photo", jsondata['uploadpic'].toString());
//         sp.setString("email", jsondata['email']);

//         Navigator.pop(context);
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => MainChat()));
//         Fluttertoast.showToast(
//           gravity: ToastGravity.CENTER,
//           msg: jsondata['msg'],
//         );
//       } else {
//         Fluttertoast.showToast(
//           gravity: ToastGravity.CENTER,
//           msg: jsondata['msg'],
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       Fluttertoast.showToast(
//         gravity: ToastGravity.CENTER,
//         msg: e.toString(),
//       );
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: true,
//           title: Text("profile info"),
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => LoginPage()));
//               },
//               icon: (Icon(Icons.arrow_back, color: Colors.white))),
//           actions: [
//             IconButton(
//                 onPressed: () {},
//                 icon: (Icon(Icons.settings, color: Colors.white))),
//           ],
//         ),
//         backgroundColor: Color.fromARGB(255, 239, 240, 241),
//         body: Container(
//           child: Container(
//             padding: EdgeInsets.only(left: 15, top: 20, right: 15),
//             child: GestureDetector(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//               },
//               child: ListView(children: [
//                 Container(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Center(
//                     child: AnimatedTextKit(
//                       animatedTexts: [
//                         TyperAnimatedText(
//                           'Please provide your name and other details',
//                           textStyle: const TextStyle(
//                               fontSize: 15,
//                               color: Colors.black,
//                               fontStyle: FontStyle.italic),
//                           speed: Duration(milliseconds: 100),
//                         ),
//                       ],
//                       repeatForever: true,
//                       isRepeatingAnimation: true,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.indigo, width: 5),
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(100),
//                           ),
//                         ),
//                         child: ClipOval(
//                           child: pickedImage != null
//                               ? Image.file(
//                                   pickedImage!,
//                                   width: 170,
//                                   height: 170,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.asset(
//                                   "assets/images/default.png",
//                                   width: 170,
//                                   height: 170,
//                                   color: Colors.blue,
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: IconButton(
//                           onPressed: imagePickerOption,
//                           icon: Icon(Icons.add_a_photo),
//                           color: Color.fromARGB(255, 15, 15, 15),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Form(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       key: formkey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: name,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'please enter name';
//                               } else if (value.length < 2) {
//                                 return 'To short';
//                               }
//                               return null;
//                             },
//                             keyboardType: TextInputType.name,
//                             decoration: const InputDecoration(
//                               labelText: "Enter your name",
//                               labelStyle: TextStyle(color: Colors.black),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black)),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           TextFormField(
//                             controller: email,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'please enter email no.';
//                               }
//                               // else if (value.length != 10) {
//                               //   return "mobile number must be on 10 digits";
//                               // }

//                               else if (!RegExp(
//                                       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                   .hasMatch(value)) {
//                                 return "enter valid gmail_id.";
//                               }
//                               return null;
//                             },
//                             keyboardType: TextInputType.text,
//                             decoration: const InputDecoration(
//                               labelText: "Enter your gmail",
//                               labelStyle: TextStyle(color: Colors.black),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black)),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           TextFormField(
//                             controller: bio,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'please enter email';
//                               }
//                               return null;
//                             },
//                             keyboardType: TextInputType.multiline,
//                             maxLines: 2,
//                             decoration: const InputDecoration(
//                               labelText: "Bio",
//                               labelStyle: TextStyle(color: Colors.black),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black)),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(10.0),
//                   child: SizedBox(
//                     width: 200,
//                     height: 50,
//                     child: ElevatedButton(
//                         onPressed: () {
//                           if (formkey.currentState!.validate()) {
//                             showDialog(
//                               context: context,
//                               builder: (context) => LoadingDiologPage(),
//                             );

//                             createprofile(pickedImage, Mobile.mobile, name.text,
//                                 email.text, bio.text);
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.blue, //background color
//                             onPrimary: Colors.white //text color
//                             ),
//                         child: const Text(
//                           "Confirm",
//                           style: TextStyle(fontSize: 15),
//                         )),
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
