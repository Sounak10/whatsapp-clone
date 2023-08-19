import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wap_clone/components/dialogue.dart';
import 'package:wap_clone/models/user_data.dart';
import 'package:wap_clone/screens/auth/login_screen.dart';

import '../helper/helper.dart';

class ProfileScreen extends StatefulWidget {
  final UserData user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? profImage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text('About User'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent.shade100,
            icon: const Icon(Icons.logout_rounded),
            label: const Text("Logout"),
            onPressed: () async {
              await Helper.auth.signOut();
              await GoogleSignIn().signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                  ),
                  Stack(
                    children: [
                      profImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.file(
                                File(profImage!),
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: CachedNetworkImage(
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          color: Colors.white,
                          shape: const CircleBorder(),
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
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 30, bottom: 40),
                                          child: Center(
                                            child: Text(
                                              "Choose Profile Photo",
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    fixedSize:
                                                        const Size(120, 120)),
                                                onPressed: () async {
                                                  final ImagePicker picker =
                                                      ImagePicker();
                                                  // Pick an image.
                                                  final XFile? image =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  if (image != null) {
                                                    log("Image Path: ${image.path}");
                                                    setState(() {
                                                      profImage = image.path;
                                                    });
                                                  }
                                                  Helper.updateProfPic(
                                                      File(profImage!));
                                                  Navigator.pop(context);
                                                },
                                                child: Image.asset(
                                                    'lib/assets/imgs/gallery1.png')),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    backgroundColor:
                                                        Colors.white,
                                                    fixedSize:
                                                        const Size(120, 120)),
                                                onPressed: () async {
                                                  final ImagePicker picker =
                                                      ImagePicker();
                                                  // Pick an image.
                                                  final XFile? image =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  if (image != null) {
                                                    log("Image Path: ${image.path}");
                                                    setState(() {
                                                      profImage = image.path;
                                                    });
                                                  }
                                                  Helper.updateProfPic(
                                                      File(profImage!));
                                                  Navigator.pop(context);
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
                          child: const Icon(
                            Icons.edit,
                            color: Color(0xFFF87A44),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => Helper.currentUser.name = val ?? "",
                      validator: (val) => (val != null && val.isNotEmpty)
                          ? null
                          : "Required Fields",
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(CupertinoIcons.profile_circled),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hintText: "Enter new nickname",
                          label: const Text("Name")),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => Helper.currentUser.about = val ?? "",
                      validator: (val) => (val != null && val.isNotEmpty)
                          ? null
                          : "Required Fields",
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                              CupertinoIcons.bubble_left_bubble_right_fill),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hintText: "Hi there,I am using Quick Chat",
                          label: const Text("About")),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFF87A44))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Helper.userUpdate().then((value) {
                          Dialogue.showSnackBar(
                              context, "Name and about successfully updated!");
                        });
                      }
                    },
                    label: const Text("Change Data"),
                    icon: const Icon(Icons.edit),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
