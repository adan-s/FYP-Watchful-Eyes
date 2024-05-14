import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../authentication/models/EmergencyContact.dart';
import '../authentication/EmergencycontactsRepo.dart';
import '../authentication/authentication_repo.dart';
import 'EmergencyContact.dart';
import 'community-forum.dart';

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
        builder: (context) => AlertDialog(
          title: Text('Invalid Phone Number'),
          content:
          Text('Please enter a valid phone number format: +923XXXXXXXXX'),
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

    Get.snackbar(
      "Congratulations",
      "Contact added successfully.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Define the regex pattern for the required phone number format
    RegExp regex = RegExp(r'^\+923\d{9}$');

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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF769DC9),
          title: Text('Emergency Contact', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          leading: ResponsiveAppBarActions(),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Image.asset(
                    'assets/emergencycall.png',
                    height: 200, // Adjust the height as needed
                    width: 200, // Adjust the width as needed
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+923000000000',
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    counterText: '',
                  ),
                  inputFormatters: [PhoneNumberFormatter()],
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _phoneNumberController.text.isNotEmpty) {
                        if (userEmail != null) {
                          _addEmergencyContact(context, userEmail);
                        } else {
                          // Handle the case when userEmail is null
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Incomplete Form'),
                            content: Text('Please fill in both name and phone number.'),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_call),
                        Text(
                          "Add Contact",
                          style: TextStyle(
                            fontFamily: 'outfit',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmergencyContactListScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.contacts_outlined),
                        Text(
                          "Show Contacts",
                          style: TextStyle(
                            fontFamily: 'outfit',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Only allow digits and limit the length to 12 characters
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newText.length > 12) {
      newText = newText.substring(0, 12);
    }

    // Format the phone number
    StringBuffer formattedText = StringBuffer('+');
    for (int i = 0; i < newText.length; i++) {
      formattedText.write(newText[i]);
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
