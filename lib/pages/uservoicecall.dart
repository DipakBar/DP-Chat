import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/pages/details.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// ignore: must_be_immutable
class UserVoiceCall extends StatefulWidget {
  Details call;
  UserVoiceCall(this.call);

  @override
  State<UserVoiceCall> createState() => _UserVoiceCallState(call);
}

class _UserVoiceCallState extends State<UserVoiceCall> {
  Details call;
  _UserVoiceCallState(this.call);
//  final String callid = Random().nextInt(1000).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: SafeArea(
        //   child: ZegoUIKitPrebuiltCall(
        //     appID: 1697378086,
        //     appSign:
        //         "69d46bba7ba2dca1e412a5234e9d6e76725745d198368eee3a118ef8b409ef50",
        //     callID: '123',
        //     config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        //       ..onOnlySelfInRoom = (context) => Navigator.pop(context),
        //     userID: call.mobile,
        //     userName: call.name,
        //   ),
        // ),
        );
  }
}
