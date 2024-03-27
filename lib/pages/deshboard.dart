import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Deleteaccount.dart';
import 'package:flutter_application_1/pages/Loadingdialog_page.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_application_1/pages/profilephoto.dart';
import 'package:flutter_application_1/utils.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Deshboard extends StatefulWidget {
  Details details;
  Deshboard(this.details);

  @override
  State<Deshboard> createState() => _DeshboardState(details);
}

class _DeshboardState extends State<Deshboard> {
  Details details;
  _DeshboardState(this.details);
  GlobalKey<FormState> namekey = GlobalKey();
  GlobalKey<FormState> biokey = GlobalKey();
  GlobalKey<FormState> emailkey = GlobalKey();

  TextEditingController name = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  TextEditingController photocontroller = TextEditingController();
  File? pickedImage;

  imagePickerOption() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          height: 180,
          child: Column(
            children: [
              const Text(
                "Pic Image From",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera).whenComplete(() {
                    UpdateImage(pickedImage!, details.userid);
                  });
                },
                icon: const Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: const Text(
                  "CAMERA",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery).whenComplete(() {
                    UpdateImage(pickedImage!, details.userid);
                  });
                },
                icon: const Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: const Text(
                  "GALLERY",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                label: const Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future UpdateImage(File uploadpic, String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDiologPage();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "photo_update.php"));

      request.files.add(await http.MultipartFile.fromBytes(
          'image', uploadpic.readAsBytesSync(),
          filename: uploadpic.path.split("/").last));
      request.fields['uid'] = id;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        var sp = await SharedPreferences.getInstance();

        details.photo = jsondata['imgtitle'];
        sp.setString("photo", details.photo);

        setState(() {});
        Navigator.pop(context);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Update succesful ',
          confirmBtnText: 'Yes',
          // cancelBtnText: 'No',
          onConfirmBtnTap: () async {
            Navigator.of(context).pop();
          },
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future<void> updatename(String name) async {
    Map data = {'mobile': details.mobile, 'username': name};
    var sharedPref = await SharedPreferences.getInstance();
    if (namekey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDiologPage();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);

          setState(() {
            sharedPref.setString("username", jsondata["username"]);
            details.name = jsondata["username"];
          });

          // ignore: use_build_context_synchronously
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Update succesful ',
            confirmBtnText: 'Yes',
            // cancelBtnText: 'No',
            onConfirmBtnTap: () async {
              Navigator.of(context).pop();
            },
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

  Future<void> updatebio(String bio) async {
    Map data = {'mobile': details.mobile, 'bio': bio};
    var sharedPref = await SharedPreferences.getInstance();
    if (biokey.currentState!.validate()) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDiologPage();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "bio_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);

          setState(() {
            sharedPref.setString("bio", jsondata["bio"]);
            details.bio = jsondata["bio"];
          });
          // ignore: use_build_context_synchronously
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Update succesful ',
            confirmBtnText: 'Yes',
            // cancelBtnText: 'No',
            onConfirmBtnTap: () async {
              Navigator.of(context).pop();
            },
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

  Future<void> updateemail(String email) async {
    Map data = {'mobile': details.mobile, 'email': email};
    var sharedPref = await SharedPreferences.getInstance();
    if (emailkey.currentState!.validate()) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDiologPage();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "email_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);

          setState(() {
            sharedPref.setString("email", jsondata["email"]);
            details.email = jsondata["email"];
          });

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Update succesful ',
            confirmBtnText: 'Yes',
            // cancelBtnText: 'No',
            onConfirmBtnTap: () async {
              Navigator.of(context).pop();
            },
            // confirmBtnColor: Colors.blueAccent,
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'sorry something want wrong',
            confirmBtnText: 'Yes',
            // cancelBtnText: 'No',
            onConfirmBtnTap: () async {
              Navigator.of(context).pop();
            },
            // confirmBtnColor: Colors.blueAccent,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 60,
                  child: const Center(
                      child: Text(
                    'PROFILE  INFO',
                    style: TextStyle(fontSize: 30),
                  )),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 25),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                  color: Colors.black,
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                  child: ListView(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((context) {
                                    return Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePhoto(
                                                                details)));
                                              },
                                              child: const Text(
                                                "Wiew profile image",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextButton(
                                              onPressed: imagePickerOption,
                                              child: const Text(
                                                "Edit profile image",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ))
                                        ],
                                      ),
                                    );
                                  }));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: pickedImage != null
                                    ? ClipOval(
                                        child: Image.file(
                                          pickedImage!,
                                          width: 170,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : details.photo != "null"
                                        ? ClipOval(
                                            child: Image.network(
                                            MyUrl.fullurl +
                                                MyUrl.imageurl +
                                                details.photo,
                                            width: 170,
                                            height: 170,
                                            fit: BoxFit.cover,
                                          ))
                                        : CircleAvatar(
                                            radius: 80,
                                            backgroundColor: Colors.black,
                                            child: Text(
                                              details.name[0],
                                              style: TextStyle(
                                                  fontSize: 60,
                                                  color: Colors.white),
                                            ),
                                          )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
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
                      child: ListTile(
                        title: Text("Mobile no."),
                        subtitle: Text(details.mobile),
                        leading: Icon(Icons.call),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text:
                                  'If you want to edit your mobile number then you have to detele your account Are you sure? Do you want to delete your account',
                              confirmBtnText: 'Yes',
                              // cancelBtnText: 'No',
                              onConfirmBtnTap: () async {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountDelete(details)),
                                );
                              },
                              // confirmBtnColor: Colors.blueAccent,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
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
                      child: ListTile(
                        title: Text("name"),
                        subtitle: Text(details.name),
                        leading: Icon(Icons.person),
                        trailing: IconButton(
                          onPressed: () {
                            name.text = details.name;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: AlertDialog(
                                      title: Text("Enter your name"),
                                      content: Form(
                                        key: namekey,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: name,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'please enter name';
                                            }
                                            //else if (value.length < 2) {
                                            //   return 'To short';
                                            // }
                                            return null;
                                          },
                                          decoration: InputDecoration(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "CANCLE",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              if (namekey.currentState!
                                                  .validate()) {
                                                updatename(name.text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Your Name");
                                              }
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ))
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
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
                      child: ListTile(
                        title: Text("Email id."),
                        subtitle: Text(details.email),
                        leading: Icon(Icons.email),
                        trailing: IconButton(
                          onPressed: () {
                            emailcontroller.text = details.email;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: AlertDialog(
                                      title: Text("Enter your Email id."),
                                      content: Form(
                                        key: emailkey,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: emailcontroller,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'please enter email';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "CANCLE",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              if (emailkey.currentState!
                                                  .validate()) {
                                                updateemail(
                                                    emailcontroller.text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Your Email");
                                              }
                                            },
                                            child: const Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ))
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                        ),
                      ),
                    ),
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
                      child: ListTile(
                        title: Text("Bio"),
                        subtitle: Text(details.bio),
                        leading: Icon(Icons.text_fields),
                        trailing: IconButton(
                          onPressed: () {
                            biocontroller.text = details.bio;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: AlertDialog(
                                      title: Text("Enter your bio"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "CANCLE",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              if (biokey.currentState!
                                                  .validate()) {
                                                updatebio(biocontroller.text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Your Name");
                                              }
                                            },
                                            child: const Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ))
                                      ],
                                      content: Form(
                                        key: biokey,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: biocontroller,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'please enter bio';
                                            }

                                            return null;
                                          },
                                          decoration: InputDecoration(),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Center(
                        child: Text(
                      'DIPAK',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ))
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
