import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sms/flutter_sms.dart';

// Twilio API credentials
Future<void> main() async {
  // Create and start the HTTP server
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('Server running on port 8080');

  await for (var request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) async {
  if (request.method == 'POST' && request.uri.path == '/sendNotification') {
    try {
      // Extract crime data from request body
      final jsonString = await utf8.decoder.bind(request).join();
      final data = json.decode(jsonString) as Map<String, dynamic>;

      final crimeType = data['crimeType'] as String;
      final description = data['description'] as String;
      final location = data['location'] as String;

      // Fetch all user phone numbers from Firestore
      final List<String> userPhoneNumbers = await fetchAllUserPhoneNumbers();

      // Construct notification message
      final notification = 'New Crime Reported: $crimeType - $description at $location.';

      // Send notification to each user's phone number
      for (final phoneNumber in userPhoneNumbers) {
        await sendNotification(phoneNumber, notification);
      }

      // Send a success response
      request.response.statusCode = HttpStatus.ok;
      request.response.write('Notification sent successfully');
    } catch (e) {
      print('Error handling request: $e');
      // Send an error response
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('Error handling request: $e');
    }
  } else {
    // Send a 404 response for other paths or methods
    request.response.statusCode = HttpStatus.notFound;
    request.response.write('Not found');
  }
  await request.response.close();
}

Future<List<String>> fetchAllUserPhoneNumbers() async {
  try {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the "Users" collection to get all documents
    final QuerySnapshot querySnapshot = await firestore.collection('Users').get();

    // Extract user phone numbers from documents
    final List<String> userPhoneNumbers = querySnapshot.docs
        .map((doc) => doc['ContactNo'] as String?) // Accessing 'ContactNo' directly from document
        .where((phoneNumber) => phoneNumber != null)
        .map((phoneNumber) => phoneNumber!)
        .toList();

    return userPhoneNumbers;
  } catch (e) {
    print('Error fetching user phone numbers: $e');
    return []; // Return an empty list in case of an error
  }
}

Future<void> sendNotification(String phoneNumber, String notification) async {
  try {

    // Sending SMS using flutter_sms package
    String message = '$notification';
    List<String> recipients = ['$phoneNumber'];
    String result = await sendSMS(message: message, recipients: recipients);

    // Checking if the SMS was sent successfully
    if (result == "SMS Sent Successfully") {
      print('Notification sent successfully to phone number: $phoneNumber');
    } else {
      print('Failed to send notification to phone number: $phoneNumber');
      print('Error: $result');
    }
  } catch (e) {
    print('Error sending notification to phone number: $phoneNumber');
    print('Error: $e');
  }
}
