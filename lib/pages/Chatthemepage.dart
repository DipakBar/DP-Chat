import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/controler/chat_controler.dart';
import 'package:flutter_application_1/ex.dart';
import 'package:flutter_application_1/pages/chatcontroler.dart';
// import 'package:flutter_application_1/pages/reciveer_deshoard.dart';
import 'package:flutter_application_1/pages/uservoicecall.dart';
import 'package:flutter_application_1/pages/videocall.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/details.dart';
import 'package:flutter_application_1/pages/massage_information.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart' as foundation;
import 'package:photo_view/photo_view.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart' as path_provider;

// ignore: must_be_immutable
class UserChatThemePage extends StatefulWidget {
  Details user;
  // ignore: use_key_in_widget_constructors
  UserChatThemePage(this.user);

  @override
  // ignore: no_logic_in_create_state
  State<UserChatThemePage> createState() => _UserChatThemePageState(user);
}

class _UserChatThemePageState extends State<UserChatThemePage>
    with WidgetsBindingObserver {
  Details user;
  _UserChatThemePageState(this.user);
  ChatControler chatControler = ChatControler();
  late IO.Socket socket;

  bool emoji = false;
  bool showfile = false;
  final TextEditingController textcontroler = TextEditingController();
  TextEditingController msgcontroler = TextEditingController();
  String time = DateFormat("HH:mm").format(DateTime.now());
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  // List<Message> messages = []
  DPChatConteoler chatConteoler = DPChatConteoler();
  String sendid = '';
  final scroll = ScrollController();
  late SharedPreferences sp;
  double x = 0.0;
  TextEditingController emojiController = TextEditingController();
  StreamController<List<Message>> msglist = StreamController();
  late Stream<List<Message>> msgstream;
  // ignore: prefer_final_fields
  ImagePicker _picker = ImagePicker();
  XFile? file;
  File? compreesed_image;
  String attachment = '';
  bool online = false;

  void connect() {
    socket = IO.io(
        "http://192.168.0.107:5000",
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNewConnection()
            .enableReconnection()
            .build());

    socket.connect();
    socket.emit("signin", {sendid});
    socket.onConnect((data) {
      online = true;
      print("connected");
      scrollItem();
      socket.on("message-recived", (data) {
        print(data);
        chatConteoler.dpmessage.add(Message.fromJosn(data['message']));
        scrollItem();
      });
    });
    print(socket.connected);
    socket.onDisconnect((_) {
      print('Connection Disconnection');
      online = false;
    });
  }

  Future getMessage(String sendid, String receiveid) async {
    Map data = {'sender_id': sendid, 'receiver_id': receiveid};
    var response = await http.post(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.http(MyUrl.mainurl, MyUrl.suburl + "getmessage.php"),
        body: data);
    var jsondata = jsonDecode(response.body);
    if (jsondata['status'] == true) {
      chatConteoler.dpmessage.clear();
      for (int i = 0; i < jsondata['data'].length; i++) {
        Message massage = Message(
            sender_id: jsondata['data'][i]['sender_id'],
            receiver_id: jsondata['data'][i]['receiver_id'],
            massage_date: jsondata['data'][i]['massage_date'],
            massage_time: jsondata['data'][i]['massage_time'],
            attachment: jsondata['data'][i]['attachment'],
            content: jsondata['data'][i]['content']);
        chatConteoler.dpmessage.add(massage);
      }
      msglist.sink.add(chatConteoler.dpmessage);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future MessegeInsert(
      String sender_id,
      String receiver_id,
      String massage_date,
      String massage_time,
      File? attachment,
      String content) async {
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "send_massage.php"));
      if (attachment != null) {
        request.files.add(await http.MultipartFile.fromBytes(
            'attachment', attachment.readAsBytesSync(),
            filename: attachment.path.split("/").last));
      }
      request.fields['sender_id'] = sender_id;
      request.fields['receiver_id'] = receiver_id;
      request.fields['massage_date'] = massage_date;
      request.fields['massage_time'] = massage_time;
      request.fields['content'] = content;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);

      if (jsondata['status'] == true) {
        this.attachment = jsondata['attachment'].toString();
        print("Message Send Successfully");
      } else {
        print("not Send");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Navigator.pop(context);
    }
  }

  void dispose() {
    textcontroler.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    getSenderId().whenComplete(() {
      connect();
      getMessage(sendid, user.userid).whenComplete(() {
        scrollItem().then((value) {
          setState(() {});
        });
      });
    });
    msgstream = msglist.stream.asBroadcastStream();
  }

  void checkImageCompreesed() async {
    final bytes = await file!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;
    print("Before Compreesed: ${mb}");

    final newbytes = await compreesed_image!.readAsBytes();
    final newkb = newbytes.length / 1024;
    final newmb = newkb / 1024;
    print("After Compreesed: ${newmb}");
  }

  Future scrollItem() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scroll.animateTo(scroll.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  Future getSenderId() async {
    sp = await SharedPreferences.getInstance();
    sendid = sp.getString('userid') ?? "";
  }

  selecteitem(BuildContext context, value) {
    switch (value) {
      case 0:
        print("view01");
        break;
      case 1:
        print("view12");
        break;
      case 2:
        print("view23");
        break;
      case 3:
        print("view34");
        break;
      case 4:
        print("view4");
        break;
    }
  }

  selectednested(BuildContext context, value) {
    switch (value) {
      case 0:
        print("view0");
        break;
      case 1:
        print("view1");
        break;
      case 2:
        print("view2");
        break;
      case 3:
        print("view3");
        break;
      case 4:
        print("view4");
        break;
      case 5:
        print("view5");
        break;
    }
  }

  Widget sendimage() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(compreesed_image!.path)),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(color: Colors.white),
                          ],
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.photo)),
                              Expanded(
                                  child: TextFormField(
                                onChanged: (value) {},
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                },
                                maxLines: 4,
                                minLines: 1,
                                controller: msgcontroler,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    hintText: "Add a caption....",
                                    border: InputBorder.none),
                              )),
                              // IconButton(
                              //     onPressed: () {}, icon: Icon(Icons.hide_source))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 150,
                          // ignore: sort_child_properties_last
                          child: Center(
                            child: Text(
                              user.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        MaterialButton(
                            onPressed: () {
                              if (compreesed_image != null) {
                                MessegeInsert(
                                        sendid,
                                        user.userid,
                                        date,
                                        time,
                                        File(compreesed_image!.path),
                                        msgcontroler.text)
                                    .whenComplete(() {
                                  var messagejoshon = {
                                    "sender_id": sendid,
                                    "receiver_id": user.userid,
                                    "massage_date": date,
                                    "massage_time": time,
                                    "attachment": attachment,
                                    "content": msgcontroler.text
                                  };
                                  print(messagejoshon);
                                  socket.emit('message', {
                                    "message": messagejoshon,
                                    "senderid": sendid,
                                    "reciverid": user.userid
                                  });
                                  socket.emit('message', messagejoshon);
                                  chatConteoler.dpmessage
                                      .add(Message.fromJosn(messagejoshon));

                                  Navigator.pop(context);

                                  setState(() {
                                    scrollItem();
                                    msgcontroler.text = '';
                                    compreesed_image = null;
                                    attachment = '';
                                  });
                                });
                              } else {}
                            },
                            minWidth: 0,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(8),
                            color: Colors.blue,
                            child: const Icon(Icons.send_sharp,
                                color: Colors.white, size: 50))
                      ],
                    )
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          setState(() {
            emoji = false;
            showfile = false;
          });
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // setState(() {});
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )),
                        user.photo != ''
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(MyUrl.fullurl +
                                    MyUrl.imageurl +
                                    user.photo),
                              )
                            : CircleAvatar(
                                radius: 20,
                                child: Text(user.name[0]),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(user)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                              online == false
                                  ? Text(
                                      time,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    )
                                  : const Text(
                                      'online',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoCall(user)));
                            },
                            icon: const Icon(
                              Icons.video_call,
                              color: Colors.black,
                            )),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserVoiceCall(user)));
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.black,
                            )),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          offset: const Offset(0, 60),
                          color: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          elevation: 0,
                          itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0,
                                child: Row(
                                  children: [
                                    Text("View contact"),
                                  ],
                                )),
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text('Media,links,and docs'),
                            ),
                            const PopupMenuItem<int>(
                              value: 2,
                              child: Text('Search'),
                            ),
                            const PopupMenuItem<int>(
                              value: 3,
                              child: Text('Mute notifications'),
                            ),
                            const PopupMenuItem<int>(
                              value: 4,
                              child: Text('Disappering Masages'),
                            ),
                            const PopupMenuItem<int>(
                              value: 5,
                              child: Text('Wallpaper'),
                            ),
                            PopupMenuItem<int>(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("More"),
                                PopupMenuButton(
                                  onSelected: (value) =>
                                      selectednested(context, value),
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                  offset: const Offset(15, -295),
                                  color: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  itemBuilder: (context) {
                                    Navigator.pop(context);
                                    return [
                                      const PopupMenuItem(
                                          value: 0, child: Text("Report")),
                                      const PopupMenuItem(
                                          value: 1, child: Text("Block")),
                                      const PopupMenuItem(
                                          value: 2, child: Text("Clear chat")),
                                      const PopupMenuItem(
                                          value: 3, child: Text("Export chat")),
                                      const PopupMenuItem(
                                          value: 4, child: Text("Add shortcut"))
                                    ];
                                  },
                                ),
                              ],
                            )),
                          ],
                          onSelected: (value) => selecteitem(context, value),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 25),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45)),
                      color: Color.fromARGB(255, 23, 227, 241),
                    ),
                    child: StreamBuilder<List<Message>>(
                        stream: msgstream,
                        builder: (context, snapshot) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (scroll.hasClients) {
                              scroll.jumpTo(scroll.position.maxScrollExtent);
                            } else {
                              setState(() {});
                            }
                          });
                          return Obx(
                            () => ListView.builder(
                                controller: scroll,
                                reverse: false,
                                shrinkWrap: true,
                                itemCount: chatConteoler.dpmessage.length,
                                itemBuilder: ((context, index) {
                                  if (chatConteoler
                                          .dpmessage[index].sender_id ==
                                      sendid) {
                                    if (chatConteoler
                                            .dpmessage[index].attachment ==
                                        '') {
                                      return Align(
                                        alignment: Alignment.topRight,
                                        child: sendermsgview(
                                          msg: chatConteoler
                                              .dpmessage[index].content,
                                        ),
                                      );
                                    } else {
                                      return Align(
                                          alignment: Alignment.topRight,
                                          child: sendernetworkimageview(
                                              imagefile: chatConteoler
                                                  .dpmessage[index].attachment,
                                              msg: chatConteoler
                                                  .dpmessage[index].content));
                                    }
                                  } else {
                                    if (chatConteoler
                                            .dpmessage[index].attachment ==
                                        '') {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: receivermsgview(
                                          msg: chatConteoler
                                              .dpmessage[index].content,
                                        ),
                                      );
                                    } else {
                                      return Align(
                                          alignment: Alignment.topLeft,
                                          child: reciverimageview(
                                              imagefile: chatConteoler
                                                  .dpmessage[index].attachment,
                                              msg: chatConteoler
                                                  .dpmessage[index].content));
                                    }
                                  }
                                })),
                          );
                        })),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 23, 227, 241),
                ),
                child: SafeArea(
                    child: Row(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(color: Colors.white),
                          ],
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  if (showfile) {
                                    showfile = false;
                                  }
                                  emoji = !emoji;
                                });
                              },
                              icon:
                                  const Icon(Icons.sentiment_satisfied_sharp)),
                          Expanded(
                              child: TextFormField(
                            onChanged: (value) {},
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (showfile) {
                                setState(() {
                                  showfile = !showfile;
                                });
                              }
                              FocusScope.of(context).unfocus();
                              if (emoji) {
                                setState(() {
                                  emoji = !emoji;
                                });
                              }
                            },
                            maxLines: 4,
                            minLines: 1,
                            controller: textcontroler,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                hintText: "Type massage",
                                border: InputBorder.none),
                          )),
                          IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  if (emoji) {
                                    emoji = false;
                                  }
                                  showfile = !showfile;
                                });
                              },
                              icon: Icon(Icons.attach_file)),
                          IconButton(
                              onPressed: () async {
                                file = await _picker.pickImage(
                                    source: ImageSource.camera);

                                final dir =
                                    await path_provider.getTemporaryDirectory();
                                final target_path =
                                    '${dir.absolute.path}/temp.jpg';
                                final result = await FlutterImageCompress
                                    .compressAndGetFile(file!.path, target_path,
                                        minHeight: 1080,
                                        minWidth: 1080,
                                        quality: 90);
                                compreesed_image = File(result!.path);
                                checkImageCompreesed();

                                if (compreesed_image != null) {
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                      context: context,
                                      builder: (context) => sendimage());
                                }
                              },
                              icon: Icon(Icons.camera_alt_outlined)),
                        ],
                      ),
                    )),
                    Container(
                      child: MaterialButton(
                          onPressed: () {
                            if (textcontroler.text != '') {
                              var messagejoshon = {
                                "sender_id": sendid,
                                "receiver_id": user.userid,
                                "massage_date": date,
                                "massage_time": time,
                                "attachment": '',
                                "content": textcontroler.text
                              };
                              print(messagejoshon);
                              // socket.emit('message', messagejoshon);
                              socket.emit('message', {
                                "message": messagejoshon,
                                "senderid": sendid,
                                "reciverid": user.userid
                              });
                              chatConteoler.dpmessage
                                  .add(Message.fromJosn(messagejoshon));
                              MessegeInsert(sendid, user.userid, date, time,
                                  null, textcontroler.text);

                              setState(() {
                                scrollItem();
                                textcontroler.text = '';
                              });
                            }
                          },
                          minWidth: 0,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(8),
                          color: Colors.blue,
                          child: const Icon(
                            Icons.send_sharp,
                            color: Colors.white,
                            size: 30,
                          )),
                    ),
                  ],
                )),
              ),
              if (showfile)
                Container(
                  height: 100,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 30,
                              ),
                              Column(children: [
                                MaterialButton(
                                    onPressed: () async {
                                      file = await _picker.pickImage(
                                          source: ImageSource.camera);
                                      file = await _picker.pickImage(
                                          source: ImageSource.gallery);

                                      final dir = await path_provider
                                          .getTemporaryDirectory();
                                      final target_path =
                                          '${dir.absolute.path}/temp.jpg';
                                      final result = await FlutterImageCompress
                                          .compressAndGetFile(
                                              file!.path, target_path,
                                              minHeight: 1080,
                                              minWidth: 1080,
                                              quality: 90);
                                      compreesed_image = File(result!.path);
                                      checkImageCompreesed();
                                      if (compreesed_image != null)
                                        showDialog(
                                            context: context,
                                            builder: (context) => sendimage());
                                    },
                                    minWidth: 0,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(8),
                                    color: Colors.red,
                                    child: const Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                      size: 50,
                                    )),
                                Text("Camera")
                              ]),
                              Column(children: [
                                MaterialButton(
                                    onPressed: () async {
                                      file = await _picker.pickImage(
                                          source: ImageSource.gallery);

                                      final dir = await path_provider
                                          .getTemporaryDirectory();
                                      final target_path =
                                          '${dir.absolute.path}/temp.jpg';
                                      final result = await FlutterImageCompress
                                          .compressAndGetFile(
                                              file!.path, target_path,
                                              minHeight: 1080,
                                              minWidth: 1080,
                                              quality: 90);
                                      compreesed_image = File(result!.path);
                                      checkImageCompreesed();

                                      if (compreesed_image != null) {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (context) => sendimage());
                                      }
                                    },
                                    minWidth: 0,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.pink,
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 50,
                                    )),
                                const Text("Gallery")
                              ]),
                              const SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (emoji)
                SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: textcontroler,
                      onBackspacePressed: () {
                        textcontroler
                          ..text = textcontroler.text.characters.toString()
                          ..selection = TextSelection.fromPosition(
                              TextPosition(offset: textcontroler.text.length));
                      },
                      config: Config(
                        columns: 7,

                        emojiSizeMax: 32 * (Platform.isAndroid ? 1.30 : 1.10),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ), // Needs to be const Widget
                        loadingIndicator:
                            const SizedBox.shrink(), // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    )),
            ],
          )),
        ),
      ),
    );
  }
}

