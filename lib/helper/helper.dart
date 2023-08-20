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
        about: "Hi there I am using QuickChat",
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
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds.isEmpty ? [''] : userIds)
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('known_users')
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
        .orderBy('sendTime', descending: true)
        .snapshots();
  }

  //To send message
  static Future<void> sendMsg(UserData sendUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ChatModel message = ChatModel(
        msg: msg,
        toUID: sendUser.id,
        fromUID: user.uid,
        readTime: '',
        type: type,
        sendTime: time);

    final ref =
        firestore.collection('chats/${getChatRoomId(sendUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //To get last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMsg(UserData user) {
    return firestore
        .collection('chats/${getChatRoomId(user.id)}/messages/')
        .orderBy('sendTime', descending: true)
        .limit(1)
        .snapshots();
  }

  //send image in chat
  static Future<void> sendChatImage(UserData userData, File file) async {
    final extn = file.path.split('.').last;
    final ref = storage.ref().child(
        "images/${getChatRoomId(userData.id)}/${DateTime.now().millisecondsSinceEpoch}.$extn");
    await ref.putFile(file).then((p0) {
      log("Data transfered ${p0.bytesTransferred / 1000} kb");
    });
    final imgUrl = await ref.getDownloadURL();

    await sendMsg(userData, imgUrl, Type.image);
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('known_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }

  static Future<void> sendFirstMessage(
      UserData sendUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(sendUser.id)
        .collection('known_users')
        .doc(user.uid)
        .set({}).then((value) {
      sendMsg(sendUser, msg, type);
    });
  }
}
