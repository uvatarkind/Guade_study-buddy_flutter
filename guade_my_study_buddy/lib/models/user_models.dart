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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'Username': username,
      'email': email,
      'gender': gender,
      'password': password,
      'confirmPassword': confirmPassword,
      'levelOfEducation': levelOfEducation,
      'major': major,
      'token': token,
    };
  }

  // Add the copyWith method
  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? gender,
    String? password,
    String? confirmPassword,
    String? levelOfEducation,
    String? major,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      levelOfEducation: levelOfEducation ?? this.levelOfEducation,
      major: major ?? this.major,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      password: map['password'] as String,
      confirmPassword: map['confirmPassword'] as String,
      levelOfEducation: map['levelOfEducation'] as String,
      major: map['major'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
