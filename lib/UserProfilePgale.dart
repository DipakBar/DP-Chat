import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controlers/datacontroler.dart';
import 'package:flutter_application_1/pages/Loadingdialog_page.dart';
import 'package:flutter_application_1/pages/flashscreen.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/mainchat.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late SharedPreferences sp;

  DataController controller = Get.put(DataController());

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> productData = {
    "name": "",
    "mobile": FlashState.mobile.toString(),
    "email": "",
    "bio": ""
  };

  addProduct() {
    if (pickedImage == null) {
      Get.snackbar(
        "Opps",
        "Image Required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).errorColor,
        colorText: Colors.white,
      );
      return;
    }

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      print("Form is vaid ");

      print('Data for new product $productData');
      showDialog(
        context: context,
        builder: (context) => LoadingDiologPage(),
      );
      controller.addNewProduct(productData, pickedImage).whenComplete(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainChat()));
      });
    }
  }

  var pickedImage;

  imagePickerOption() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          height: 180,
          child: Column(
            children: [
              Text(
                "Pic Image From",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              TextButton.icon(
                onPressed: () {
                  pickImage(ImageSource.camera);
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
                  pickImage(ImageSource.gallery);
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

  pickImage(ImageSource imageType) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final photo = await _picker.pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        this.pickedImage = tempImage;
        print(pickedImage);
        // widget.getImageValue(pickedImage!);
      });

      Get.back();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        child: Scaffold(
          body: Container(
            height: height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              // ignore: sort_child_properties_last
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  icon: (Icon(Icons.arrow_back_ios,
                                      size: 24, color: Colors.black45))),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black87)),
                            ),
                            const Text(
                              'CREATE PROFILE',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 24,
                              width: 24,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                  child: pickedImage != null
                                      ? Image.file(
                                          pickedImage!,
                                          width: 170,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "assets/images/default.png",
                                          height: 150,
                                          width: 150,
                                        )),
                            ),
                            Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  // ignore: sort_child_properties_last
                                  child: IconButton(
                                    // onPressed: imagePickerOption,
                                    // onPressed: selectImage,
                                    onPressed: imagePickerOption,
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: height * 0.6,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.black45,
                              Color.fromRGBO(0, 41, 102, 1)
                            ])),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 25, 29, 4),
                            child: Container(
                              height: 90,
                              // ignore: sort_child_properties_last
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                      onSaved: (value) {
                                        productData['name'] = value!;
                                      },
                                      // controller: name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'please enter name';
                                        } else if (value.length < 2) {
                                          return 'To short';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        labelText: "Username",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(
                                          Icons.people,
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            )),
                                        enabledBorder: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 1,
                                            )),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 29, 4),
                            child: Container(
                              height: 90,
                              // ignore: sort_child_properties_last
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                      // controller: email
                                      onSaved: (value) {
                                        productData['email'] = value!;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'please enter email no.';
                                        } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                          return "enter valid gmail_id.";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        // hintText: ,
                                        labelText: "Email",
                                        prefixIcon: Icon(Icons.email,
                                            color: Colors.white),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            )),
                                        enabledBorder: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 1,
                                            )),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 29, 4),
                            child: Container(
                              height: 90,
                              // ignore: sort_child_properties_last
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                      // controller: bio,
                                      onSaved: (value) {
                                        productData['bio'] = value!;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'please enter email';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        labelText: "Bio",
                                        prefixIcon: Icon(
                                          Icons.abc,
                                          color: Colors.white,
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            )),
                                        enabledBorder: OutlineInputBorder(
                                            //Outline border type for TextFeild
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 1,
                                            )),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: addProduct,
                                child: Container(
                                  height: 70,
                                  width: 200,
                                  // ignore: sort_child_properties_last
                                  child: const Align(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30))),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
