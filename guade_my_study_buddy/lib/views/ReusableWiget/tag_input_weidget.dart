import 'package:flutter/material.dart';

class TagInputWidget extends StatefulWidget {
  const TagInputWidget({Key? key}) : super(key: key);

  @override
  _TagInputWidgetState createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  // List to hold the entered tags
  final List<String> _tags = [];
  // Controller for the TextFormField
  final TextEditingController _tagController = TextEditingController();
  // Maximum number of allowed tags
  final int _maxTags = 5; // Define the maximum number of tags

  // Function to add a tag to the list
  void _addTag(String tag) {
    // Trim whitespace and check if the tag is not empty or already in the list
    final trimmedTag = tag.trim();
    // Check if the maximum tag limit has been reached
    if (_tags.length < _maxTags) {
      if (trimmedTag.isNotEmpty && !_tags.contains(trimmedTag)) {
        setState(() {
          _tags.add(trimmedTag);
        });
        // Clear the text field after adding the tag
        _tagController.clear();
      }
    } else {
      // Optionally, show a message to the user that the limit is reached
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum number of tags reached.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to remove a tag from the list
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate remaining tags
    final int remainingTags = _maxTags - _tags.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The TextFormField for inputting tags
        TextFormField(
          controller: _tagController,
          decoration: InputDecoration(
            hintText: 'eg. maths, history',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.purple[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          ),
          // Disable the text field if the maximum tag limit is reached
          enabled: _tags.length < _maxTags,
          // Add the tag when the user submits (presses Enter)
          onFieldSubmitted: _addTag,
        ),
        const SizedBox(height: 10), // Spacing between TextFormField and tags

        // Display the list of tags
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () => _removeTag(tag),
              deleteIcon: const Icon(Icons.close, size: 18),
              deleteButtonTooltipMessage: 'Remove tag',
            );
          }).toList(),
        ),
        const SizedBox(height: 8), // Spacing between tags and the count

        // Display the remaining tag count
        Text(
          'Remaining tags: $remainingTags / $_maxTags',
          style: TextStyle(
            fontSize: 12,
            color: remainingTags > 0 ? Colors.grey[600] : Colors.red,
          ),
        ),
      ],
    );
  }
}
