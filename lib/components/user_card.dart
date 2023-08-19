import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wap_clone/components/message_card.dart';
import 'package:wap_clone/components/time_format.dart';
import 'package:wap_clone/helper/helper.dart';
import 'package:wap_clone/models/chat_model.dart';
import 'package:wap_clone/models/user_data.dart';
import 'package:wap_clone/screens/chat_screen.dart';

class UserCard extends StatefulWidget {
  final UserData user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  ChatModel? chat;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: Helper.getLastMsg(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                chat = list[0];
              }
              return ListTile(
                // leading: const CircleAvatar(
                //   child: Icon(CupertinoIcons.person),),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(22.5),
                  child: CachedNetworkImage(
                    height: 45,
                    width: 45,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(
                  chat != null
                      ? chat!.type == Type.text
                          ? chat!.msg
                          : "Image"
                      : widget.user.about,
                  maxLines: 1,
                ),
                trailing: chat == null
                    ? null
                    : Text(
                        TimeFormat.getFormattedTime(
                            context: context, time: chat!.sendTime),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
              );
            },
          )),
    );
  }
}
