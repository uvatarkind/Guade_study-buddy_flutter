import 'dart:convert';
import 'package:guade_my_study_buddy/models/user_models.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:{PORT}/api/users';

  // REGISTER
  Future<UserModel?> register(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromMap(
          data['user']); // or adjust based on your API structure
    } else {
      print('Register failed: ${response.body}');
      return null;
    }
  }

  // LOGIN
  Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromMap(data['user']);
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }
}
