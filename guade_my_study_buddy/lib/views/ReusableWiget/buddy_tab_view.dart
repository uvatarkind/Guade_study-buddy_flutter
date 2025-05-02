import 'package:flutter/material.dart';
import '../Buddies/AllBuddies.dart';
import '../Buddies/MyBuddies.dart';

class BuddyTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "All Buddies"),
              Tab(text: "My Buddies"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AllBuddiesScreen(),
                MyBuddiesScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
