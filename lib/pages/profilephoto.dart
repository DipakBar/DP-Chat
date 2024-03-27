import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/utils.dart';

// ignore: must_be_immutable
class ProfilePhoto extends StatefulWidget {
  Details details;
  ProfilePhoto(this.details);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState(details);
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  Details details;
  _ProfilePhotoState(this.details);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: details.photo != "null"
            ? Image.network(MyUrl.fullurl + MyUrl.imageurl + details.photo)
            : Center(
                child: Text(
                'No Photo',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )));
  }
}
