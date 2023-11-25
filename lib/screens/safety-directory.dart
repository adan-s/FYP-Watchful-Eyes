import 'package:flutter/material.dart';

class SafetyDirectory extends StatelessWidget {
  const SafetyDirectory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Directory'),
      ),
      body: Center(
        child: Text('This is the Safety Directory page.'),
      ),
    );
  }
}

