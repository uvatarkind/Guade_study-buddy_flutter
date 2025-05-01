import 'package:flutter/material.dart';

class Buddy extends StatefulWidget {
  const Buddy({Key? key}) : super(key: key);

  @override
  BuddyState createState() => BuddyState();
}

class BuddyState extends State<Buddy>{
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello Page')),
      body: Center(
        child: Text(
          'buddy',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
  }