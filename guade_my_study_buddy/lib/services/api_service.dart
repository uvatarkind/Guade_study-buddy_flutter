import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:5000';
  static const String tokenKey = 'auth_token';

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Store token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Remove token (for logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Get headers with authentication
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic GET request
  static Future<dynamic> get(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // Generic POST request
  static Future<dynamic> post(String endpoint, dynamic data) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Generic PUT request
  static Future<dynamic> put(String endpoint, dynamic data) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Generic DELETE request
  static Future<dynamic> delete(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // Handle API response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}

// ! Just for localserver
class BuddyService {
  //!!! DON'T FORGET TO ADD THE LOCAL SEVER HERE
  // !! HOW WOULD YOU HANDLE THE IMAGE THERE IS NO GROUP PROFILE IMAGE PROVIDER
  final String baseUrl = 'http://localhost:3123'; // TODO: don't forget to run the with the correct port number
  

  // Fetch buddies list
  Future<List<dynamic>> getBuddies() async {
    final response = await http.get(Uri.parse('$baseUrl/myBuddies'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load buddies');
    }
  }

  // Add a new buddy
  Future<void> addBuddy(Map<String, dynamic> newBuddy) async {
    final response = await http.post(
      Uri.parse('$baseUrl/myBuddies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newBuddy),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add buddy');
    }
  }
}


class HoursService {
  //!!! DON'T FORGET TO ADD THE LOCAL SERVER HERE
  final String baseUrl = 'http://localhost:3123'; // TODO: don't forget to run with the correct port number

  // Fetch hours spent list
  Future<List<dynamic>> getHoursSpent() async {
    final response = await http.get(Uri.parse('$baseUrl/hoursSpent'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load hours spent data');
    }
  }

  // Add new hours spent entry
  Future<void> addHoursSpent(Map<String, dynamic> newEntry) async {
    final response = await http.post(
      Uri.parse('$baseUrl/hoursSpent'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newEntry),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add hours spent entry');
    }
  }
}
