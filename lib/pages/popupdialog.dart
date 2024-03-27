import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

// ignore: must_be_immutable
class PinDialog extends StatefulWidget {
  int otp;
  PinDialog(this.otp);
  @override
  State<PinDialog> createState() => _PinDialogState(otp);
}

class _PinDialogState extends State<PinDialog> {
  int otp;
  _PinDialogState(this.otp);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [
              Colors.white,
              Colors.white54,
            ])),
        child: AlertDialog(
          content: Text("your otp is:$otp"),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
          title: Text(
            "OTP",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ));
  }
}
