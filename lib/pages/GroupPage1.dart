import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_application_1/pages/GroupPage2.dart';

class GrouPage1 extends StatefulWidget {
  const GrouPage1({super.key});

  @override
  State<GrouPage1> createState() => _GrouPage1State();
}

class _GrouPage1State extends State<GrouPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            child: Image.asset("assets/images/group.png"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Stay connect with a",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                "community",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text(
                    "Communities bring members together in",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "topic-based groups, and make it easy to get",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "admin announcements.Any community ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "you're added to will appear here.",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupPage2()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(250, 107, 204, 144)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        child: Text(
                          "Srart your community",
                          style: TextStyle(fontSize: 20),
                        ))),
              ),
            ],
          )
        ],
      )),
    );
  }
}
