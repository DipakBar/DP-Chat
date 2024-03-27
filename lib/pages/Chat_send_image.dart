import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SendImage extends StatefulWidget {
  const SendImage({super.key});

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
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
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.crop_rotate,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.text_fields,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: Image.asset('assets/images/bike.jpg'),
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
                                  // controller: textcontroler,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                      hintText: "Add a caption....",
                                      border: InputBorder.none),
                                )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.hide_source))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 150,
                            child: Center(
                              child: Text(
                                'prasanta karan',
                                style: TextStyle(),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          MaterialButton(
                              onPressed: () {},
                              minWidth: 0,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(8),
                              color: Colors.blue,
                              child: const Icon(Icons.send_sharp,
                                  color: Colors.white, size: 30))
                        ],
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
