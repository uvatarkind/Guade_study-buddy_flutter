import 'package:flutter/material.dart';

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
        // Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
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
          ),
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
        return Card(
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
              const SizedBox(
                height: 4,
              )
            ],
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
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
