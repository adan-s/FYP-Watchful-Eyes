import 'package:flutter/material.dart';
import 'package:fyp/screens/user-panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watchful Eyes',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,

        ),

        useMaterial3: true,
      ),
      home: const UserPanel(),
      debugShowCheckedModeBanner:false,
    );
  }
}
