import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/authentication/EmergencycontactsRepo.dart';
import 'package:fyp/authentication/authentication_repo.dart';

import '../authentication/models/EmergencyContact.dart';

class AddContact extends StatelessWidget {
  final EmergencycontactsRepo _contactRepository = EmergencycontactsRepo();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _addEmergencyContact(String userEmail) async {
    var contact = EmergencyContact(
      name: _nameController.text,
      phoneNumber: _phoneNumberController.text,
    );

    await _contactRepository.addEmergencyContact(userEmail, contact);

    // Clear the input fields after adding the contact
    _nameController.clear();
    _phoneNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    User? user = AuthenticationRepository.instance.firebaseUser.value;

    if (user == null) {
      // Return a loading indicator or a placeholder widget
      return CircularProgressIndicator();
    }

    var userEmail = user.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Emergency Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (userEmail != null) {
                  _addEmergencyContact(userEmail);
                } else {
                  // Handle the case when the user's email is not available
                }
              },
              child: Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
