import 'package:flutter/material.dart';
import '../ReusableWiget/tag_input_weidget.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Buddy Group',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Createbuddy(),
    );
  }
}

class Createbuddy extends StatefulWidget {
  @override
  _CreatebuddyState createState() => _CreatebuddyState();
}

enum PrivacyStatus { Private, Public }

class _CreatebuddyState extends State<Createbuddy> {
  PrivacyStatus _privacyStatus = PrivacyStatus.Private;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Buddy group'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Buddy Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter Group Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple[50], // Light purple shade
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Privacy and Visibility',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile<PrivacyStatus>(
                    title: const Text('Private'),
                    value: PrivacyStatus.Private,
                    groupValue: _privacyStatus,
                    onChanged: (PrivacyStatus? value) {
                      setState(() {
                        _privacyStatus = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<PrivacyStatus>(
                    title: const Text('Public'),
                    value: PrivacyStatus.Public,
                    groupValue: _privacyStatus,
                    onChanged: (PrivacyStatus? value) {
                      setState(() {
                        _privacyStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple[50], // Light purple shade
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _privacyStatus == PrivacyStatus.Private
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Not visible to Everyone'),
                        Text(
                            '• Buddy Group membership is by invitation link only'),
                      ],
                    )
                  : Text(
                      '• Your group will be visible to everyone and can be joined directly.', // Example text for Public
                    ),
            ),
            SizedBox(height: 24),
            Text(
              'Study Group Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write any description about your study group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple[50], // Light purple shade
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Create Your Tag',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TagInputWidget(),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement Create button logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple, // Purple color
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Create',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement Cancel button logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red color
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
