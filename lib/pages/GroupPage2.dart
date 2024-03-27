import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class GroupPage2 extends StatefulWidget {
  const GroupPage2({super.key});

  @override
  State<GroupPage2> createState() => _GroupPage2State();
}

class _GroupPage2State extends State<GroupPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          child: Image.asset("assets/images/group2.jpg"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create a new community",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  "Bring together a neighbourhood, school",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "or more. Create topic-based groups for",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "members, and easily send them admin",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "announcements..",
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
                      onPressed: () {},
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
                        "Get started",
                        style: TextStyle(fontSize: 20),
                      ))),
            ),
          ],
        )
      ],
    )));
  }
}
