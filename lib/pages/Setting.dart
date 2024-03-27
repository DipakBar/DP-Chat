import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/account.dart';
import 'package:flutter_application_1/pages/deshboard.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/page1.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SettingPage extends StatefulWidget {
  Details details;
  SettingPage(this.details);
  @override
  State<SettingPage> createState() => _SettingPageState(details);
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController Searchbar = TextEditingController();
  late SharedPreferences sp;
  Details details;
  _SettingPageState(this.details);
  void dispose() {
    super.dispose();
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
                    Container(
                      child: const Text(
                        "Setting",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container()
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(40)),
                    //   elevation: 9,
                    //   child: Container(
                    //     child: TextField(
                    //       controller: Searchbar,
                    //       decoration: InputDecoration(
                    //         hintText: "Search",
                    //         suffixIcon: IconButton(
                    //           icon: Icon(Icons.clear),
                    //           onPressed: () => Searchbar.clear(),
                    //         ),
                    //         prefixIcon: IconButton(
                    //           icon: Icon(Icons.search),
                    //           onPressed: () {},
                    //         ),
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(
                    //             40.0,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 25),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45)),
                        color: Colors.white),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 5),
                                      color: Colors.blue.withOpacity(.6),
                                      spreadRadius: 5,
                                      blurRadius: 8)
                                ]),
                            child: TextButton(
                              child: ListTile(
                                // leading: details.photo != "null"
                                //     ? CircleAvatar(
                                //         backgroundImage: NetworkImage(
                                //             MyUrl.fullurl +
                                //                 MyUrl.imageurl +
                                //                 details.photo),
                                //       )
                                //     : CircleAvatar(
                                //         backgroundColor: Colors.black,
                                //         child: Text(
                                //           details.name[0],
                                //           style: TextStyle(fontSize: 30),
                                //         ),
                                //       ),
                                title: Text(
                                  'hello',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('bio'),
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 Deshboard(details)))
                                //     .then((value) {});
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: const Divider(
                                thickness: 1.5, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
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
                                title: Text("Account"),
                                minLeadingWidth: 10,
                                subtitle: const Text(
                                    "Security notifications,change number"),
                                leading: Icon(Icons.key),
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
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               offset: Offset(0, 5),
                        //               color: Colors.blue.withOpacity(.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 8)
                        //         ]),
                        //     child: SizedBox(
                        //       height: 70,
                        //       child: ListTile(
                        //         title: Text("Privacy"),
                        //         minLeadingWidth: 10,
                        //         subtitle: Text(
                        //             "Block contacts,disappearing massanges"),
                        //         leading: Icon(Icons.lock),
                        //         trailing: IconButton(
                        //           onPressed: () {},
                        //           icon: Icon(Icons.arrow_forward_ios),
                        //           // icon: Icon(Icons.),
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               offset: Offset(0, 5),
                        //               color: Colors.blue.withOpacity(.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 8)
                        //         ]),
                        //     child: SizedBox(
                        //       height: 70,
                        //       child: ListTile(
                        //         title: Text("Chats"),
                        //         minLeadingWidth: 10,
                        //         subtitle: Text("Create,edit,profile photo"),
                        //         leading: Icon(Icons.chat),
                        //         trailing: IconButton(
                        //           onPressed: () {},
                        //           icon: Icon(Icons.arrow_forward_ios),
                        //           // icon: Icon(Icons.),
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               offset: Offset(0, 5),
                        //               color: Colors.blue.withOpacity(.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 8)
                        //         ]),
                        //     child: SizedBox(
                        //       height: 70,
                        //       child: ListTile(
                        //         title: Text("Notifications"),
                        //         minLeadingWidth: 10,
                        //         subtitle: Text("Massage,group & call tones"),
                        //         leading: Icon(Icons.notifications),
                        //         trailing: IconButton(
                        //           onPressed: () {},
                        //           icon: Icon(Icons.arrow_forward_ios),
                        //           // icon: Icon(Icons.),
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               offset: Offset(0, 5),
                        //               color: Colors.blue.withOpacity(.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 8)
                        //         ]),
                        //     child: SizedBox(
                        //       height: 70,
                        //       child: ListTile(
                        //         title: Text("Storage and data"),
                        //         minLeadingWidth: 10,
                        //         subtitle: Text("Network usage,auto download"),
                        //         leading: Icon(Icons.storage),
                        //         trailing: IconButton(
                        //           onPressed: () {},
                        //           icon: Icon(Icons.arrow_forward_ios),
                        //           // icon: Icon(Icons.),
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               offset: Offset(0, 5),
                        //               color: Colors.blue.withOpacity(.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 8)
                        //         ]),
                        //     child: SizedBox(
                        //       height: 70,
                        //       child: ListTile(
                        //         title: Text("Help"),
                        //         minLeadingWidth: 10,
                        //         subtitle: Text(
                        //             "Help centre,contact us, privacy policy"),
                        //         leading: Icon(Icons.help),
                        //         trailing: IconButton(
                        //           onPressed: () {},
                        //           icon: Icon(Icons.arrow_forward_ios),
                        //           // icon: Icon(Icons.),
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // // Container(
                        // //   decoration: BoxDecoration(
                        // //       color: Colors.white,
                        // //       borderRadius: BorderRadius.circular(10),
                        // //       boxShadow: [
                        // //         BoxShadow(
                        // //             offset: Offset(0, 5),
                        // //             color: Colors.blue.withOpacity(.5),
                        // //             spreadRadius: 2,
                        // //             blurRadius: 8)
                        // //       ]),
                        // //   child: SizedBox(
                        // //     height: 70,
                        // //     child: ListTile(
                        // //       title: Text("Invite Friend"),
                        // //       minLeadingWidth: 10,
                        // //       // subtitle: Text(""),
                        // //       leading: Icon(Icons.people),
                        //       trailing: IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(Icons.arrow_forward_ios),
                        //         // icon: Icon(Icons.),
                        //         color: Colors.blue,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                              child: ElevatedButton(
                                  onPressed: () {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      text: 'Do you want to logout',
                                      confirmBtnText: 'Yes',
                                      cancelBtnText: 'No',
                                      onConfirmBtnTap: () async {
                                        sp = await SharedPreferences
                                            .getInstance();
                                        sp.clear();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Myapp()),
                                            (Route<dynamic> route) => false);
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )); //
  }
}
