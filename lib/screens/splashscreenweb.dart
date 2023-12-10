import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fyp/screens/user-panel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
  }

  _loadSplashScreen() async {
    const splashDuration = Duration(seconds: 5);

    Timer(splashDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserPanel()), // Update to your UserPanel page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/map.json',
              width: 200,
              height: 200,
            ),
            Lottie.asset(
              'assets/community.json',
              width: 200,
              height: 200,
            ),
            Lottie.asset(
              'assets/security.json',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

