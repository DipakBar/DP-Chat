import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_application_1/pages/mainchat.dart';
import 'package:flutter_application_1/pages/page1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Flash extends StatefulWidget {
  @override
  State<Flash> createState() => FlashState();
}

class FlashState extends State<Flash> {
  static String mobile = '';
  late SharedPreferences sp;
  Future getData() async {
    sp = await SharedPreferences.getInstance();
    mobile = sp.getString('mobile') ?? "";
  }

  @override
  void initState() {
    getData();

    super.initState();
    Timer(Duration(seconds: 2), () {
      if (mobile == "") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Myapp()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainChat()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(2, 2, 2, 2),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/plash.png",
                  height: 300,
                  width: 300,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                "Developed By Dipak",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
