import 'package:flutter/material.dart';

class CrimeRegistrationForm extends StatelessWidget {
  const CrimeRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crime Registeration Form'),
      ),
      body: Center(
        child: Text('This is the Crime Registeration Form.'),
      ),
    );
  }
}

