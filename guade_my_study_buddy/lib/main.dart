import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/user_provider.dart';
import './views/Auth/login.dart';
import './views/Auth/privacy_notice.dart';
import './views/Auth/signup_step2.dart';
import './views/Auth/welcome.dart';
import 'views/Auth/signup_step1.dart'; 

import 'package:guade_my_study_buddy/views/bottomNav.dart';


void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider(),)
  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Study Buddy',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signup1': (context) => const SignUpStep1(),
        '/signup2': (context) => const SignUpStep2(), 
        '/signup3': (context) => const PrivacyNotice(),
        '/login': (context) => const LoginPage(),
        '/home':(context) =>  MainNavPage (),
      },

    );
  }
}
