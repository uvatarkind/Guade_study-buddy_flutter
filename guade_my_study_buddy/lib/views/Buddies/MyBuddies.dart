import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/services/api_service.dart';
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
  List<Map<String, String>>? buddies = [];
  /*          // todo: 
  List<Map<String, String>> buddies = [
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
*/
  @override
  void initState() {
    super.initState();
    fetchBuddies();
  }

  Future<void> fetchBuddies() async {
    try {
      List<dynamic> buddiesFromJson = await BuddyService().getBuddies();

      setState(() {
        buddies = buddiesFromJson
            .map((item) => (item as Map<String, dynamic>).map((key, value) {
                  if (key == 'subjects' && value is List<String>) {
                    return MapEntry(
                        key,
                        value.join(
                            ', ')); // Convert list to comma-separated string
                  }
                  return MapEntry(key, value.toString());
                }))
            .toList();
      });

      print('IT WORKS PERFECTLY!!');
    } catch (error) {
      print('Error fetching data from the local server: $error');
    }
  }

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
                onPressed: () async {
                  // Make the callback async to reRender each time a new buddy is created

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Createbuddy()),
                  );
                  if (mounted) {
                    setState(() {
                      print('Returned from Createbuddy, Parent refreshing...');
                    });
                  }
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
    final filtered = buddies != null
        ? buddies!.where((buddy) {
            final query = widget.searchQuery.toLowerCase();
            return buddy['name']!.toLowerCase().contains(query) ||
                buddy['subjects']!.toLowerCase().contains(query);
          }).toList()
        : [];
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
                buddy['image'].toString().contains('https')
                    ? Expanded(
                        child: Image.network(
                          buddy['image']!, // Replace with your image URL
                          fit: BoxFit
                              .cover, // Adjust how the image fits inside the container
                        ),
                      )
                    : Expanded(
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        _buildRequestTile("Bethel", "Super Nova"),
        const SizedBox(height: 8),
        _buildRequestTile("Petter", "Nerd"),
      ],
    );
  }

  Widget _buildRequestTile(String name, String group) {
    return Card(
      margin: EdgeInsets.zero,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    name[0],
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "wants to join your $group buddy",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: const Text("Decline"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: const Text("Accept"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
