import 'dart:developer';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wap_clone/components/dialogue.dart';
import 'package:wap_clone/components/user_card.dart';
import 'package:wap_clone/helper/helper.dart';
import 'package:wap_clone/models/user_data.dart';
import 'package:wap_clone/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserData> list = [];
  List<UserData> filterList = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    Helper.getCurrentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                addChatUserPrompt();
              },
              backgroundColor: Color(0xFFF87A44),
              child: const Icon(
                Icons.add_comment_rounded,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            elevation: 3,
            title: isSearching
                ? TextField(
                    onChanged: (value) {
                      filterList.clear();
                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          filterList.add(i);
                        }
                        setState(() {
                          filterList;
                        });
                      }
                    },
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter username or email"),
                    autofocus: true,
                    cursorColor: Colors.black,
                  )
                : const Text(
                    "Quick Chat",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
            // backgroundColor: const Color(0xFFF87A44),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      filterList.clear();
                    });
                  },
                  icon: isSearching
                      ? const Icon(Icons.cancel)
                      : const Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProfileScreen(user: Helper.currentUser)));
                  },
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: CachedNetworkImage(
                      imageUrl: Helper.currentUser.image,
                      height: 25,
                      width: 25,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person_crop_circle_fill),
                      ),
                    ),
                  ))
            ],
          ),
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: FloatingActionButton(
          //     elevation: 3,
          //     onPressed: () {},
          //     child: const Icon(Icons.add_comment_rounded),
          //   ),
          // ),
          body: StreamBuilder(
            stream: Helper.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: Helper.getAllUser(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          list = data
                                  ?.map(((e) => UserData.fromJson(e.data())))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: isSearching
                                    ? filterList.length
                                    : list.length,
                                padding: const EdgeInsets.only(top: 7),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return UserCard(
                                      user: isSearching
                                          ? filterList[index]
                                          : list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "No Chats Yet",
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void addChatUserPrompt() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add_alt_sharp,
                    color: Color(0xFFF87A44),
                    size: 26,
                  ),
                  Text("  Add new persons"),
                ],
              ),
              content: TextFormField(
                  maxLines: null,
                  onChanged: (value) => email = value,
                  decoration: InputDecoration(
                      hintText: "email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)))),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFFF87A44), fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (email.isNotEmpty) {
                      await Helper.addChatUser(email).then((value) {
                        if (!value) {
                          Dialogue.showSnackBar(context, "User does not exist");
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Color(0xFFF87A44), fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
