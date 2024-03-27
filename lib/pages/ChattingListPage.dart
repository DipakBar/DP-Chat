// ignore: file_names
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Chatthemepage.dart';

import 'package:flutter_application_1/pages/GroupPage1.dart';
import 'package:flutter_application_1/pages/Loadingdialog_page.dart';
import 'package:flutter_application_1/pages/contact_photo.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/lastmsg_model.dart';
// import 'package:flutter_application_1/pages/user_prioriy.dart';
import 'package:flutter_application_1/utils.dart';
// import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/newbroadcast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: use_key_in_widget_constructors
class ChattingListPageEx extends StatefulWidget {
  // ignore: annotate_overrides
  State<ChattingListPageEx> createState() => _ChattingListPageExState();
}

class _ChattingListPageExState extends State<ChattingListPageEx> {
  // ignore: non_constant_identifier_names
  TextEditingController Searchbar = TextEditingController();
  List<Details> priority = [];
  // ignore: non_constant_identifier_names
  String user_id = '';
  late SharedPreferences sp;
  List<Details> userlist = [];
  List<Contact> contacts = [];
  List<String> phlist = [];
  List<String> contactname = [];
  List<Details> searchcontact = [];
  bool isopen = false;
  bool notopen = true;
  List<Lastmessage> lastmsg = [];

