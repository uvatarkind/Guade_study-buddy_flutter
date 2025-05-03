import 'package:flutter/material.dart';

import 'package:guade_my_study_buddy/providers/user_provider.dart';
import 'package:guade_my_study_buddy/views/Auth/login.dart';
import 'package:guade_my_study_buddy/views/Auth/privacy_notice.dart';
import 'package:guade_my_study_buddy/views/Auth/signup_step2.dart';
import 'package:guade_my_study_buddy/views/Auth/welcome.dart';
import 'package:guade_my_study_buddy/views/HomePage.dart';
import 'package:provider/provider.dart';
import 'views/Auth/signup_step1.dart'; // <-- if you saved it as signup_step1.dart
// import 'views/Auth/signup_step2.dart'; // for the next steps

import 'package:guade_my_study_buddy/views/bottomNav.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        '/home': (context) => HomePage(),
      },
    );
  }
}
