import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wap_clone/models/user_data.dart';
import 'package:wap_clone/screens/chat_screen.dart';

class UserCard extends StatefulWidget {
  final UserData user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
          child: ListTile(
            // leading: const CircleAvatar(
            //   child: Icon(CupertinoIcons.person),),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: CachedNetworkImage(
                height: 45,
                width: 45,
                imageUrl: widget.user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: const Text(
              "12:00 pm",
              style: TextStyle(color: Colors.black54),
            ),
          )),
    );
  }
}
