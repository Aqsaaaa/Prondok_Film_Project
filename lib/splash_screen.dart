import 'dart:async';
import 'package:flutter/material.dart';
import 'gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1c1c1c),
      body: Center(
        child: Container(
          width: 200.0,
          height: 200.0,
          child: Assets.images.logo.image(),
        ),
      ),
    );
  }
}
