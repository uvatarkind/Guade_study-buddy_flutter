import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/models/my_buddies.dart';
import 'package:guade_my_study_buddy/services/api_service.dart';
// import 'package:guade_my_study_buddy/services/api_service.dart'; // Ensure this is correctly imported if used later
import '../ReusableWiget/tag_input_weidget.dart'; // Ensure this path is correct
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController =
      TextEditingController(); // Controller for image URL
  List<String>? tagList;
  String _selectedImageUrl = ''; // Variable to hold the selected image URL
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose(); // Dispose the image URL controller
    super.dispose();
  }

  void _handleCreate() async {
    try {
      // Trim whitespace from text fields
      final String name = _nameController.text.trim();
      final String description = _descriptionController.text.trim();
      final String imageUrl = _imageUrlController.text.trim();

      // Validate inputs
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a group name')),
        );
        return;
      }
      if (description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a description')),
        );
        return;
      }
      if (tagList == null || tagList!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter at least one tag')),
        );
        return;
      }
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide an image URL')),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      // Get the current user's ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      print('Debug - User ID from preferences: $userId'); // Debug log

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Create new buddy group
      Map<String, dynamic> newBuddy = {
        'name': name,
        'image': imageUrl,
        'description': description,
        'subjects': tagList!.join(','),
        'privacy': _privacyStatus == PrivacyStatus.Private
            ? 'private'
            : 'public', // Convert to lowercase enum values
        'creator': userId,
      };

      print('Debug - Request data: $newBuddy'); // Debug log

      // Call the API to create the buddy group
      await BuddyService().addBuddy(newBuddy);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Study group created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Return to previous screen
      }
    } catch (error) {
      print('Debug - Error creating buddy: $error'); // Debug log
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create study group: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _handleCancel() {
    // Check if any fields (name, description, image URL) have content
    if (_nameController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _imageUrlController.text.isNotEmpty) {
      // Include image URL controller check
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Discard Changes?'),
          content: Text('Are you sure you want to discard your changes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous screen
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(
          context); // Return to previous screen directly if no changes
    }
  }

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
            // Group Image Section
            Center(
              // Center the CircleAvatar
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40, // Larger radius for the main image
                    backgroundColor:
                        Colors.purple[100], // Placeholder background
                    backgroundImage: _selectedImageUrl.isNotEmpty
                        ? NetworkImage(
                            _selectedImageUrl) // Show network image if URL is not empty
                        : null, // No background image if URL is empty
                    child: _selectedImageUrl.isEmpty
                        ? Icon(
                            // Show an icon as placeholder if no image selected
                            Icons.group,
                            size: 40,
                            color: Colors.purple[700],
                          )
                        : null, // No child if image is loaded
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Buddy Group Image URL',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      hintText: 'Paste image URL here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.purple[50],
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15.0),
                    ),
                    keyboardType: TextInputType.url, // Suggest URL keyboard
                    onChanged: (url) {
                      // Optional: Update the preview as the user types
                      setState(() {
                        _selectedImageUrl = url.trim();
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24), // Spacing after image section

            // Buddy Name Section
            Text(
              'Buddy Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter Group Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple[50],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
            ),
            SizedBox(height: 24),

            // Privacy Section
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

            // Description Section
            Text(
              'Study Group Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write any description about your study group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple[50],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
            ),
            SizedBox(height: 24),

            // Tags Section
            Text(
              'Create Your Tag',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TagInputWidget(
              onTagsChanged: (tagsFromChildWeidget) => {
                setState(() {
                  tagList = tagsFromChildWeidget;
                  print(tagList); // Keep print for debugging if needed
                })
              },
            ),
            SizedBox(height: 40),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Create',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
