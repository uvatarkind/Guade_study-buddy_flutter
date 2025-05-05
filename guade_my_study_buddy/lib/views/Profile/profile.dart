import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/user_models.dart';
import '/services/user_service.dart';
import 'edit.dart';
import 'notification.dart';
import 'language.dart';
import 'policy.dart';
import 'package:image_picker/image_picker.dart';
import '/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  String? _profileImagePath;

  final TextEditingController nameController =
  TextEditingController(text: "Hanna Hanna");
  final TextEditingController emailController =
  TextEditingController(text: "youremail@domain.com");
  final TextEditingController phoneController =
  TextEditingController(text: "+01 234 567 89");

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token != null) {
      final userService = UserService();
      final user = await userService.fetchUserProfile(token);

      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
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
                  color: Colors.deepPurple,
                ),
              ),
              Transform.translate(
                offset: Offset(0, -80),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: _isLoading
                              ? AssetImage("assets/images/profile.jpg")
                              : (_user?.imageUrl != null
                              ? NetworkImage(_user!.imageUrl!)
                              : (_profileImagePath != null
                              ? FileImage(File(_profileImagePath!))
                              : AssetImage("assets/images/profile.jpg"))
                          ) as ImageProvider<Object>,
                        ),
                        if (_isLoading)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircularProgressIndicator(),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImageFromGallery,
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
                    _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      _user?.name ?? "Unknown",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      "${_user?.email ?? "Unknown"}",
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
  const ProfileSection({super.key});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String notificationStatus = "ON";
  bool _isLoggingOut = false;

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

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    final authService = AuthService();
    bool success = await authService.logout();

    if (success) {
      setState(() => _isLoggingOut = false);

      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (route) => route.isFirst);
    } else {
      setState(() => _isLoggingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Logout failed! Try again.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    MaterialPageRoute(builder: (context) => NotificationsScreen()),
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
                    MaterialPageRoute(builder: (context) => LanguageSettingsScreen()),
                  );
                },
                trailing: Text("English", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              buildTile(Icons.lock_outline, "Security"),
              Divider(),
              buildTile(
                Icons.brightness_6_outlined,
                "Theme",
                trailing: Text("Light mode", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoggingOut ? null : _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoggingOut
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Logout",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
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
