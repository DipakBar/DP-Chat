import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocket extends StatefulWidget {
  const WebSocket({super.key});

  @override
  State<WebSocket> createState() => _WebSocketState();
}

class _WebSocketState extends State<WebSocket> {
  final TextEditingController my_controler = TextEditingController();

  final my_channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  void sendmessage() {
    if (my_controler.text.isNotEmpty) {
      my_channel.sink.add(my_controler.text);
    }
  }

  @override
  void dispose() {
    my_channel.sink.close();
    my_controler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Socket'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Form(
            child: TextFormField(
          controller: my_controler,
          decoration: InputDecoration(label: Text('Send massage')),
        )),
        SizedBox(
          height: 20,
        ),
        StreamBuilder(
          stream: my_channel.stream,
          builder: (context, Snapshot) {
            return Text(Snapshot.hasData ? '${Snapshot.data}' : '');
          },
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: sendmessage,
        tooltip: 'Send massage',
        child: Icon(Icons.send),
      ),
    );
  }
}
