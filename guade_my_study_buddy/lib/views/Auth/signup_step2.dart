import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignUpStep2 extends StatefulWidget {
  const SignUpStep2({super.key});

  @override
  State<SignUpStep2> createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();

  @override
  void dispose() {
    _educationController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void _saveDataToProvider() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUserFromModel(
      userProvider.user.copyWith(
        levelOfEducation: _educationController.text.trim(),
        major: _majorController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9C27B0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(height: 4, width: 140, color: Colors.black),
                  Container(height: 4, width: 150, color: Colors.yellow),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'What are you currently studying?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Level of Education",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _educationController,
                      decoration: _inputDecoration("Degree"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Education level is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Major", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _majorController,
                      decoration: _inputDecoration("ex. Software engineering"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Major is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 400),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveDataToProvider(); // Save data locally
                            Navigator.pushNamed(context, '/signup3');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.yellow[800],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Next",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }
}



