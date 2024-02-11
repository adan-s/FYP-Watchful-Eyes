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
                        // You can navigate to the edit screen or perform other actions
                        print('Edit button pressed for ${contact.name}');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete action
                        // You can show a confirmation dialog before deleting
                        print('Delete button pressed for ${contact.name}');
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
}
