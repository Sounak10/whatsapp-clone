import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap_clone/components/login_field.dart';
import 'package:flutter/material.dart';

import 'forgot_pw_page.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const SignupScreen({super.key, required this.showRegisterPage});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                //App name
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
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      LoginField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      LoginField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ForgotPassword();
                              }));
                            },
                            child: Text("Forgot password?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF87A44))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: signIn,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF87A44),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Text(
                              "Sign in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Still not signed up yet!!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: widget.showRegisterPage,
                            child: const Text(
                              " Register now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF87A44)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
