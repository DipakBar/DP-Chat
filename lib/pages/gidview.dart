import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/senderreciverimage.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Gidview extends StatefulWidget {
  Details user;
  Gidview(this.user);

  @override
  State<Gidview> createState() => _GidviewState(user);
}

class _GidviewState extends State<Gidview> {
  Details user;
  _GidviewState(this.user);
  late SharedPreferences sp;
  String sendid = '';
  List<SenderReciverImage> messages = [];

  @override
  void initState() {
    super.initState();

    getSenderId().whenComplete(() {
      getMessage(sendid, user.userid).then((value) {
        setState(() {});
      });
    });
  }

  Future getSenderId() async {
    sp = await SharedPreferences.getInstance();
    sendid = sp.getString('userid') ?? "";
  }

  Future getMessage(String sendid, String receiveid) async {
    try {
      Map data = {'sender_id': sendid, 'receiver_id': receiveid};

      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "sender_reciver_image.php"),
          body: data);

      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == true) {
        messages.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          SenderReciverImage sri = SenderReciverImage(
            attachment: jsondata['data'][i]['attachment'],
          );
          messages.add(sri);
          print(jsondata['data'][i]['attachment']);
        }
        // setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Media"),
              backgroundColor: Colors.blue,
            ),
            body: Container(
                padding: EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: messages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey)),
                      child: Image.network(
                        cacheWidth: 120,
                        MyUrl.fullurl +
                            MyUrl.chaturl +
                            messages[index].attachment,
                        width: 150,
                      ),
                    );
                  },
                ))));
  }
}
