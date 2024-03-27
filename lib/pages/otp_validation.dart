// import 'dart:async';
// import 'dart:convert';
// import 'package:email_otp/email_otp.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_application_1/UserProfilePgale.dart';
// import 'package:flutter_application_1/pages/mainchat.dart';
// import 'package:flutter_application_1/utils.dart';
// import 'package:http/http.dart' as http;
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_application_1/pages/details.dart';
// import 'package:flutter_application_1/pages/popupdialog.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OtpScreen extends StatefulWidget {
//   // const OtpScreen({Key? key, required this.myauth}) : super(key: key);
//   // final EmailOTP myauth;
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   late SharedPreferences sp;
//   bool isotpenable = false;
//   bool isverify = false;
//   int otp = 0;
//   //EmailOTP myauth = EmailOTP();
//   TextEditingController t1 = TextEditingController();
//   TextEditingController t2 = TextEditingController();
//   TextEditingController t3 = TextEditingController();
//   TextEditingController t4 = TextEditingController();
//   TextEditingController t5 = TextEditingController();
//   TextEditingController t6 = TextEditingController();
//   GlobalKey<FormState> formkey = GlobalKey();

//   String code = '';
//   int timecount = 0;
//   Timer? timer;

//   bool istimetextvisible = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//     print(Mobile.mobile);
//   }

//   Future GetDetailsData() async {
//     Map data = {'mobile': Mobile.mobile};
//     print(data);
//     try {
//       var response = await http.post(
//           Uri.http(MyUrl.mainurl, MyUrl.suburl + "email_check.php"),
//           body: data);
//       var jsondata = jsonDecode(response.body);
//       if (jsondata['status'] == true) {
//         // ignore: unused_local_variable
//         Details fatchdata = Details(
//             jsondata['userid'],
//             jsondata['username'],
//             jsondata['email'],
//             jsondata['bio'],
//             jsondata['uploadpic'],
//             jsondata['mobile']);
//         sp = await SharedPreferences.getInstance();
//         sp.setString("userid", jsondata['userid']);
//         sp.setString("name", jsondata['username']);
//         sp.setString("email", jsondata['email']);
//         sp.setString("bio", jsondata['bio']);
//         sp.setString("photo", jsondata['uploadpic']);
//         sp.setString("mobile", jsondata['mobile']);

//         Navigator.pop(context);
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainChat()));
//       } else {
//         Navigator.pop(context);
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: ((context) => UserProfilePage())));
//       }
//     } catch (e) {
//       print('modon');
//       Fluttertoast.showToast(msg: "Future: " + e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: unused_local_variable
//     double height = MediaQuery.of(context).size.height;
//     // ignore: unused_local_variable
//     double width = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         // backgroundColor: Colors.blueAccent,
//         body: SingleChildScrollView(
//           child: Container(
//             height: height,
//             child: Column(
//               children: [
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 50, 0, 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             width: 50,
//                             height: 50,
//                             // ignore: sort_child_properties_last
//                             child: IconButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 icon: (Icon(Icons.arrow_back_ios,
//                                     size: 24, color: Colors.black45))),

