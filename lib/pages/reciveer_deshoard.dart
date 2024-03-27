// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/details.dart';
// import 'package:flutter_application_1/pages/gidview.dart';
// import 'package:flutter_application_1/pages/reciveer_deshoard_photo.dart';
// import 'package:flutter_application_1/pages/senderreciverimage.dart';
// import 'package:flutter_application_1/utils.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// // import 'package:flutter_application_1/utils.dart';

// // ignore: must_be_immutable
// class ReciverDeshboard extends StatefulWidget {
//   Details user;
//   // ignore: use_key_in_widget_constructors
//   ReciverDeshboard(this.user);
//   @override
//   // ignore: no_logic_in_create_state
//   State<ReciverDeshboard> createState() => _ReciverDeshboardState(user);
// }

// class _ReciverDeshboardState extends State<ReciverDeshboard> {
//   Details user;
//   _ReciverDeshboardState(this.user);
//   // bool isselected = false;
//   // void itemswitch(bool value) {
//   //   setState(() {
//   //     isselected = !isselected;
//   //   });
//   // }

//   late SharedPreferences sp;
//   String sendid = '';
//   List<SenderReciverImage> messages = [];

//   @override
//   void initState() {
//     super.initState();

//     getSenderId().whenComplete(() {
//       getMessage(sendid, user.userid).then((value) {
//         setState(() {});
//       });
//     });
//   }

//   Future getSenderId() async {
//     sp = await SharedPreferences.getInstance();
//     sendid = sp.getString('userid') ?? "";
//   }

//   Future getMessage(String sendid, String receiveid) async {
//     try {
//       Map data = {'sender_id': sendid, 'receiver_id': receiveid};

//       var response = await http.post(
//           // ignore: prefer_interpolation_to_compose_strings
//           Uri.http(MyUrl.mainurl, MyUrl.suburl + "sender_reciver_image.php"),
//           body: data);

//       var jsondata = jsonDecode(response.body);
//       if (jsondata['status'] == true) {
//         messages.clear();
//         for (int i = 0; i < jsondata['data'].length; i++) {
//           SenderReciverImage sri = SenderReciverImage(
//             attachment: jsondata['data'][i]['attachment'],
//           );
//           messages.add(sri);
//         }
//         // setState(() {});
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       // Navigator.pop(context);
//     }
//   }

//   imagePickerOption() {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
//           height: 100,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ReciverDeshboardPhoto(user)));
//                   },
//                   child: const Text(
//                     'View the profile photo',
//                     style: TextStyle(fontSize: 15, color: Colors.black),
//                   )),
//               TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'View status',
//                     style: TextStyle(fontSize: 15, color: Colors.black),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.arrow_back_ios)),
//                   IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.more_vert_sharp)),
//                 ],
//               ),
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blueAccent, width: 5),
//                     borderRadius: const BorderRadius.all(
//                       Radius.circular(100),
//                     ),
//                   ),
//                   child: InkWell(
//                       onTap: imagePickerOption,
//                       child: user.photo != ''
//                           ? ClipOval(
//                               child: Image.network(
//                               MyUrl.fullurl + MyUrl.imageurl + user.photo,
//                               width: 120,
//                               height: 120,
//                               fit: BoxFit.cover,
//                             ))
//                           : CircleAvatar(
//                               radius: 60,
//                               child: Text(
//                                 user.name[0],
//                                 style: const TextStyle(fontSize: 50),
//                               ),
//                             )),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     user.name,
//                     style: const TextStyle(
//                         fontSize: 20, fontStyle: FontStyle.italic),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     user.mobile,
//                     style: const TextStyle(fontStyle: FontStyle.italic),
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       children: [
//                         IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.call,
//                               size: 40,
//                               color: Colors.green,
//                             )),
//                         const Text(
//                           "Call",
//                           style: TextStyle(color: Colors.green, fontSize: 15),
//                         )
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.video_call,
//                               size: 40,
//                               color: Colors.green,
//                             )),
//                         const Text(
//                           "Video",
//                           style: TextStyle(color: Colors.green, fontSize: 15),
//                         )
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.paid_outlined,
//                               size: 40,
//                               color: Colors.green,
//                             )),
//                         const Text(
//                           "Pay",
//                           style: TextStyle(color: Colors.green, fontSize: 15),
//                         )
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.search,
//                               size: 40,
//                               color: Colors.green,
//                             )),
//                         const Text(
//                           "Search",
//                           style: TextStyle(color: Colors.green, fontSize: 15),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               const Divider(thickness: 1.5),
//               // ignore: avoid_unnecessary_containers
//               Container(
//                 child: Text(
//                   user.bio,
//                   style: const TextStyle(
//                       fontSize: 20, fontStyle: FontStyle.italic),
//                 ),
//               ),
//               const Divider(thickness: 1.5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Media,links,and docs"),
//                   IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Gidview(user)));
//                       },
//                       icon: const Icon(Icons.arrow_forward_ios)),
//                 ],
//               ),
//               // ignore: sized_box_for_whitespace
//               Container(
//                 height: 80,
//                 child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: messages.length,
//                     separatorBuilder: (context, index) => const SizedBox(
//                           width: 10,
//                         ),
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.blueGrey)),
//                         child: Image.network(
//                           cacheWidth: 165,
//                           MyUrl.fullurl +
//                               MyUrl.chaturl +
//                               messages[index].attachment,
//                           width: 150,
//                         ),
//                       );
//                     }),
//               ),
//               const Divider(thickness: 1.5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
