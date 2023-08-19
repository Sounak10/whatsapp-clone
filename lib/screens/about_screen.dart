import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wap_clone/models/user_data.dart';

class AboutScreen extends StatefulWidget {
  final UserData user;
  const AboutScreen({super.key, required this.user});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: const Color(0xFFF87A44),
        title: Text(widget.user.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: CachedNetworkImage(
              height: 180,
              width: 180,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.user.email,
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "About: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                widget.user.about,
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