//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(color: Colors.black87)),
//                           ),
//                           const Text(
//                             "VERIFICATION CODE",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           Container(
//                             width: 50,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
//                         child: Container(
//                           child: Image.asset(
//                             "assets/images/otp.png",
//                             height: 250,
//                             width: 300,
//                           ),
//                         )),
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                     // height: MediaQuery.of(context).size.height,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           topRight: Radius.circular(30)),
//                       gradient: LinearGradient(
//                         colors: [Colors.purple, Colors.blueAccent],
//                         begin: Alignment.bottomLeft,
//                         end: Alignment.topRight,
//                         stops: [0.10, 0.7],
//                         tileMode: TileMode.repeated,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(top: 20),
//                           child: Center(
//                             child: AnimatedTextKit(
//                               animatedTexts: [
//                                 TyperAnimatedText(
//                                   'we texted you a code please enter it bellow',
//                                   textStyle: const TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.white,
//                                       fontStyle: FontStyle.italic),
//                                   speed: Duration(milliseconds: 100),
//                                 ),
//                               ],
//                               repeatForever: true,
//                               isRepeatingAnimation: true,
//                             ),
//                           ),
//                         ),
//                         Form(
//                             key: formkey,
//                             child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: TextFormField(
//                                       controller: t1,
//                                       onChanged: (value) {
//                                         if (value.length == 1) {
//                                           FocusScope.of(context).nextFocus();
//                                         }
//                                         //  else if (value.isEmpty) {
//                                         //   FocusScope.of(context)
//                                         //       .previousFocus();
//                                         // }
//                                       },
//                                       decoration: InputDecoration(
//                                           hintStyle:
//                                               TextStyle(color: Colors.white),
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.white)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   width: 3,
//                                                   color: Colors.white),
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       inputFormatters: [
//                                         LengthLimitingTextInputFormatter(1),
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: TextFormField(
//                                       controller: t2,
//                                       onChanged: (value) {
//                                         if (value.length == 1) {
//                                           FocusScope.of(context).nextFocus();
//                                         } else if (value.isEmpty) {
//                                           FocusScope.of(context)
//                                               .previousFocus();
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.white)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   width: 3,
//                                                   color: Colors.white),
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       inputFormatters: [
//                                         LengthLimitingTextInputFormatter(1),
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: TextFormField(
//                                       controller: t3,
//                                       onChanged: (value) {
//                                         if (value.length == 1) {
//                                           FocusScope.of(context).nextFocus();
//                                         } else if (value.isEmpty) {
//                                           FocusScope.of(context)
//                                               .previousFocus();
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.white)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   width: 3,
//                                                   color: Colors.white),
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       inputFormatters: [
//                                         LengthLimitingTextInputFormatter(1),
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: TextFormField(
//                                       controller: t4,
//                                       onChanged: (value) {
//                                         if (value.length == 1) {
//                                           FocusScope.of(context).nextFocus();
//                                         } else if (value.isEmpty) {
//                                           FocusScope.of(context)
//                                               .previousFocus();
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.white)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   width: 3,
//                                                   color: Colors.white),
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       inputFormatters: [
//                                         LengthLimitingTextInputFormatter(1),
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: TextFormField(
//                                       controller: t5,
//                                       onChanged: (value) {
//                                         if (value.length == 1) {
//                                           FocusScope.of(context).nextFocus();
//                                         } else if (value.isEmpty) {
//                                           FocusScope.of(context)
//                                               .previousFocus();
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors.white)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   width: 3,
//                                                   color: Colors.white),
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       inputFormatters: [
//                                         LengthLimitingTextInputFormatter(1),
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: TextFormField(
//                                       controller: t6,
//                                       onChanged: (value) {
//                                         if (value.length == 1) {
//                                           //FocusScope.of(context).nextFocus();
//                                         } else if (value.isEmpty) {
//                                           FocusScope.of(context)
//                                               .previousFocus();
//                                         }
//                                       },
//                                       decoration: InputDecoration(
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors.white)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   width: 3,
//                                                   color: Colors.white),
//                                               borderRadius:
//                                                   BorderRadius.circular(10))),
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                       keyboardType: TextInputType.number,
//                                       textAlign: TextAlign.center,
//                                       inputFormatters: [
//                                         LengthLimitingTextInputFormatter(1),
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )),
//                         Container(
//                           child: const Text(
//                             "This helps us every user in our chat",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontStyle: FontStyle.italic,
//                                 color: Colors.white),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               child: const Text(
//                                 "Did not get ?",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontStyle: FontStyle.italic),
//                               ),
//                             ),
//                             Container(
//                               child: Visibility(
//                                 visible: isotpenable,
//                                 child: TextButton(
//                                   // ignore: sort_child_properties_last
//                                   child: const Text(
//                                     "Resend",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   ),
//                                   onPressed: isotpenable
//                                       ? () {
//                                           showDialog(
//                                               barrierDismissible: false,
//                                               context: context,
//                                               builder: (context) {
//                                                 return PinDialog(otp);
//                                               });
//                                         }
//                                       : null,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Container(
//                           child: Visibility(
//                             visible: istimetextvisible,
//                             child: Text(
//                               "00:$timecount sec",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(left: 30, right: 30),
//                           child: SizedBox(
//                             //   width: 100,
//                             width: MediaQuery.of(context).size.width,
//                             height: 60,
//                             child: ElevatedButton(
//                               onPressed: isverify
//                                   ? null
//                                   : () async {
//                                       if (formkey.currentState!.validate()) {
//                                         setState(() {
//                                           isverify = true;
//                                         });
//                                         code = t1.text +
//                                             t2.text +
//                                             t3.text +
//                                             t4.text +
//                                             t5.text +
//                                             t6.text;
//                                         // if (await widget.myauth
//                                         //         .verifyOTP(otp: code) ==
//                                         //     true) {
//                                         //   ScaffoldMessenger.of(context)
//                                         //       .showSnackBar(const SnackBar(
//                                         //     content: Text("OTP is verified"),
//                                         //   ));
//                                         //   GetDetailsData();
//                                         // } else {
//                                         //   ScaffoldMessenger.of(context)
//                                         //       .showSnackBar(const SnackBar(
//                                         //     content: Text("Invalid OTP"),
//                                         //   ));
//                                         // }
//                                       }
//                                     },
//                               style: ButtonStyle(
//                                 backgroundColor: const MaterialStatePropertyAll(
//                                     Color.fromARGB(251, 248, 248, 245)),
//                                 shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(18.0),

//                                         //  side: BorderSide(color: Colors.white)
//                                         side: BorderSide(color: Colors.black))),
//                               ),
//                               child: isverify
//                                   ? const Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Verifying",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 20),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         CircularProgressIndicator(
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   : const Text(
//                                       "Verify",
//                                       style: TextStyle(
//                                           fontSize: 15, color: Colors.black),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
