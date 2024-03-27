import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_1/pages/login.dart';

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  String dropdownValue = 'English';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 234, 235),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Welcome To DP Chat',
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: true,
                    isRepeatingAnimation: true,
                  ),
                ),
              ),
              Container(
                height: 300,
                width: 300,
                child: Image.asset("assets/images/chat.png"),
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(top: 30),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          style: TextStyle(fontSize: 20),
                          children: [
                            TextSpan(
                                text: "Read our ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: "Privacy Policy.",
                                style: TextStyle(color: Colors.blue)),
                            TextSpan(
                                text: 'Tap "Agree and continue" to accept the ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: "Terms and Services.",
                                style: TextStyle(color: Colors.blue))
                          ]))),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green, //background color

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPrimary: Colors.black //text color
                          ),
                      child: const Text(
                        "Agree and continue",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red, //background color
                          onPrimary: Colors.white //text color
                          ),
                      child: const Text(
                        "RESTORE BACKUP",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         height: 20,
              //         width: 20,
              //         child: Image.asset("assets/images/language.png"),
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       // Container(
              //       //   child: DropdownButton<String>(
              //       //     dropdownColor: Colors.black,
              //       //     value: dropdownValue,
              //       //     items: <String>['English', 'Bengali', 'Hindi', 'Arabian']
              //       //         .map<DropdownMenuItem<String>>((String value) {
              //       //       return DropdownMenuItem<String>(
              //       //         value: value,
              //       //         child: Text(
              //       //           value,
              //       //           style: const TextStyle(
              //       //             fontSize: 20,
              //       //             color: Colors.white,
              //       //           ),
              //       //         ),
              //       //       );
              //       //     }).toList(),
              //       //     onChanged: (String? newValue) {
              //       //       setState(() {
              //       //         dropdownValue = newValue!;
              //       //       });
              //       //     },
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
