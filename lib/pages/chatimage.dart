import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PraticExam extends StatefulWidget {
  const PraticExam({super.key});

  @override
  State<PraticExam> createState() => _PraticExamState();
}

class _PraticExamState extends State<PraticExam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: 200,
            color: Colors.red,
            // child: Text('sss'),
          ),
          Text(
              'ssuwuiewfuiewfhiohieiefehihvdsihehfihiefohephihihcklscscksslsshsahfflklsfsasfails')
        ],
      )),
    );
  }
}
