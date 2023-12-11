import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/blogs.dart';
import 'package:fyp/screens/home.dart';
import 'package:fyp/screens/login_screen.dart';
import 'package:fyp/screens/post-new-item.dart';
import 'package:fyp/screens/splashscreenweb.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBhcF3CgybYcpRRAk3TE-ZvgFlkJRagmgU',
      appId: '1:321253756082:web:9843f6a0837010ea788dab',
      messagingSenderId: '321253756082',
      projectId: 'watchfuleyes-c2a9d',
      authDomain: 'watchfuleyes-c2a9d.firebaseapp.com',
      databaseURL: 'https://watchfuleyes-c2a9d-default-rtdb.firebaseio.com',
      storageBucket: 'gs://watchfuleyes-c2a9d.appspot.com',
    ),
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Watchful Eyes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlogPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
