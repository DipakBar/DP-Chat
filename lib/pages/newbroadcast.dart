import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/flashscreen.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBroadcast extends StatefulWidget {
  @override
  State<NewBroadcast> createState() => _NewBroadcastState();
}

class _NewBroadcastState extends State<NewBroadcast> {
  Icon se = Icon(Icons.search);
  late SharedPreferences sp;
  String mobile = '';

  Widget cusSearchbar = Text(FlashState.mobile.toString());

  bool show = true;
  bool notshow = true;

  List<AllUsers> Userlist = [];
  List<Contact> contacts = [];
  List<String> contactname = [];
  List<String> phlist = [];
  List<String> usermobile = [];
  List<SpecificUser> specificuser = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getContact().whenComplete(() {
      getUserdata();
    });
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

  Future getUserdata() async {
    try {
      for (int i = 0; i < phlist.length; i++) {
        for (int j = 0; j < Userlist.length; j++) {
          if (phlist[i] == Userlist[j].mobile) {
            print(Userlist[j].name);
            SpecificUser data = SpecificUser(
                userid: Userlist[j].userId,
                photo: Userlist[j].productImage,
                mobile: Userlist[j].mobile,
                name: Userlist[j].name,
                bio: Userlist[j].bio,
                email: Userlist[j].email);
            setState(() {
              specificuser.add(data);
            });
          }
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: cusSearchbar,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (this.se.icon == Icons.search) {
                      this.se = Icon(Icons.cancel);
                      OnTap() {}

                      this.cusSearchbar = TextField(
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            show = false;
                            notshow = false;
                          });
                          // return FilterItem(value);
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "search",
                            hintStyle: TextStyle(color: Colors.white)),
                        textInputAction: TextInputAction.go,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      );
                    } else {
                      this.se = Icon(Icons.search);
                      this.cusSearchbar = Text(FlashState.mobile.toString());
                    }
                  });
                },
                icon: se),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              color: Colors.black,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Center(
                      child: TextButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(onPrimary: Colors.white),
                    child: const Text(
                      "Refreash",
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  )),
                ),
                PopupMenuItem(
                  child: Center(
                      child: TextButton(
                    // ignore: sort_child_properties_last
                    child: const Text(
                      "Help",
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        //  primary: Colors.white, //background color
                        onPrimary: Colors.white //text color
                        ),
                  )),
                ),
              ],
            )
          ],
        ),
        body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userprofile')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return CircularProgressIndicator();

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final val = snapshot.data?.docs;
                    Userlist =
                        val?.map((e) => AllUsers.fromJson(e.data())).toList() ??
                            [];
                }
                if (specificuser.isNotEmpty) {
                  return ListView.builder(
                      itemCount: specificuser.length,
                      itemBuilder: ((context, index) {
                        usermobile.add(Userlist[index].mobile);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                leading: InkWell(
                                  onTap: () {},
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width *
                                          .1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .1,
                                      imageUrl: specificuser[index].photo,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                title:
                                    Text(specificuser[index].name.toString()),
                                minLeadingWidth: 10,
                                subtitle:
                                    Text(specificuser[index].mobile.toString()),
                                // leading: Icon(Icons.key),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_forward_ios),
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        );
                      }));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitSpinningLines(
                        size: 50,
                        color: Colors.redAccent,
                      ),
                      Text("Please wait...")
                    ],
                  );
                }
              }),
        ));
  }
}
