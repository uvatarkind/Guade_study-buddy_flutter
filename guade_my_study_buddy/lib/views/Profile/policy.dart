import 'package:flutter/material.dart';

class PrivacyPolicyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrivacyPolicyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Assuming Profile is selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Buddies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty_outlined),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: _AppBarClipper(),
                  child: Container(
                    height: 120.0, // Adjust as needed
                    color: Color(0xFFF0E6F9), // Light purple background
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // This line makes the back button go back
                    },
                  ),
                ),
                Positioned(
                  top: 60.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    '1. Types of data we collect',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'When you use Study Buddy, we may collect the following types of information:\n\n'
                        '- Your profile information, such as your name, username, and any other details you provide.\n'
                        '- Information about your study habits, including subjects you are studying, your progress, and study session durations.\n'
                        '- Your interactions with other users, such as messages and shared resources.\n'
                        '- Device information, including your device model, operating system, and unique identifiers.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '2. Use of your personal data',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'We use the collected data to:\n\n'
                        '- Personalize your learning experience by suggesting relevant study materials and buddies.\n'
                        '- Facilitate communication and collaboration with other users.\n'
                        '- Track your progress and provide insights into your study habits.\n'
                        '- Improve and optimize the Study Buddy app and its features.\n'
                        '- Send you notifications related to your study sessions and app updates.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '3. Disclosure of your personal data',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'We may share your information with:\n\n'
                        '- Other users of Study Buddy when you interact with them (e.g., through messages or shared study groups).\n'
                        '- Service providers who assist us in operating and improving the app (e.g., hosting, analytics).\n'
                        '- Legal authorities if required by law or to protect our rights and safety.\n\n'
                        'We will not sell your personal data to third parties for marketing purposes without your explicit consent.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '4. Data security',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'We take reasonable measures to protect your personal data from unauthorized access, use, or disclosure. However, no method of transmission over the internet or electronic storage is completely secure.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '5. Your rights',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'You have the right to access, correct, or delete your personal data. You can manage your information through your profile settings within the app. For any further inquiries or requests, please contact us.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '6. Changes to this policy',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or via email. Please review this policy periodically for updates.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30); // Adjust the - value to control the curve
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