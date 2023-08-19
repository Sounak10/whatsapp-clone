import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wap_clone/firebase_options.dart';
import 'package:wap_clone/helper/helper.dart';
import 'package:wap_clone/screens/auth/login_screen.dart';
import 'package:wap_clone/screens/home_screen.dart';
import 'package:wap_clone/theme/dark_theme.dart';
import 'package:wap_clone/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quick Chat",
      // theme: ThemeData(primarySwatch: Colors.orange),
      theme: lightTheme,
      darkTheme: darkTheme,
      home: (Helper.auth.currentUser != null)
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
