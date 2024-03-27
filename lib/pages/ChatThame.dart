import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Chattheme extends StatefulWidget {
  const Chattheme({super.key});

  @override
  State<Chattheme> createState() => _ChatthemeState();
}

class _ChatthemeState extends State<Chattheme> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 25,
      ),
      title: Text("Prasanta Karan"),
      subtitle: Row(
        children: const [
          Icon(
            Icons.done_all,
            color: Colors.blue,
          ),
          Text("Hii")
        ],
      ),
      trailing: Text("13:58"),
    );
  }
}
