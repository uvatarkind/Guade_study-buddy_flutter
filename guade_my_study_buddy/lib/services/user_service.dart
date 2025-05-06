import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:guade_my_study_buddy/models/user_models.dart'; // Import the user model

class ApiService {
  final String _baseUrl =
      'https://guade-study-buddy-node-1.onrender.com/api'; //  base URL
  final String _profileEndpoint = '/profile'; //  profile endpoint

  // Get the authentication token from shared preferences
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');
      return token;
    } catch (e) {
      developer.log('Error getting token: $e');
      return null;
    }
  }

  // Fetch user profile data from the API
  Future<UserModel?> fetchUserProfile() async {
    final token = await _getToken();
    if (token == null) {
      developer.log('No authentication token found.');
      return null;
    }

    final Uri uri = Uri.parse('$_baseUrl$_profileEndpoint');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        developer.log('Response body: ${response.body}');
        try {
          final dynamic data = json.decode(response.body);
          developer.log('Type of data: ${data.runtimeType}'); // ADD THIS LINE
          developer.log('Value of data: $data'); // ADD THIS LINE
          return UserModel.fromJson(data);
        } catch (e) {
          developer.log('Error decoding JSON: $e');
          return null;
        }
      } else {
        developer.log(
            'Failed to fetch profile. Status code: ${response.statusCode}');
        developer.log('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      developer.log('Error fetching profile: $error');
      return null;
    }
  }
}
