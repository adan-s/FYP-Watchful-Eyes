import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationAlerts {
  static Future<void> sendCrimeNotification(Map<String, dynamic> crimeData) async {
    try {
      List<String> contacts = await fetchAllUserContacts();

      var locationLink =
          'https://maps.google.com/?q=${crimeData['latitude']},${crimeData['longitude']}';
      var message =
          'Crime Alert! Type: ${crimeData['crimeType']}, Description: ${crimeData['description']}, Location: $locationLink';

      for (var contact in contacts) {
        await _simulateSendMessage(contact, message);
      }
    } catch (e) {
      print('Error sending crime notification: $e');
    }
  }

  static Future<void> _simulateSendMessage(
      String phoneNumber, String message) async {
    try {
      if (await _isPermissionGranted()) {
        SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: phoneNumber,
          message: message,
          simSlot: 1,
        );

        if (result == SmsStatus.sent) {
          print('Message sent successfully');
        } else {
          print('Failed to send message');
        }
      } else {
        print('SMS permission not granted');
      }
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }

  static Future<bool> _isPermissionGranted() async {
    return await Permission.sms.status.isGranted;
  }

  static Future<List<String>> fetchAllUserContacts() async {
    try {
      // Reference to the "Users" collection in Firestore
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

      // Fetch all documents from the "Users" collection
      QuerySnapshot querySnapshot = await usersCollection.get();

      // Extract phone numbers from each document
      List<String> contacts = [];
      querySnapshot.docs.forEach((doc) {
        // Assuming phone numbers are stored under the field 'ContactNo'
        String phoneNumber = doc['ContactNo'];
        contacts.add(phoneNumber);
      });

      return contacts;
    } catch (e) {
      print('Error fetching user contacts: $e');
      return [];
    }
  }
}
