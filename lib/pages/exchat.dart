import 'package:flutter/material.dart';
import 'package:flutter_application_1/controler/chat_controler.dart';
import 'package:flutter_application_1/model/CMassage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Exchat extends StatefulWidget {
  const Exchat({super.key});

  @override
  State<Exchat> createState() => _ExchatState();
}

class _ExchatState extends State<Exchat> {
  TextEditingController msginputcontroler = TextEditingController();
  late IO.Socket socket;
  ChatControler chatControler = ChatControler();
  String time = DateFormat("HH:mm").format(DateTime.now());
  @override
  void initState() {
    super.initState();
    connect();
    SetupSocketLisner();
  }

  void connect() {
    socket = IO.io(
        "http://192.168.25.130:5000",
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
        //  <String, dynamic>{
        //   "transports": ["websocket"],
        //   "autoConnect": false,
        // }
        );
    socket.connect();
    socket.onConnect((data) => print("connected"));
    print(socket.connected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dipak Chat',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(
                flex: 9,
                child: Obx(
                  () => ListView.builder(
                      itemCount: chatControler.chatmessages.length,
                      itemBuilder: ((context, index) {
                        var currentItem = chatControler.chatmessages[index];
                        return MessageItem(
                          SentByMe: currentItem.SentByMe == socket.id,
                          message: currentItem.message,
                        );
                      })),
                )),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(7),
              // ignore: sort_child_properties_last
              child: TextField(
                cursorColor: Colors.blueAccent,
                controller: msginputcontroler,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    suffixIcon: Container(
                      child: IconButton(
                          onPressed: () {
                            sendmessage(msginputcontroler.text);
                            msginputcontroler.text = "";
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    )),
              ),
              color: Colors.red,
            ))
          ],
        ),
      ),
    );
  }

  void sendmessage(String text) {
    var messagejoshon = {"message": text, "SentByMe": socket.id.toString()};
    print(messagejoshon);
    socket.emit('message', messagejoshon);
    chatControler.chatmessages.add(CMassage.fromJosn(messagejoshon));
  }

  void SetupSocketLisner() {
    socket.on('message-recived', (data) {
      print(data);
      chatControler.chatmessages.add(CMassage.fromJosn(data));
    });
  }
}

class MessageItem extends StatelessWidget {
  // ignore: non_constant_identifier_names
  const MessageItem({super.key, required this.SentByMe, required this.message});
  final bool SentByMe;
  final String message;
  // Color perpale=Colors.purple;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat("HH:mm").format(DateTime.now());
    return Align(
      alignment: SentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: SentByMe ? Colors.blue : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              message,
              style: TextStyle(
                  color: SentByMe ? Colors.black : Colors.green, fontSize: 22),
            ),
            Text(
              time,
              style: TextStyle(
                  color: SentByMe ? Colors.black : Colors.greenAccent,
                  fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
