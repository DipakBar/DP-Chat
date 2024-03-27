import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class FetchData extends StatefulWidget {
  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
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
          // print(Userlist[i].mobile);
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
        appBar: AppBar(title: Text('All Data')),
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
                if (Userlist.isNotEmpty) {
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
                                title:
                                    Text(specificuser[index].name.toString()),
                                minLeadingWidth: 10,
                                subtitle:
                                    Text(specificuser[index].mobile.toString()),
                                // leading: Icon(Icons.key),
                                trailing: IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             SettingAccount(details)));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios),
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        );
                        // Container(
                        //   child: Text(snapshot.data?.docs[index]['name']),
                        // );
                      }));
                } else {
                  return Container(
                    child: Text('Not Found'),
                  );
                }
              }),
        ));
  }
}
