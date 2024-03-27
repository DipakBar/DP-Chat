import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Chatthemepage.dart';
import 'package:flutter_application_1/pages/details.dart';
// import 'package:flutter_application_1/pages/gidview.dart';
// import 'package:flutter_application_1/pages/reciveer_deshoard_photo.dart';
import 'package:flutter_application_1/pages/senderreciverimage.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Details user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState(user);
}

class _HomeState extends State<Home> {
  Details user;
  _HomeState(this.user);
  PanelController _panelController = PanelController();
  bool _isopen = false;
  late SharedPreferences sp;
  String sendid = '';
  List<SenderReciverImage> messages = [];
  double hpadding = 40;

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
          // ignore: prefer_interpolation_to_compose_strings
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: user.photo != ''
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              MyUrl.fullurl + MyUrl.imageurl + user.photo,
                            ),
                            fit: BoxFit.cover)),
                  )
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/sendimage.jpg'),
                            fit: BoxFit.cover)),
                  ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32), topLeft: Radius.circular(32)),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controler) => _panelbody(controler),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isopen) {
                  setState(() {
                    _isopen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isopen = false;
              });
            },
          )
        ],
      ),
    );
  }

  SingleChildScrollView _panelbody(ScrollController controler) {
    double hpadding = 40;
    return SingleChildScrollView(
      controller: controler,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: hpadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                          fontFamily: 'NimbusSanL',
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      user.bio,
                      style: TextStyle(
                          fontFamily: 'NimbusSanL',
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Column(
                //       children: [
                //         Text(
                //           "projects",
                //           style: TextStyle(
                //               fontFamily: 'OpenSans',
                //               fontWeight: FontWeight.w700,
                //               color: Colors.grey,
                //               fontSize: 14),
                //         ),
                //         SizedBox(
                //           height: 8,
                //         ),
                //         Text(
                //           '1135',
                //           style: TextStyle(
                //               fontFamily: 'OpenSans',
                //               fontWeight: FontWeight.w700,
                //               fontSize: 14),
                //         )
                //       ],
                //     ),
                //     Container(
                //       height: 40,
                //       width: 1,
                //       color: Colors.grey,
                //     ),
                //     const Column(
                //       children: [
                //         Text(
                //           "Hourly Rate",
                //           style: TextStyle(
                //               fontFamily: 'openSans',
                //               fontWeight: FontWeight.w700,
                //               color: Colors.grey,
                //               fontSize: 14),
                //         ),
                //         SizedBox(
                //           height: 8,
                //         ),
                //         Text(
                //           '65',
                //           style: TextStyle(
                //               fontFamily: 'OpenSans',
                //               fontWeight: FontWeight.w700,
                //               fontSize: 14),
                //         )
                //       ],
                //     ),
                //     Container(
                //       height: 40,
                //       width: 1,
                //       color: Colors.grey,
                //     ),
                //     const Column(
                //       children: [
                //         Text(
                //           "Location",
                //           style: TextStyle(
                //               fontFamily: 'OpenSans',
                //               fontWeight: FontWeight.w700,
                //               color: Colors.grey,
                //               fontSize: 14),
                //         ),
                //         SizedBox(
                //           height: 8,
                //         ),
                //         Text(
                //           'west bengal',
                //           style: TextStyle(
                //               fontFamily: 'OpenSans',
                //               fontWeight: FontWeight.w700,
                //               fontSize: 14),
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !_isopen,
                      child: Expanded(
                        child: ElevatedButton(
                          child: Text('VIEW PROFILE'),
                          onPressed: () {
                            _panelController.open();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isopen,
                      child: SizedBox(
                        width: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        // color: Colors.blue,
                        child: SizedBox(
                          width: _isopen
                              ? (MediaQuery.of(context).size.width -
                                      (2 * hpadding)) /
                                  1.6
                              : double.infinity,
                          child: ElevatedButton(
                            child: Text('MESSAGE'),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserChatThemePage(user)));
                              navigator?.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                //
              ],
            ),
          ),
          GridView.builder(
            padding: EdgeInsets.all(5),
            primary: false,
            shrinkWrap: true,
            itemCount: messages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 16),
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => Container(
                              child: PhotoView(
                            // maxScale: 2.0,
                            // minScale: 0.5,
                            imageProvider: NetworkImage(
                              MyUrl.fullurl +
                                  MyUrl.chaturl +
                                  messages[index].attachment,
                            ),
                          )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            MyUrl.fullurl +
                                MyUrl.chaturl +
                                messages[index].attachment,
                          ),
                          fit: BoxFit.cover)),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
