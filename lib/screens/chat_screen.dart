import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wap_clone/components/message_card.dart';
import 'package:wap_clone/models/chat_model.dart';
import 'package:wap_clone/models/user_data.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                  errorWidget: (context, url, error) => const CircleAvatar(
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
                  const Text(
                    "Last seen",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
      body: Column(children: [
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
        chatTextField()
      ]),
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Color(0xFFF87A44),
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Message", border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
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
                Helper.sendMsg(widget.user, _textController.text);
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
