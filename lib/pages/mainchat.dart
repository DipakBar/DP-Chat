import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/ChattingListPage.dart';

import 'package:flutter_application_1/pages/Setting.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainChat extends StatefulWidget {
  @override
  State<MainChat> createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  late SharedPreferences sp;
  late Details detailsobj;
  String name = '', mobile = '', bio = '', photo = '', email = '', userid = '';
  Future getUserDetails() async {
    sp = await SharedPreferences.getInstance();
    userid = sp.getString("userid") ?? '';
    name = sp.getString("name") ?? '';
    mobile = sp.getString("mobile") ?? '';
    bio = sp.getString("bio") ?? '';
    photo = sp.getString("photo") ?? '';
    email = sp.getString("email") ?? '';
  }

  @override
  void initState() {
    getUserDetails().whenComplete(() {
      detailsobj = Details(userid, name, mobile, bio, photo, email);
    });
    //TODO: implement initState
    super.initState();
  }

  int currentTab = 0;
  // List<Widget> screens = [ChattingListPageEx(), StatusPageEx(), CallsPage()];

  PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = ChattingListPageEx();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          height: 60,
          margin: const EdgeInsets.fromLTRB(100, 10, 120, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = ChattingListPageEx();
                    currentTab = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      color: currentTab == 0 ? Colors.white : Colors.black,
                    ),
                    Text(
                      "Chat",
                      style: TextStyle(
                          color: currentTab == 0 ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = SettingPage(detailsobj);
                    currentTab = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      color: currentTab == 3 ? Colors.white : Colors.black,
                    ),
                    Text(
                      "Setting",
                      style: TextStyle(
                          color: currentTab == 3 ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
