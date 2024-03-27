import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class helpDialog extends StatefulWidget {
  const helpDialog({super.key});

  @override
  State<helpDialog> createState() => _helpDialogState();
}

class _helpDialogState extends State<helpDialog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: SingleChildScrollView(
          child: Container(
              height: 100,
              width: 170,
              child: AlertDialog(
                elevation: 0,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(""))
                ],
                title: Center(
                  child: Text(
                    "help",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
