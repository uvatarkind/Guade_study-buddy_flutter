// main.dart
import 'dart:io'; // Import for File

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picker
import 'edit.dart';
import 'notification.dart';
import 'language.dart';
import 'policy.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget { // Make it StatefulWidget
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController =
  TextEditingController(text: "Hanna Hanna");
  final TextEditingController emailController =
  TextEditingController(text: "youremail@domain.com");
  final TextEditingController phoneController =
  TextEditingController(text: "+01 234 567 89");

  String? _profileImagePath; // To store the selected image path

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
      print('Image selected: ${_profileImagePath}');
      // You might want to save this path somewhere persistent
      // (e.g., using shared_preferences) so it loads next time.
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: _AppBarClipper(),
                child: Container(
                  height: 180,
                  color: Color(0xFFEAD6F6),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -80),
                child: Column(
                  children: [
                    Stack( // Wrap the CircleAvatar with a Stack
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: _profileImagePath != null
                                ? FileImage(File(_profileImagePath!)) as ImageProvider<Object>?
                                : AssetImage("assets/avatar.png") as ImageProvider<Object>?, // Use _profileImagePath
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImageFromGallery, // Call the image picker function
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      nameController.text,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${emailController.text} | ${phoneController.text}",
                      style: TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ProfileSection(),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSection extends StatefulWidget {
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String notificationStatus = "ON";

  Widget buildTile(
      IconData icon,
      String title, {
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget buildToggleText() {
    return DropdownButton<String>(
      value: notificationStatus,
      items: <String>['ON', 'OFF'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            notificationStatus = newValue;
          });
        }
      },
      underline: SizedBox(),
      icon: Icon(Icons.arrow_drop_down),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              buildTile(
                Icons.edit_outlined,
                "Edit profile information",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              Divider(),
              buildTile(
                Icons.notifications_outlined,
                "Notifications",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsScreen()),
                  );
                },
                trailing: buildToggleText(),
              ),
              Divider(),
              buildTile(
                Icons.language_outlined,
                "Language",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguageSettingsScreen()),
                  );
                },
                trailing:
                Text("English", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              buildTile(Icons.lock_outline, "Security"),
              Divider(),
              buildTile(
                Icons.brightness_6_outlined,
                "Theme",
                trailing:
                Text("Light mode", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              buildTile(Icons.help_outline, "Help & Support"),
              Divider(),
              buildTile(Icons.mail_outline, "Contact us"),
              Divider(),
              buildTile(
                Icons.privacy_tip_outlined,
                "Privacy policy",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}