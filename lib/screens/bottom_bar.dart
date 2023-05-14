import 'package:wap_clone/screens/home_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const Text("Call"),
    const Text("Profile"),
    const Text("Settings")
  ];

  void onPress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("QuickChat")),
        backgroundColor: const Color(0xFFF87A44),
      ),
      body: Center(child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onPress,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFFF87A44),
        unselectedItemColor: const Color(0xFF39393A),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.messageCircleOutline),
              activeIcon: Icon(EvaIcons.messageCircle),
              label: "chat"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.phoneCallOutline),
              activeIcon: Icon(EvaIcons.phoneCall),
              label: "call"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.personOutline),
              activeIcon: Icon(EvaIcons.person),
              label: "profile"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.settings2Outline),
              activeIcon: Icon(EvaIcons.settings2),
              label: "settings")
        ],
      ),
    );
  }
}
