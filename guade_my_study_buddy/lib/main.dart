import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/views/bottomNav.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainNavPage(),
    );
  }
}
