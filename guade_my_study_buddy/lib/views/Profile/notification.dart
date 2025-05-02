import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, bool> toggles = {
    "General Notification": true,
    "Sound": false,
    "Vibrate": true,
    "App updates": false,
    "Bill Reminder": true,
    "Promotion": true,
    "Discount Available": false,
    "Payment Request": false,
    "New Service Available": false,
    "New Tips Available": true,
  };

  @override
  void initState() {
    super.initState();
    _loadToggleStates();
  }

  Future<void> _loadToggleStates() async {
    final prefs = await SharedPreferences.getInstance();
    toggles.forEach((key, value) {
      final savedValue = prefs.getBool(key);
      if (savedValue != null) {
        toggles[key] = savedValue;
      }
    });
    setState(() {});
  }

  Future<void> _updateToggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      toggles[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Curved Background
          ClipPath(
            clipper: _AppBarClipper(),
            child: Container(
              height: 150.0, // Adjust height as needed
              color: Colors.purple.shade100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0), // Adjust top padding for status bar
            child: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Remove shadow
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black), // Adjust icon color
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjust text color
                ),
              ),
              centerTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0), // Adjust top padding to start below the app bar
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSectionTitle("Common"),
                _buildToggleTile("General Notification"),
                _buildToggleTile("Sound"),
                _buildToggleTile("Vibrate"),
                SizedBox(height: 10),
                _buildSectionTitle("System & services update"),
                _buildToggleTile("App updates"),
                _buildToggleTile("Bill Reminder"),
                _buildToggleTile("Promotion"),
                _buildToggleTile("Discount Available"),
                _buildToggleTile("Payment Request"),
                SizedBox(height: 10),
                _buildSectionTitle("Others"),
                _buildToggleTile("New Service Available"),
                _buildToggleTile("New Tips Available"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildToggleTile(String title) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 14)),
      activeColor: const Color.fromARGB(255, 119, 5, 139),
      value: toggles[title] ?? false,
      onChanged: (value) => _updateToggle(title, value),
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30); // Start from the bottom-left and curve upwards
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}