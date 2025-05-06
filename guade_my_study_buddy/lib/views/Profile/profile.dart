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
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  String? _profileImagePath;
  bool _isUploadingImage = false;

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
    try {
      setState(() => _isLoading = true);
      final userService = ApiService();
      final user = await userService.fetchUserProfile();

      if (user != null) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (error) {
      developer.log('Error loading profile: $error');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploadingImage = true;
          _profileImagePath = pickedFile.path;
        });

        // TODO: Implement image upload to server
        // For now, we'll just update the local state
        await Future.delayed(const Duration(seconds: 1)); // Simulate upload

        setState(() {
          _isUploadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      developer.log('Error picking image: $error');
      setState(() => _isUploadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile image: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
                offset: const Offset(0, -80),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: _isLoading
                              ? const AssetImage("assets/images/profile.jpg")
                              : (_user?.imageUrl != null &&
                                          _user!.imageUrl!.isNotEmpty
                                      ? NetworkImage(_user!.imageUrl!)
                                      : (_profileImagePath != null
                                          ? FileImage(File(_profileImagePath!))
                                          : const AssetImage(
                                              "assets/images/profile.jpg")))
                                  as ImageProvider<Object>,
                        ),
                        if (_isLoading || _isUploadingImage)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploadingImage
                                ? null
                                : _pickImageFromGallery,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: _isUploadingImage
                                    ? Colors.grey
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            _user?.name ?? "Yubi",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            _user?.email ?? "Unknown",
                            style: const TextStyle(color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(height: 20),
                    const ProfileSection(),
                    const SizedBox(height: 80),
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
      items:
          <String>['ON', 'OFF'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
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
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      final authService = AuthService();
      bool success = await authService.logout();

      if (success) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed! Try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      developer.log('Logout error: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
              ),
              const Divider(),
              buildTile(
                Icons.notifications_outlined,
                "Notifications",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsScreen()),
                  );
                },
                trailing: buildToggleText(),
              ),
              const Divider(),
              buildTile(
                Icons.language_outlined,
                "Language",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LanguageSettingsScreen()),
                  );
                },
                trailing:
                    const Text("English", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              buildTile(Icons.lock_outline, "Security"),
              const Divider(),
              buildTile(
                Icons.brightness_6_outlined,
                "Theme",
                trailing: const Text("Light mode",
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              buildTile(Icons.help_outline, "Help & Support"),
              const Divider(),
              buildTile(Icons.mail_outline, "Contact us"),
              const Divider(),
              buildTile(
                Icons.privacy_tip_outlined,
                "Privacy policy",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoggingOut ? null : _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoggingOut
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
