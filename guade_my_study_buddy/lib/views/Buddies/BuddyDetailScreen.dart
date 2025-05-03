import 'package:flutter/material.dart';

import './requestSent.dart';
class BuddyDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buddy Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/group.jpg"),
            SizedBox(height: 10),
            Text("Name: Sophia Carter"),
            Text("Course Studied: Computer Science"),
            Text("Study session time: 7pm - 9pm"),
            Text("Language: English"),
            Text("Duration: 2 hours"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RequestSentScreen()));
              },
              child: Text("Join"),
            ),
          ],
        ),
      ),
    );
  }
}
