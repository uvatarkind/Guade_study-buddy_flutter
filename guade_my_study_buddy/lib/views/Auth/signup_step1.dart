import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/models/user_models.dart';
import 'package:guade_my_study_buddy/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignUpStep1 extends StatefulWidget {
  const SignUpStep1({super.key});

  @override
  State<SignUpStep1> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController(); // Added Username Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose(); // Dispose Username Controller
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveDataToProvider() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Creating the user object with current inputs
    UserModel user = UserModel(
      id: '', // Backend will generate this later
      name: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _selectedGender ?? '',
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      levelOfEducation: '', // To be added in SignUpStep2
      major: '', // To be added in SignUpStep2
      token: '', // Backend will provide this later
    );

    // Add username to UserModel and save data into UserProvider
    userProvider.setUserFromModel(
      user.copyWith(username: _usernameController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
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
                  Container(height: 4, width: 40, color: Colors.black),
                  Container(height: 4, width: 250, color: Colors.yellow),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Insert your personal information',
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
                    const Text("Full Name",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: _inputDecoration("Enter your full name"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Username",
                        style: TextStyle(
                            color: Colors.white)), // Added Username Field
                    const SizedBox(height: 8),
                    TextFormField(
                      controller:
                          _usernameController, // Added Username Controller
                      decoration: _inputDecoration("Choose a username"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 4) {
                          return 'Username must be at least 4 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Email", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration("Enter your email"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Gender", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    _buildGenderOption("Girl"),
                    _buildGenderOption("Boy"),
                    if (_selectedGender == null)
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0, top: 4),
                        child: Text(
                          'Please select a gender',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text("Password",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration(
                          "8 characters include numbers, alphabet"),
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Confirm Password",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: _inputDecoration(
                          "make sure its the same as the above"),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState!.validate();
                          final genderSelected = _selectedGender != null;
                          if (isValid && genderSelected) {
                            _saveDataToProvider(); // Save data locally
                            Navigator.pushNamed(context, '/signup2');
                          } else {
                            setState(() {});
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
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: RadioListTile<String>(
        value: gender,
        groupValue: _selectedGender,
        onChanged: (val) {
          setState(() {
            _selectedGender = val;
          });
        },
        title: Text(gender),
        activeColor: Colors.purple,
      ),
    );
  }
}
