import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class StatusPageEx extends StatefulWidget {
  const StatusPageEx({super.key});

  @override
  State<StatusPageEx> createState() => _StatusPageExState();
}

class _StatusPageExState extends State<StatusPageEx> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: const Text(
                "Status",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
