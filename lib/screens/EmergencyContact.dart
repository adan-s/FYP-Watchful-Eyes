import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/authentication/EmergencycontactsRepo.dart';

import '../authentication/models/EmergencyContact.dart';
import 'AddContact.dart';
import 'crime-registeration-form.dart';

class EmergencyContactListScreen extends StatefulWidget {
  @override
  _EmergencyContactListScreenState createState() => _EmergencyContactListScreenState();
}

class _EmergencyContactListScreenState extends State<EmergencyContactListScreen> {
  final EmergencycontactsRepo _contactRepository = EmergencycontactsRepo();
  late List<EmergencyContact> emergencyContacts = []; // Initialize with an empty list

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

        actions: [
          ResponsiveAppBarActions(),
        ],
        title: Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white),
        ),
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
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit action
                        editEmergencyContact(contact);
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Contact'),
                              content: Text('Are you sure you want to delete contact ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    User? user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      var userEmail = user.email;
                                      await _contactRepository.deleteEmergencyContact(userEmail!, contact.name);
                                      loadEmergencyContacts();
                                    }
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('Delete'),
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
    EmergencyContact originalContact = EmergencyContact(name: contact.name, phoneNumber: contact.phoneNumber);

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
                  originalContact.name = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: TextEditingController(text: contact.phoneNumber),
                onChanged: (value) {
                  originalContact.phoneNumber = value;
                },
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(originalContact);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedContact != null) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var userEmail = user.email;
        await _contactRepository.updateEmergencyContact(userEmail!, contact.name, updatedContact);
        loadEmergencyContacts();
      }
    }
  }


}