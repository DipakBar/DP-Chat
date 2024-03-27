import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
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
                "Calls",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
