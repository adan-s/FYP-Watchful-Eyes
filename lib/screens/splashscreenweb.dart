import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
    // Wait for 2 seconds
    await Future.delayed(Duration(seconds: 3));

    // Navigate to the next screen (UserPanel)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserPanel()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF193552), // Set the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Lottie.asset(
              'assets/loading.json', // Change to 'loading.json'
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            TyperAnimatedTextKit(
              text: ["WATCHFUL EYES"],
              textStyle: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: 'outfit',
                shadows: [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2)],
              ),
              speed: Duration(milliseconds: 150), // Adjust the speed (slower)
            ),
          ],
        ),
      ),
    );
  }
}
