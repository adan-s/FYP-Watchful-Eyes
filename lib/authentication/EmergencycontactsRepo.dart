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
  Future<void> updateEmergencyContact(String userEmail, String oldName, EmergencyContact newContact) async {
    var documentSnapshot = await _firestore
        .collection('emergencyContacts')
        .doc(userEmail)
        .collection('contacts')
        .where('name', isEqualTo: oldName)
        .limit(1)
        .get();

    if (documentSnapshot.docs.isNotEmpty) {
      var documentId = documentSnapshot.docs.first.id;
      await _firestore
          .collection('emergencyContacts')
          .doc(userEmail)
          .collection('contacts')
          .doc(documentId)
          .update({
        'name': newContact.name,
        'phoneNumber': newContact.phoneNumber,
      });
    }
  }

  Future<void>deleteEmergencyContact(String userEmail,String contactName) async{
    var querySnapshot = await _firestore
        .collection('emergencyContacts')
        .doc(userEmail)
        .collection('contacts')
        .where('name', isEqualTo: contactName)
        .limit(1)
        .get();

    if(querySnapshot.docs.isNotEmpty){
      var documentId=querySnapshot.docs.first.id;
      await _firestore
      .collection('emergencyContacts')
      .doc(userEmail)
      .collection('contacts')
      .doc(documentId)
      .delete();
    }
  }

}
