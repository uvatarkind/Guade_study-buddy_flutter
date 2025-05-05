import 'dart:convert';
import 'package:guade_my_study_buddy/models/user_models.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      'https://guade-study-buddy-node-1.onrender.com/api';

  // REGISTER
  Future<UserModel?> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toRegistrationMap()),
      );

      final data = jsonDecode(response.body);

      developer.log('Register API Call Response: ${response.body}');

      if (response.statusCode == 200 && data.containsKey('user')) {
        developer.log('Account created successfully! Navigating to login...');
        return UserModel.fromMap({
          ...data['user'],
          'token': data['token'],
        });
      } else if (data.containsKey('message') &&
          data['message'].contains("Account created successfully!")) {
        developer.log('Account created successfully! Navigating to login...');
        return UserModel.fromMap({
          ...data['user'],
          'token': data['token'],
        });
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      developer.log('Register error: $e');
      rethrow;
    }
  }

  // LOGIN

  Future<UserModel?> login(String email, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/users/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      developer.log('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        UserModel user =
            UserModel.fromMap({...data['user'], 'token': data['token']});

        // ✅ Store token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', user.token);

        // 🔍 Log to confirm the token is stored
        developer.log('Stored Token: ${prefs.getString('authToken')}');
        return user;
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      developer.log('Login error: $e');
      rethrow;
    }
  }

  // FORGOT PASSWORD FUNCTION
  Future<String> forgotPassword(String email) async {
    try {
      final uri = Uri.parse(
          'https://guade-study-buddy-node-1.onrender.com/api/users/forgot-password');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      developer.log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return data['message']; // ✅ Return backend message
      } else {
        return data['message'] ?? 'An unknown error occurred.';
      }
    } catch (error) {
      developer.log('Forgot Password error: $error');
      return 'Failed to connect to the server.';
    }
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    developer.log('Retrieved token before logout: $token');

    if (token != null && token.isEmpty) {
      developer.log('Logout failed: No token found.');
      return false;
    }

    final uri = Uri.parse('$baseUrl/users/signout');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    developer.log('Response Status: ${response.statusCode}');
    developer.log('Response Body: ${response.body}');

    if (response.statusCode == 202) {
      await prefs.clear();
      return true;
    } else {
      return false;
    }
  }
}