class sendermsgview extends StatelessWidget {
  const sendermsgview({
    super.key,
    required this.msg,
  });
  final String msg;
  // final bool SentByMe;
  // Color perpale=Colors.purple;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat("HH:mm").format(DateTime.now());
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 45,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 40, top: 5, bottom: 10),
              child: Text(
                msg,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 10,
              child: Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class receivermsgview extends StatelessWidget {
  const receivermsgview({
    super.key,
    required this.msg,
  });
  final String msg;
  // Color perpale=Colors.purple;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat("HH:mm").format(DateTime.now());
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 45,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Colors.lightBlue,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 40, top: 5, bottom: 10),
              child: Text(
                msg,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 10,
              child: Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class reciverimageview extends StatelessWidget {
  const reciverimageview({
    super.key,
    required this.imagefile,
    required this.msg,
  });

  final String imagefile;
  final String msg;

  @override
  Widget build(BuildContext context) {
    if (imagefile != '' && msg != '') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Container(
                                  child: PhotoView(
                                // maxScale: 2.0,
                                // minScale: 0.5,
                                imageProvider: NetworkImage(
                                  MyUrl.fullurl + MyUrl.chaturl + imagefile,
                                ),
                              )));
                    },
                    child: Image.network(
                      MyUrl.fullurl + MyUrl.chaturl + imagefile,
                      height: 250,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    msg,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            elevation: 10,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.7,
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => Container(
                              child: PhotoView(
                            imageProvider: NetworkImage(
                              MyUrl.fullurl + MyUrl.chaturl + imagefile,
                            ),
                          )));
                },
                child: Image.network(
                  MyUrl.fullurl + MyUrl.chaturl + imagefile,
                  height: 300,
                  width: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class sendernetworkimageview extends StatelessWidget {
  const sendernetworkimageview({
    super.key,
    required this.imagefile,
    required this.msg,
  });

  final String imagefile;
  final String msg;

  @override
  Widget build(BuildContext context) {
    if (imagefile != '' && msg != '') {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Container(
                                  child: PhotoView(
                                // maxScale: 2.0,
                                // minScale: 0.5,
                                imageProvider: NetworkImage(
                                  MyUrl.fullurl + MyUrl.chaturl + imagefile,
                                ),
                              )));
                    },
                    child: Image.network(
                      MyUrl.fullurl + MyUrl.chaturl + imagefile,
                      height: 250,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      msg,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Card(
            elevation: 10,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.7,
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => Container(
                              child: PhotoView(
                            // maxScale: 2.0,
                            // minScale: 0.5,
                            imageProvider: NetworkImage(
                              MyUrl.fullurl + MyUrl.chaturl + imagefile,
                            ),
                          )));
                },
                child: Image.network(
                  MyUrl.fullurl + MyUrl.chaturl + imagefile,
                  height: 300,
                  width: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
// sendernetworkimageview(String imagefile, String msg) {
  //   if (imagefile != '' && msg != '') {
  //     return Align(
  //       alignment: Alignment.centerRight,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //         child: Card(
  //           elevation: 10,
  //           child: Container(
  //             width: MediaQuery.of(context).size.width / 1.8,
  //             decoration: BoxDecoration(
  //               color: Colors.black,
  //               border: Border.all(color: Colors.white, width: 8),
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     showDialog(
  //                         context: context,
  //                         builder: (context) => Container(
  //                                 child: PhotoView(
  //                               // maxScale: 2.0,
  //                               // minScale: 0.5,
  //                               imageProvider: NetworkImage(
  //                                 MyUrl.fullurl + MyUrl.chaturl + imagefile,
  //                               ),
  //                             )));
  //                   },
  //                   child: Image.network(
  //                     MyUrl.fullurl + MyUrl.chaturl + imagefile,
  //                     height: 250,
  //                     width: 200,
  //                     fit: BoxFit.fill,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(4.0),
  //                   child: Text(
  //                     msg,
  //                     style: const TextStyle(color: Colors.white, fontSize: 15),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Align(
  //       alignment: Alignment.centerRight,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
  //         child: Card(
  //           elevation: 10,
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 2.7,
  //             width: MediaQuery.of(context).size.width / 1.8,
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.white, width: 8),
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: InkWell(
  //               onTap: () {
  //                 showDialog(
  //                     context: context,
  //                     builder: (context) => Container(
  //                             child: PhotoView(
  //                           // maxScale: 2.0,
  //                           // minScale: 0.5,
  //                           imageProvider: NetworkImage(
  //                             MyUrl.fullurl + MyUrl.chaturl + imagefile,
  //                           ),
  //                         )));
  //               },
  //               child: Image.network(
  //                 MyUrl.fullurl + MyUrl.chaturl + imagefile,
  //                 height: 300,
  //                 width: 200,
  //                 fit: BoxFit.fill,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }