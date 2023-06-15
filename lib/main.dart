import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(), 
      },
    );
  }
}
