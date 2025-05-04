import 'package:flutter/material.dart';

import './requestSent.dart';

class BuddyDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/group.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    title: "Basic Information",
                    children: [
                      _buildInfoRow(Icons.person, "Name", "Sophia Carter"),
                      _buildInfoRow(Icons.school, "Course", "Computer Science"),
                      _buildInfoRow(Icons.language, "Language", "English"),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    title: "Study Schedule",
                    children: [
                      _buildInfoRow(
                          Icons.access_time, "Study Time", "7pm - 9pm"),
                      _buildInfoRow(Icons.timer, "Duration", "2 hours"),
                      _buildInfoRow(Icons.calendar_today, "Frequency", "Daily"),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(
                    title: "Study Preferences",
                    children: [
                      _buildInfoRow(Icons.group, "Group Size", "3-5 members"),
                      _buildInfoRow(Icons.location_on, "Location", "Online"),
                      _buildInfoRow(
                          Icons.star, "Experience Level", "Intermediate"),
                    ],
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RequestSentScreen()),
                        );
                      },
                      icon: Icon(Icons.group_add),
                      label: Text("Join Study Group"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(width: 12),
          Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
