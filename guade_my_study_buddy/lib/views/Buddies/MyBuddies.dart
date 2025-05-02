import 'package:flutter/material.dart';

class MyBuddiesScreen extends StatefulWidget {
  @override
  _MyBuddiesScreenState createState() => _MyBuddiesScreenState();
}

class _MyBuddiesScreenState extends State<MyBuddiesScreen> {
  String selectedStatus = 'Joined'; // Default status

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: selectedStatus,
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
        // Content
        Expanded(
          child: _buildContentBasedOnStatus(selectedStatus),
        ),
      ],
    );
  }

  Widget _buildContentBasedOnStatus(String status) {
    switch (status) {
      case 'Joined':
        return _buildGroupGrid(); // Study group cards + "Create buddies" button
      case 'Pending':
        return _buildGroupGrid(); // Same layout, maybe with a "Pending" tag
      case 'Request':
        return _buildRequestList(); // ListView of join requests
      default:
        return Center(child: Text('Unknown status'));
    }
  }

  Widget _buildGroupGrid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(10),
      children: List.generate(4, (index) {
        return Card(
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                  child: Image.asset('assets/group.jpg', fit: BoxFit.cover)),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("SUPER NOVA",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text("Maths, Physics, Astronomy", style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      }),
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
            ElevatedButton(onPressed: () {}, child: Text("Accept")),
            SizedBox(width: 8),
            ElevatedButton(
                onPressed: () {},
                child: Text("Decline"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
          ],
        ),
      ),
    );
  }
}
