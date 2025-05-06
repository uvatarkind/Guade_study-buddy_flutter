import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String gender;

  final String password;
  final String confirmPassword;
  final String levelOfEducation;
  final String major;
  final String token;
  final String imageUrl; // ✅ Added for profile picture

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    required this.levelOfEducation,
    required this.major,
    required this.token,
    required this.imageUrl,
  });

  // 🔐 For registration
  Map<String, dynamic> toRegistrationMap() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // 🧾 For full profile usage
  Map<String, dynamic> toFullMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'gender': gender,
      'password': password,
      'confirmPassword': confirmPassword,
      'levelOfEducation': levelOfEducation,
      'major': major,
      'token': token,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      password: '',
      confirmPassword: '',
      levelOfEducation: map['levelOfEducation'] ?? '',
      major: map['major'] ?? '',
      token: map['token'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toFullMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
