import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatFile extends StatelessWidget {
  const ChatFile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        // color: Colors.transparent,
        child: Dialog(
          child: Center(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              height: 10,
              // width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
