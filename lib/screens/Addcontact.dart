import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/authentication/EmergencycontactsRepo.dart';
import 'package:fyp/authentication/authentication_repo.dart';
import '../authentication/models/EmergencyContact.dart';
import 'EmergencyContact.dart';


class AddContact extends StatelessWidget {
  final EmergencycontactsRepo _contactRepository = EmergencycontactsRepo();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _addEmergencyContact(BuildContext context, String userEmail) async {
    // Validate phone number format
    if (!_isValidPhoneNumber(_phoneNumberController.text)) {
      // Show an error message or handle the invalid phone number format
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Invalid Phone Number'),
              content: Text(
                  'Please enter a valid phone number format: +923XXXXXXXXX'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    var contact = EmergencyContact(
      name: _nameController.text,
      phoneNumber: _phoneNumberController.text,
    );

    await _contactRepository.addEmergencyContact(userEmail, contact);
    _nameController.clear();
    _phoneNumberController.clear();
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Define the regex pattern for the required phone number format
    RegExp regex = RegExp(r'^\+\d{12}$'); // + followed by 12 digits

    // Check if the phone number matches the pattern
    return regex.hasMatch(phoneNumber);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFCBE1EE),
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Centered TextField for Name
              Center(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              // Centered TextField for Phone Number
              Center(
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+923215722553',
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.phone, // Use the phone icon
                      color: Colors.white,
                    ),
                    counterText: '', // To hide the character counter
                  ),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                  maxLength: 13, // Set the maximum length
                ),

              ),
              SizedBox(height: 32),
              // Row with Add Contact and Show Contacts buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _phoneNumberController.text.isNotEmpty) {
                        if (userEmail != null) {
                          _addEmergencyContact(context, userEmail);
                        } else {
                          // Handle the case when userEmail is null
                        }
                      } else {
                        // Show an error message for incomplete form
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('Incomplete Form'),
                                content: Text(
                                    'Please fill in both name and phone number.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                        );
                      }
                    },
                    child: Text('Add Contact'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmergencyContactListScreen()),
                      );
                    },
                    child: Text('Show Contacts'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
