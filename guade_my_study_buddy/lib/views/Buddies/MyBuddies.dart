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
  List<Map<String, String>> buddies = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchBuddies();
  }

  Future<void> fetchBuddies() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      List<dynamic> buddiesFromJson = await BuddyService().getBuddies();

      setState(() {
        buddies = buddiesFromJson.map((item) {
          final Map<String, dynamic> buddyMap = item as Map<String, dynamic>;
          return {
            'name': buddyMap['name']?.toString() ?? 'Unknown',
            'subjects': buddyMap['subjects'] is List
                ? (buddyMap['subjects'] as List).join(', ')
                : buddyMap['subjects']?.toString() ?? 'No subjects',
            'image':
                buddyMap['image']?.toString() ?? 'assets/images/profile.jpg',
          };
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load buddies: $error';
        isLoading = false;
      });
      print('Error fetching buddies: $error');
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
                      if (value != null) {
                        setState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Status-based content
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(
                      child: Text(errorMessage!,
                          style: TextStyle(color: Colors.red)))
                  : _buildContentBasedOnStatus(selectedStatus),
        ),

        // Create Buddy button (only for Joined or Pending)
        if (selectedStatus == 'Joined' || selectedStatus == 'Pending')
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Createbuddy()),
                  );
                  if (mounted) {
                    fetchBuddies(); // Refresh the list after creating a new buddy
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
      case 'Pending':
        return _buildGroupGrid();
      case 'Request':
        return _buildRequestList();
      default:
        return Center(child: Text('Unknown status'));
    }
  }

  Widget _buildGroupGrid() {
    final filtered = buddies.where((buddy) {
      final query = widget.searchQuery.toLowerCase();
      final name = buddy['name']?.toLowerCase() ?? '';
      final subjects = buddy['subjects']?.toLowerCase() ?? '';
      return name.contains(query) || subjects.contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No buddies found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

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
                  buddyName: buddy['name'] ?? 'Unknown',
                  buddyImage: buddy['image'] ?? 'assets/images/profile.jpg',
                ),
              ),
            );
          },
          child: Card(
            shadowColor: Colors.purple,
            elevation: 4,
            child: Column(
              children: [
                if (buddy['image']?.startsWith('http') ?? false)
                  Expanded(
                    child: Image.network(
                      buddy['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: Image.asset(
                      buddy['image'] ?? 'assets/images/profile.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    buddy['name'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Text(
                  buddy['subjects'] ?? 'No subjects',
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
      child: ListTile(
        leading: CircleAvatar(
          child: Text(name[0]),
        ),
        title: Text(name),
        subtitle: Text(group),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () {
                // Handle accept
              },
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                // Handle reject
              },
            ),
          ],
        ),
      ),
    );
  }
}
