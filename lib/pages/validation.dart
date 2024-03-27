import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class FormEx extends StatefulWidget {
  const FormEx({super.key});

  @override
  State<FormEx> createState() => _FormExState();
}

class _FormExState extends State<FormEx> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Problem dectected',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 18, 33, 35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("We didn't detect a valid mobile number."),
              SizedBox(
                height: 30,
              ),
              const Text(
                  'Please go back to the previous screen and enter your valid mobile number in full international format:'),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "1.To prevent users from making typos at the time of input"),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("2.Enter your valid mobile number.")
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "For creating an account in DP chat, you need to varifying your accout through your valid mobile number.")
            ],
          ),
        ),
      ),
    );
  }
}
