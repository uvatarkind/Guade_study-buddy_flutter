import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LanguageSettingsScreen(),
    );
  }
}

class LanguageSettingsScreen extends StatefulWidget {
  @override
  _LanguageSettingsScreenState createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String? _selectedLanguage = 'English (UK)'; // Initial selected language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {
                  Navigator.pop(context); // This line makes the back button go back
                },
              ),
              title: Text(
                'Language',
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Suggested',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                  ),
                  RadioListTile<String>(
                    title: Text('English (US)'),
                    value: 'English (US)',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('English (UK)'),
                    value: 'English (UK)',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                    activeColor: Colors.purple,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Others',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                  ),
                  RadioListTile<String>(
                    title: Text('Mandarin'),
                    value: 'Mandarin',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Hindi'),
                    value: 'Hindi',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Spanish'),
                    value: 'Spanish',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('French'),
                    value: 'French',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Arabic'),
                    value: 'Arabic',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Russian'),
                    value: 'Russian',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Indonesia'),
                    value: 'Indonesia',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Vietnamese'),
                    value: 'Vietnamese',
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
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
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: 3,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
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