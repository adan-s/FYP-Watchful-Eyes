import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/authentication/EmergencycontactsRepo.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../authentication/models/EmergencyContact.dart';
import 'AddContact.dart';
import 'crime-registeration-form.dart';

class EmergencyContactListScreen extends StatefulWidget {
  @override
  _EmergencyContactListScreenState createState() =>
      _EmergencyContactListScreenState();
}

class _EmergencyContactListScreenState
    extends State<EmergencyContactListScreen> {
  final EmergencycontactsRepo _contactRepository = EmergencycontactsRepo();
  late List<EmergencyContact> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    loadEmergencyContacts();
  }

  void loadEmergencyContacts() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var userEmail = user.email; // Use the email of the logged-in user
      var contacts = await _contactRepository.getEmergencyContacts(userEmail!);
      setState(() {
        emergencyContacts = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
              Color(0xFFCBE1EE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: emergencyContacts.length,
          itemBuilder: (context, index) {
            var contact = emergencyContacts[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Name: ${contact.name}'),
                subtitle: Text('Contact No: ${contact.phoneNumber}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Handle edit action
                        editEmergencyContact(contact);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Contact'),
                              content: Text(
                                  'Are you sure you want to delete contact?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      var userEmail = user.email;
                                      await _contactRepository
                                          .deleteEmergencyContact(
                                              userEmail!, contact.name);
                                      loadEmergencyContacts();
                                    }
                                    Navigator.of(context)
                                        .pop(); // Close the dialog

                                    Get.snackbar(
                                      "Congratulations",
                                      "User deleted successfully.",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('No',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void editEmergencyContact(EmergencyContact contact) async {
    var originalName = contact.name;
    var originalPhoneNumber = contact.phoneNumber;

    // Show the dialogue box for editing contact details
    final updatedContact = await showDialog<EmergencyContact>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: TextEditingController(text: contact.name),
                onChanged: (value) {
                  originalName = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: TextEditingController(text: contact.phoneNumber),
                onChanged: (value) {
                  originalPhoneNumber = value;
                },
                inputFormatters: [PhoneNumberFormatter()],
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Close the dialogue box and save changes
                Navigator.of(context).pop(EmergencyContact(
                  name: originalName,
                  phoneNumber: originalPhoneNumber,
                ));
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );

    if (updatedContact != null) {
      // Show the confirmation dialogue box
      bool? confirmEdit = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Edit'),
            content: Text('Are you sure you want to edit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm edit
                },
                child: Text('Yes', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel edit
                },
                child: Text('No', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          );
        },
      );

      if (confirmEdit == true) {
        // User confirmed the edit, save the updated contact
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          var userEmail = user.email;
          await _contactRepository.updateEmergencyContact(
              userEmail!, contact.name, updatedContact);
          loadEmergencyContacts();
        }
      }
    }
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
