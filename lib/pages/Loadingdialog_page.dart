import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDiologPage extends StatelessWidget {
  const LoadingDiologPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 150,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitSpinningLines(
                  color: Colors.cyan,
                  size: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading....",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
