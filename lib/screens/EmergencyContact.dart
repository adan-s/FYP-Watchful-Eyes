import 'package:flutter/material.dart';
import 'package:fyp/authentication/EmergencycontactsRepo.dart';

import '../authentication/models/EmergencyContact.dart';

class EmergencyContactListScreen extends StatefulWidget {
  @override
   _EmergencyContactListScreenState createState() => _EmergencyContactListScreenState();
}

class _EmergencyContactListScreenState extends State<EmergencyContactListScreen> {
  final EmergencycontactsRepo _contactRepository = EmergencycontactsRepo();
  late List<EmergencyContact> emergencyContacts;

  @override
  void initState() {
    super.initState();
    loadEmergencyContacts();
  }

  void loadEmergencyContacts() async {
    var userEmail = 'user_email@example.com'; // Replace with actual user email
    var contacts = await _contactRepository.getEmergencyContacts(userEmail);
    setState(() {
      emergencyContacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
      ),
      body: ListView.builder(
        itemCount: emergencyContacts.length,
        itemBuilder: (context, index) {
          var contact = emergencyContacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
          );
        },
      ),
    );
  }
}
