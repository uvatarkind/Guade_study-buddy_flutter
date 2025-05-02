import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Sent',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RequestSentScreen(),
    );
  }
}

class RequestSentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar background transparent
        elevation: 0, // Remove app bar shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            // TODO: Implement navigation back
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true, // Allow body to go behind the app bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // The purple checkmark icon within a shape
              // Note: Replicating the exact intricate shape might require
              // a custom painter or using an image asset.
              // Below is an approximation using a standard icon in a container.
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.purple, // Purple background
                  shape: BoxShape.circle, // Circular shape, adjust for more complex shape
                  // For the exact shape, consider using a custom painter or SVG/image.
                ),
                child: Icon(
                  Icons.check, // Checkmark icon
                  size: 60,
                  color: Colors.white, // White checkmark
                ),
              ),
              SizedBox(height: 40),
              // The request sent message box
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.purple[50], // Light purple background
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Column(
                  children: [
                    Text(
                      'Request sent !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You will be notified when you're accepted!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Back to Home page button
              TextButton(
                onPressed: () {
                  // TODO: Implement navigation to Home page
                  // Example: Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'Back to Home page',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple, // Purple text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}