  // ignore: non_constant_identifier_names
  void FilterItem(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchcontact.clear();
        searchcontact = priority;
      });
    } else {
      setState(() {
        searchcontact = priority
            .where((val) => val.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  Future getSenderId() async {
    sp = await SharedPreferences.getInstance();
    user_id = sp.getString('userid') ?? "";
  }

  Future getUserdata() async {
    try {
      var response = await http.get(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.http(MyUrl.mainurl, MyUrl.suburl + "getddata.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        userlist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          String phone = jsondata['data'][i]['mobile'];
          int index = phlist.indexOf(phone);
          if (index != -1) {
            Details databasedata = Details(
              jsondata['data'][i]['userid'],
              contactname[index],
              jsondata['data'][i]['mobile'],
              jsondata['data'][i]['bio'],
              jsondata['data'][i]['uploadpic'],
              jsondata['data'][i]['email'],
            );

            setState(() {
              userlist.add(databasedata);
            });
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return userlist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isEmpty ||
            contacts[i].phones[0].normalizedNumber.length < 10) continue;
        phlist.add(contacts[i].phones[0].normalizedNumber.substring(3));
        contactname.add(contacts[i].displayName);
      }
    }
  }

  // ignore: non_constant_identifier_names
  Future MessegeInsert(String user_id) async {
    showDialog(
        context: context,
        builder: (context) {
          return const LoadingDiologPage();
        });

    try {
      var data = {'user_id': user_id};

      var response = await http.post(
          // ignore: prefer_interpolation_to_compose_strings
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "priority.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == true) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        priority.clear();
        lastmsg.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          if (jsondata['data'][i]['sender_id'] == user_id) {
            for (int j = 0; j < userlist.length; j++) {
              if (jsondata['data'][i]['receiver_id'] == userlist[j].userid &&
                  !priority.contains(userlist[j])) {
                priority.add(userlist[j]);
                Lastmessage msgdata = Lastmessage(
                    msg: jsondata['data'][i]['content'],
                    time: jsondata['data'][i]['massage_time']);

                lastmsg.add(msgdata);
                break;
              }
            }
          } else {
            for (int j = 0; j < userlist.length; j++) {
              if (jsondata['data'][i]['sender_id'] == userlist[j].userid &&
                  !priority.contains(userlist[j])) {
                priority.add(userlist[j]);
                Lastmessage msgdata = Lastmessage(
                    msg: jsondata['data'][i]['content'],
                    time: jsondata['data'][i]['massage_time']);
                lastmsg.add(msgdata);
                break;
              }
            }
          }
          setState(() {});
        }
      } else {
        // ignore: avoid_print
        print("not Send");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    getContact().whenComplete(
      () {
        getUserdata().whenComplete(() {
          getSenderId().whenComplete(
            () {
              MessegeInsert(user_id);
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: const Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    elevation: 9,
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: TextField(
                        controller: Searchbar,
                        onChanged: (value) {
                          setState(() {
                            isopen = true;
                            notopen = false;
                          });
                          return FilterItem(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  Searchbar.clear();
                                  notopen = true;
                                  isopen = false;
                                });
                              }),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              40.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewBroadcast()));
                          },
                          child: const Text("New broadcast")),
                      TextButton(
                        child: const Text("New group"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GrouPage1()));
                        },
                      )
                    ],
                  ),
                ],
              ),
              if (isopen == true)
                Expanded(
                  child: searchcontact.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.only(top: 12),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(45),
                                  topRight: Radius.circular(45)),
                              color: Colors.white),
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 5),
                                            color: Colors.blue.withOpacity(.5),
                                            spreadRadius: 2,
                                            blurRadius: 8)
                                      ]),
                                  child: SizedBox(
                                    height: 70,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserChatThemePage(
                                                      searchcontact[index])),
                                        ).then((value) => setState(() {
                                              getContact().whenComplete(
                                                () {
                                                  getUserdata()
                                                      .whenComplete(() {
                                                    getSenderId().whenComplete(
                                                      () {
                                                        MessegeInsert(user_id);
                                                      },
                                                    );
                                                  });
                                                },
                                              );
                                            }));
                                      },
                                      trailing: Text(lastmsg[index].time),
                                      leading: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return ContactsPhoto(
                                                      searchcontact[index]);
                                                }));
                                          },
                                          child: searchcontact[index].photo !=
                                                  ''
                                              ? CircleAvatar(
                                                  radius: 28,
                                                  child: CachedNetworkImage(
                                                    imageUrl: MyUrl.fullurl +
                                                        MyUrl.imageurl +
                                                        searchcontact[index]
                                                            .photo,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    imageBuilder: (context,
                                                        imageProvider) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white,
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider)),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 28,
                                                  child: Text(
                                                    searchcontact[index]
                                                        .name[0],
                                                  ),
                                                )),
                                      title: Text(searchcontact[index].name),
                                      subtitle: Text(lastmsg[index].msg),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: searchcontact.length,
                          ))
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not found",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                ),
              if (notopen == true)
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(top: 12),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45)),
                          color: Colors.white),
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 5),
                                        color: Colors.blue.withOpacity(.5),
                                        spreadRadius: 2,
                                        blurRadius: 8)
                                  ]),
                              child: SizedBox(
                                height: 70,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserChatThemePage(
                                                  priority[index])),
                                    ).then((value) => setState(() {
                                          getContact().whenComplete(
                                            () {
                                              getUserdata().whenComplete(() {
                                                getSenderId().whenComplete(
                                                  () {
                                                    MessegeInsert(user_id);
                                                    // print(senderid);
                                                  },
                                                );
                                              });
                                            },
                                          );
                                        }));
                                    // print("refresh done ");
                                  },
                                  trailing: Text(lastmsg[index].time),
                                  leading: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return ContactsPhoto(
                                                  priority[index]);
                                            }));
                                      },
                                      child: priority[index].photo != ''
                                          ? CircleAvatar(
                                              radius: 28,
                                              child: CachedNetworkImage(
                                                imageUrl: MyUrl.fullurl +
                                                    MyUrl.imageurl +
                                                    priority[index].photo,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 28,
                                              child: Text(
                                                priority[index].name[0],
                                              ),
                                            )),
                                  title: Text(priority[index].name),
                                  subtitle: Text(lastmsg[index].msg),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: priority.length,
                      )),
                )
            ],
          ),
        ),
      ),
    );
  }
}
