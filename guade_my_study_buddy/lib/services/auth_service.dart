import 'dart:convert';
import 'package:guade_my_study_buddy/models/user_models.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

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
      final uri = Uri.parse('$baseUrl/users/login'); // ✅ Correct API URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Debugging logs
      developer.log('Login API Call: $uri');
      developer.log('Request Body: ${jsonEncode({
            'email': email,
            'password': password
          })}');
      developer.log('Response Status: ${response.statusCode}');
      developer.log('Response Body: ${response.body}');

      // Handle the response
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return UserModel.fromMap({
          ...data['user'],
          'token': data['token'],
        });
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      developer.log('Login error: $e');
      rethrow;
    }
  }
}
