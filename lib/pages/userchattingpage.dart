import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserChattingPage extends StatefulWidget {
  @override
  State<UserChattingPage> createState() => _UserChattingPageState();
}

class _UserChattingPageState extends State<UserChattingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            height: 200,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {},
              onBackspacePressed: () {},
              // textEditingController: textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
              config: Config(
                columns: 7,
                emojiSizeMax: 32 * (Platform.isAndroid ? 1.30 : 1.10),
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: Color(0xFFF2F2F2),
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
      ),
    );
  }
}
