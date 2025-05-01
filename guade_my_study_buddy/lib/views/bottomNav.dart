import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Buddies/AllBuddies.dart';
import 'Profile/profile.dart';
import 'Progress/progress.dart';

class MainNavPage extends StatefulWidget {
  @override
  _MainNavPageState createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    Buddy(),
    // Progress(),
    // Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,

        type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Buddies'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_rounded), label: 'Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
    );
  }
}
