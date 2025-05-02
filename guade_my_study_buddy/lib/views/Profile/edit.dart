// edit.dart
import 'package:flutter/material.dart';

class EditProfileApp extends StatelessWidget {
  const EditProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
 
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _borderRadius = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  String? _selectedCountry = 'Ethiopia';
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: _AppBarClipper(),
                child: Container(
                  height: 120.0, // Adjust height as needed
                  color: Color(0xFFEAD6F6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Edit profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align labels to the left
                children: [
                  Text('Full name', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Hanna Hanna',
                      border: _borderRadius,
                      enabledBorder: _borderRadius,
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Email', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'youremail@domain.com',
                      border: _borderRadius,
                      enabledBorder: _borderRadius,
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Major', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Software Engineering',
                      border: _borderRadius,
                      enabledBorder: _borderRadius,
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Country', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            SizedBox(height: 5),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: _borderRadius,
                                enabledBorder: _borderRadius,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              ),
                              value: _selectedCountry,
                              items: ['Ethiopia', 'USA', 'India']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountry = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gender', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            SizedBox(height: 5),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: _borderRadius,
                                enabledBorder: _borderRadius,
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              ),
                              value: _selectedGender,
                              items: ['Female', 'Male']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30), // Increased spacing before the button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB347E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 45), // Adjusted button height
                    ),
                    onPressed: () {},
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), // Adjusted font size
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
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