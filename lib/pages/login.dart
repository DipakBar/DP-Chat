import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/UserProfilePgale.dart';
import 'package:flutter_application_1/controlers/auth_service.dart';
import 'package:flutter_application_1/pages/Loadingdialog_page.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/mainchat.dart';

import 'package:flutter_application_1/pages/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences sp;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();
  bool user = false;
  List<User> Userlist = [];

  phone() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('mobile', _phoneController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<User> SingleUser(String mobile) async {
    print(mobile);
    final db = FirebaseFirestore.instance;
    final response = await db
        .collection('userprofile')
        .where('mobile', isEqualTo: mobile.toString())
        .get();
    final userdata = response.docs.map((e) => User.fromSnapshot(e)).single;
    return userdata;
  }

  void check() {
    if (Userlist.isNotEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => MainChat())));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => UserProfilePage())));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 50, 0, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          const Text(
                            'REGISTER MOBILE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          PopupMenuButton(
                            color: Colors.black,
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            ),
                            elevation: 0,
                            itemBuilder: (context) => [
                              const PopupMenuItem<int>(
                                height: 30,
                                value: 0,
                                child: Center(
                                    child: Text(
                                  'Help',
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ],
                            onSelected: (value) => selecteitem(context, value),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                        child: Container(
                          child: Image.asset(
                            "assets/images/group2.jpg",
                            height: 280,
                            width: 300,
                          ),
                        )),
                  ],
                ),
                Container(
                  height: height * 0.44,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.black45,
                            Color.fromRGBO(0, 41, 102, 1)
                          ])),
                  child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 25, 29, 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _phoneController,
                                    validator: (value) {
                                      if (value == null ||
                                          !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[(]{0,1}[-\s\./0-9]+$')
                                              .hasMatch(value)) {
                                        return 'Please Enter Your PhoneNumber';
                                      } else if (value.length != 10 ||
                                          _phoneController.text.length < 10) {
                                        return "Number must be at least 10 digits";
                                      }

                                      return null;
                                    },
                                    showCursor: true,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: "Mobile",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                          //Outline border type for TextFeild
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          //Outline border type for TextFeild
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                            color: Colors.redAccent,
                                            width: 1,
                                          )),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (_formkey.currentState!.validate()) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => LoadingDiologPage(),
                                  );

                                  // Mobile.mobile = _phoneController.text;
                                  AuthService.sentOtp(
                                      phone: _phoneController.text,
                                      errorStep: () =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              "Error in sending OTP",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          )),
                                      nextStep: () {
                                        showDialog(
                                          context: context,
                                          builder: ((context) => AlertDialog(
                                                title: Text("OTP Verification"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Enter 6 digits OTP"),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Form(
                                                      key: _formkey1,
                                                      child: TextFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          controller:
                                                              _otpController,
                                                          validator: (value) {
                                                            if (value!.length !=
                                                                6) {
                                                              return "Invalid OTP";
                                                            }

                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "",
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            prefixIcon: Icon(
                                                              Icons.phone,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                                    //Outline border type for TextFeild
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            20)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 3,
                                                                    )),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                                    //Outline border type for TextFeild
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            20)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1,
                                                                    )),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            20)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .redAccent,
                                                                      width: 1,
                                                                    )),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        if (_formkey1
                                                            .currentState!
                                                            .validate()) {
                                                          AuthService.loginWithOtp(
                                                                  otp:
                                                                      _otpController
                                                                          .text)
                                                              .then((value) {
                                                            if (value ==
                                                                "succes") {
                                                              print('success');
                                                              phone();
                                                              SingleUser(_phoneController
                                                                      .text
                                                                      .toString())
                                                                  .whenComplete(
                                                                      () =>
                                                                          check());
                                                              // check();

                                                              // Navigator.of(
                                                              //         context)
                                                              //     .pushReplacement(
                                                              //         MaterialPageRoute(
                                                              //             builder: ((context) =>
                                                              //                 UserProfilePage())));
                                                            } else {
                                                              // Navigator.pop(
                                                              //     context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ));
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Text('Submit'))
                                                ],
                                              )),
                                        );
                                      });
                                }
                              },
                              child: Container(
                                height: 70,
                                width: 200,
                                // ignore: sort_child_properties_last
                                child: const Align(
                                  child: Text(
                                    'SEND OTP',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 20),
                                  ),
                                ),
                                decoration: const BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30))),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  selecteitem(BuildContext context, value) {
    switch (value) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FormEx()));
    }
  }
}
