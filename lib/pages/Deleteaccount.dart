// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/Loadingdialog_page.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/page1.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AccountDelete extends StatefulWidget {
  Details details;
  AccountDelete(this.details);

  @override
  State<AccountDelete> createState() => _AccountDeleteState(details);
}

class _AccountDeleteState extends State<AccountDelete> {
  Details details;
  _AccountDeleteState(this.details);
  late SharedPreferences sp;
  GlobalKey<FormState> des_mob = GlobalKey();
  TextEditingController mobile = TextEditingController();
  TextEditingController des = TextEditingController();

  Future<void> AccountDelete(String mobile, String des) async {
    Map data = {'mobile': mobile, 'description': des};
    sp = await SharedPreferences.getInstance();

    if (des_mob.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDiologPage();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "delete_account.php"),
            body: data);

        var jsondata = jsonDecode(res.body);

        if (jsondata['status'] == "true") {
          sp.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Myapp()),
              (Route<dynamic> route) => false);

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Delete this account")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: const [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "if you delete this account",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        ". the account will be deleted from DP chat ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        ". your massage histry will be erased",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        ". you will be removed from all your DP chat group ",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: des_mob,
                  child: Column(
                    children: [
                      const Text(
                        "To delete your account, enter your mobile number and write a description why you delete the account.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: mobile,
                        validator: (value) {
                          if (value != details.mobile) {
                            return 'please enter your mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "Enter your mobile number",
                          labelText: "Mobile",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          suffix: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: des,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please massage our';
                          } else if (value.length < 2) {
                            return 'To short';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Enter your description",
                          labelText: "Description",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          suffix: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Account delete ssuccesfully',
                          confirmBtnText: 'Yes',
                          onConfirmBtnTap: () async {
                            if (des_mob.currentState!.validate()) {
                              AccountDelete(mobile.text, des.text);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        /// primary: Colors.white, //background color
                        onPrimary: Colors.red, //text color
                      ),
                      child: Text(
                        "Delete account",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
