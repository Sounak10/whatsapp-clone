import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wap_clone/firebase_options.dart';
import 'package:wap_clone/helper/helper.dart';
import 'package:wap_clone/screens/auth/login_screen.dart';
import 'package:wap_clone/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Helper.auth.currentUser != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Quick Chat",
        theme: ThemeData(primarySwatch: Colors.orange),
        home: const HomeScreen(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Quick Chat",
        theme: ThemeData(primarySwatch: Colors.orange),
        home: const LoginScreen(),
      );
    }
  }
}
