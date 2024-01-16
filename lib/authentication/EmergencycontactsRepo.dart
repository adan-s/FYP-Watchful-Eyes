import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/EmergencyContact.dart';

class EmergencycontactsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEmergencyContact(String userEmail, EmergencyContact contact) async {
    await _firestore
        .collection('emergencyContacts')
        .doc(userEmail) // Use user's email as the document ID
        .collection('contacts')
        .add(contact.toMap());
  }

  Future<List<EmergencyContact>> getEmergencyContacts(String userEmail) async {
    var querySnapshot = await _firestore
        .collection('emergencyContacts')
        .doc(userEmail)
        .collection('contacts')
        .get();

    return querySnapshot.docs
        .map((doc) => EmergencyContact.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
