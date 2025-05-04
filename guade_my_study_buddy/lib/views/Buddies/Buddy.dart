import 'package:flutter/material.dart';
import './AllBuddies.dart';
import './MyBuddies.dart';

class BuddiesPage extends StatefulWidget {
  @override
  _BuddiesPageState createState() => _BuddiesPageState();
}

class _BuddiesPageState extends State<BuddiesPage> {
  String searchQuery = "";

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
        body: Column(
          children: [
            // Global Search bar for both screens (at the top)
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search buddies...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  AllBuddiesScreen(searchQuery: searchQuery), // All buddies tab
                  MyBuddiesScreen(searchQuery: searchQuery), // My buddies tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
