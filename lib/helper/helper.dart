import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wap_clone/models/chat_model.dart';
import 'package:wap_clone/models/user_data.dart';

class Helper {
  //Auth instance
  static FirebaseAuth auth = FirebaseAuth.instance;
  //DB instance
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //Storage instance
  static FirebaseStorage storage = FirebaseStorage.instance;
  //For storing current user info
  static UserData currentUser = UserData(
      image: user.photoURL.toString(),
      about: 'Hello',
      name: user.displayName.toString(),
      createdAt: '',
      isOnline: false,
      id: user.uid,
      lastActive: '',
      pushToken: '',
      email: user.email.toString());
  //To get the current user
  static User get user => auth.currentUser!;

  //For checking if user exists
  static Future<bool> userExist() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //To get info of current user
  static Future<void> getCurrentInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        currentUser = UserData.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getCurrentInfo());
      }
    });
  }

  //For new users
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final newUser = UserData(
        image: user.photoURL.toString(),
        about: "New User",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        id: user.uid,
        lastActive: time,
        pushToken: "",
        email: user.email.toString());

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson());
  }

  //Get all other users except the one using it
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //Update name and about
  static Future<void> userUpdate() async {
    await firestore
        .collection("users")
        .doc(user.uid)
        .update({'name': currentUser.name, 'about': currentUser.about});
  }

  //Update profile pic
  static Future<void> updateProfPic(File file) async {
    final extn = file.path.split('.').last;
    final ref = storage.ref().child("profile_pic/${user.uid}.$extn");
    await ref.putFile(file).then((p0) {
      log("Data transfered ${p0.bytesTransferred / 1000} kb");
    });
    currentUser.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({"image": currentUser.image});
  }

  //Getting chatroom id
  static String getChatRoomId(String id) {
    return user.uid.hashCode <= id.hashCode
        ? "${user.uid}_$id"
        : "${id}_${user.uid}";
  }

  //To get all messages of given chatroom
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMsgs(UserData user) {
    return firestore
        .collection('chats/${getChatRoomId(user.id)}/messages/')
        .snapshots();
  }

  //To send message
  static Future<void> sendMsg(UserData sendUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ChatModel message = ChatModel(
        msg: msg,
        toUID: sendUser.id,
        fromUID: user.uid,
        readTime: '',
        type: Type.text,
        sendTime: time);

    final ref =
        firestore.collection('chats/${getChatRoomId(sendUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
