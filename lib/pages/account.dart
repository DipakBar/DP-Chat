import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/Deleteaccount.dart';
import 'package:flutter_application_1/pages/details.dart';

// ignore: must_be_immutable
class SettingAccount extends StatefulWidget {
  Details details;
  SettingAccount(this.details);

  @override
  State<SettingAccount> createState() => _SettingAccountState(details);
}

class _SettingAccountState extends State<SettingAccount> {
  Details details;
  _SettingAccountState(this.details);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Account",
            style: TextStyle(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
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
                    title: Text("Change number"),
                    minLeadingWidth: 10,
                    //  subtitle: Text("Security notifications,change number"),
                    leading: Icon(Icons.change_circle),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                    title: Text("Delete account"),
                    minLeadingWidth: 10,
                    leading: Icon(Icons.delete),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountDelete(details)));
                      },
                      icon: const Icon(Icons.arrow_forward),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
