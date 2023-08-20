import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wap_clone/components/message_card.dart';
import 'package:wap_clone/models/chat_model.dart';
import 'package:wap_clone/models/user_data.dart';
import 'package:wap_clone/screens/about_screen.dart';

import '../helper/helper.dart';

class ChatScreen extends StatefulWidget {
  final UserData user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> list = [];
  final _textController = TextEditingController();
  bool showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (showEmoji) {
          setState(() {
            showEmoji = !showEmoji;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          // backgroundColor: const Color(0xFFF87A44),
          automaticallyImplyLeading: false,
          flexibleSpace: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AboutScreen(user: widget.user)));
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image,
                          height: 36,
                          width: 36,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            child: Icon(CupertinoIcons.person_crop_circle_fill),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Last seen",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary),
                          )
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(children: [
            Expanded(
              child: StreamBuilder(
                stream: Helper.getAllMsgs(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map(((e) => ChatModel.fromJson(e.data())))
                              .toList() ??
                          [];

                      if (list.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: list.length,
                            padding: const EdgeInsets.only(top: 7),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: list[index]);
                            });
                      } else {
                        return const Center(
                          child: Text(
                            "Send a Msg😜",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            chatTextField(),
            if (showEmoji)
              SizedBox(
                height: 200,
                child: EmojiPicker(
                  textEditingController: _textController,
                  config: const Config(columns: 7),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget chatTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          showEmoji = !showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Color(0xFFF87A44),
                      )),
                  Expanded(
                      child: TextField(
                    onTap: () {
                      if (showEmoji) {
                        setState(() {
                          showEmoji = !showEmoji;
                        });
                      }
                    },
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Message", border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))),
                            context: context,
                            builder: (_) {
                              return Wrap(children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 30, horizontal: 60),
                                      child: Center(
                                        child: Text(
                                          "Select source ",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                backgroundColor: Colors.white,
                                                fixedSize:
                                                    const Size(120, 120)),
                                            onPressed: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final List<XFile> images =
                                                  await picker.pickMultiImage(
                                                      imageQuality: 70);
                                              Navigator.pop(context);
                                              for (var i in images) {
                                                await Helper.sendChatImage(
                                                    widget.user, File(i.path));
                                              }
                                            },
                                            child: Image.asset(
                                                'lib/assets/imgs/gallery1.png')),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                backgroundColor: Colors.white,
                                                fixedSize:
                                                    const Size(120, 120)),
                                            onPressed: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final XFile? image =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 70);

                                              if (image != null) {
                                                Navigator.pop(context);
                                                await Helper.sendChatImage(
                                                    widget.user,
                                                    File(image.path));
                                              }
                                            },
                                            child: Image.asset(
                                                'lib/assets/imgs/camera.png'))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ]);
                            });
                      },
                      icon: const Icon(
                        Icons.attach_file,
                        color: Color(0xFFF87A44),
                      ))
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (list.isEmpty) {
                  Helper.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  Helper.sendMsg(widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFFF87A44),
              padding: const EdgeInsets.only(left: 3, top: 10, bottom: 10),
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
