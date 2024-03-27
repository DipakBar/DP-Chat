import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/ex.dart';
import 'package:flutter_application_1/pages/Chatthemepage.dart';

import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ContactsPhoto extends StatefulWidget {
  Details user;
  ContactsPhoto(this.user);

  @override
  State<ContactsPhoto> createState() => _ContactsPhotoState(user);
}

class _ContactsPhotoState extends State<ContactsPhoto> {
  Details user;
  _ContactsPhotoState(this.user);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(.9),
      // backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        height: MediaQuery.of(context).size.height * .36,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            title: Text(
                              user.name,
                              style: TextStyle(letterSpacing: 0.4),
                            ),
                            elevation: 0.5,
                            backgroundColor: Colors.transparent,
                          ),
                          body: Material(
                            color: Colors.transparent,
                            child: Container(
                              child: user.photo != ""
                                  ? PhotoView(
                                      maxScale: 4.0,
                                      minScale: 0.1,
                                      imageProvider: NetworkImage(
                                          MyUrl.fullurl +
                                              MyUrl.imageurl +
                                              user.photo))
                                  : const Center(
                                      child: Text(
                                        "No image",
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            color: Colors.white54,
                                            fontSize: 20),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ));
                },
                child: user.photo != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .50),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundImage: NetworkImage(
                              MyUrl.fullurl + MyUrl.imageurl + user.photo),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(100)),
                        child: const CircleAvatar(
                          // backgroundColor: Colors.black,
                          radius: 100, backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.person,
                            size: 150,
                            color: Colors.blue,
                          ),
                          // child: Text(
                          //   user.name[0],
                          //   style: TextStyle(color: Colors.white, fontSize: 50),
                          // ),
                        ),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home(user)));
                  },
                  child: Text(
                    "View ${user.name}'s Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => UserChatThemePage(user)));
                    },
                    icon: Icon(Icons.message_outlined))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
