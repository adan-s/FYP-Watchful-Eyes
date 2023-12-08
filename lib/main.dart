import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/admindashboard.dart';
import 'package:fyp/screens/login_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDex47P0QzSiSZyTW9IJgp-bKxlXnqdLEk",
      projectId: "watchfuleyes-c2a9d",
      messagingSenderId: "321253756082",
      appId: "1:321253756082:android:5aa51edcfa0d845e788dab",
    ),
  );
  runApp(MyApp());
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
      home: AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
