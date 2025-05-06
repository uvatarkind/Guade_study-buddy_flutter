import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/models/user_models.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
      id: '',
      name: '',
      username: '',
      email: '',
      gender: '',
      password: '',
      imageUrl: '',
      confirmPassword: '',
      levelOfEducation: '',
      major: '',
      token: '');
  UserModel get user => _user;

  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
