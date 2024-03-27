// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/pages/details.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// ignore: must_be_immutable
class VideoCall extends StatefulWidget {
  Details user;
  VideoCall(this.user);
  @override
  State<VideoCall> createState() => _VideoCallState(user);
}

class _VideoCallState extends State<VideoCall> {
  Details user;
  _VideoCallState(this.user);
  // final String callid = Random().nextInt(1000).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: SafeArea(
        //   child: ZegoUIKitPrebuiltCall(
        //     appID: 723331723,
        //     appSign:
        //         "a5b27998c33146135209b9d157fb5394e28007425f1ebec5297028f5a1260a46",
        //     callID: '321',
        //     config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        //       ..onOnlySelfInRoom = (context) => Navigator.pop(context),
        //     userID: user.mobile,
        //     userName: user.name,
        //   ),
        // ),
        );
  }
}
