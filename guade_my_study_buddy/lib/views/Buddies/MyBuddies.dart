import 'package:flutter/material.dart';
import 'createBuddy.dart';
import 'BuddyChatScreen.dart';

class MyBuddiesScreen extends StatefulWidget {
  final String searchQuery;

  MyBuddiesScreen({required this.searchQuery});

  @override
  _MyBuddiesScreenState createState() => _MyBuddiesScreenState();
}

class _MyBuddiesScreenState extends State<MyBuddiesScreen> {
  String selectedStatus = 'Joined'; // Default status

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for "My Buddies" screen
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _getStatusColor(selectedStatus),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    dropdownColor: _getStatusColor(selectedStatus),
                    iconEnabledColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    isExpanded: true,
                    items: ['Joined', 'Pending', 'Request'].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Status-based content
        Expanded(child: _buildContentBasedOnStatus(selectedStatus)),

        // Create Buddy button (only for Joined or Pending)
        if (selectedStatus == 'Joined' || selectedStatus == 'Pending')
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Createbuddy()),
                  );
                },
                icon: Icon(Icons.group_add),
                label: Text("Create Buddy"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 🟣🟡🟢 Status color helper
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Joined':
        return Colors.deepPurple;
      case 'Pending':
        return Colors.amber;
      case 'Request':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildContentBasedOnStatus(String status) {
    switch (status) {
      case 'Joined':
        return _buildGroupGrid();
      case 'Pending':
        return _buildGroupGrid();
      case 'Request':
        return _buildRequestList();
      default:
        return Center(child: Text('Unknown status'));
    }
  }

  Widget _buildGroupGrid() {
    final List<Map<String, String>> buddies = [
      {
        "name": "SUPER NOVA",
        "subjects": "Maths, Physics, Astronomy",
        "image": "assets/images/buddy1.jpg"
      },
      {
        "name": "NERD HERD",
        "subjects": "Science, Biology, Chemistry",
        "image": "assets/images/buddy2.jpg"
      },
      {
        "name": "TECH CREW",
        "subjects": "CS, AI, Programming",
        "image": "assets/images/buddy3.jpg"
      },
      {
        "name": "LOGIC LEGENDS",
        "subjects": "Maths, Logic, Reasoning",
        "image": "assets/images/buddy4.jpg"
      },
    ];

    final filtered = buddies.where((buddy) {
      final query = widget.searchQuery.toLowerCase();
      return buddy['name']!.toLowerCase().contains(query) ||
          buddy['subjects']!.toLowerCase().contains(query);
    }).toList();

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: EdgeInsets.all(10),
      children: filtered.map((buddy) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuddyChatScreen(
                  buddyName: buddy['name']!,
                  buddyImage: buddy['image']!,
                ),
              ),
            );
          },
          child: Card(
            shadowColor: Colors.purple,
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(buddy['image']!, fit: BoxFit.cover),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    buddy['name']!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
                Text(
                  buddy['subjects']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRequestList() {
    return ListView(
      children: [
        _buildRequestTile("Bethel", "Super Nova"),
        _buildRequestTile("Petter", "Nerd"),
      ],
    );
  }

  Widget _buildRequestTile(String name, String group) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text("$name: wants to join your $group buddy."),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Accept"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              child: Text("Decline"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
