import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wap_clone/components/dialogue.dart';
import 'package:wap_clone/screens/home_screen.dart';

import '../../helper/helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleSignin() {
    Dialogue.showLoadrer(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if ((await Helper.userExist())) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ));
        } else {
          await Helper.createUser().then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Helper.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signINWithGoogle');
      Dialogue.showSnackBar(context, "No Internet Connection!!!");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.only(top: 15),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "Quick",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 40)),
                  TextSpan(
                      text: "Chat",
                      style: TextStyle(
                          color: Color(0xFFF87A44),
                          fontWeight: FontWeight.bold,
                          fontSize: 40))
                ]))),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            width: w,
            height: h * 0.4,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/imgs/login.jpg"),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            height: 150,
          ),
          SizedBox(
            width: w * .9,
            height: 60,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF87A44),
                  shape: const StadiumBorder()),
              onPressed: () {
                _handleGoogleSignin();
              },
              icon: const Image(
                image: AssetImage('lib/assets/imgs/search.png'),
                width: 60,
                height: 20,
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
