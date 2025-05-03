import 'package:flutter/material.dart';
import './AllBuddies.dart';
import './MyBuddies.dart';

class BuddiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Buddy List"),
          bottom: TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.deepPurple,
            tabs: [
              Tab(text: "All Buddies"),
              Tab(text: "My Buddies"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllBuddiesScreen(),
            MyBuddiesScreen(),
          ],
        ),
      ),
    );
  }
}
