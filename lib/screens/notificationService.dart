import 'dart:async';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'package:firebase_database/firebase_database.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class NotificationService {
  final String userLocation;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC3e3faf28b6fa635ac6ba7ec4cf4455b7',
    authToken: '4941bfec7ace819cceb2cb287ccd6849',
    twilioNumber: '+12318191988',
  );

  NotificationService({required this.userLocation});

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    await twilioFlutter.sendWhatsApp(
      toNumber: phoneNumber,
      messageBody: message,
    );
  }

  // Function to calculate the distance between two coordinates using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in kilometers
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = R * c; // Distance in kilometers
    return d * 1000; // Distance in meters
  }

  Future<void> sendNotifications() async {
    // Fetch crime data from Firebase
    _database.reference().child('crimeData').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic>? crimeData = snapshot.value as Map<dynamic, dynamic>?;

      if (crimeData != null) {
        List<String> recipients = [];

        // Iterate through each crime record
        crimeData.forEach((key, value) {
          // Extract crime details
          String crimeType = value['crimeType'];
          String location = value['location'];
          String date = value['date'];
          String time = value['time'];
          String description = value['description'];
          String phoneNumber = value['phoneNumber'];

          // Remove first 0 from phoneNumber
          phoneNumber = '+92${phoneNumber.substring(1)}';

          // Calculate the distance between user's location and crime location
          // For simplicity, I'm assuming userLocation and location are in the format "lat, lon"
          List<String> userCoordinates = userLocation.split(', ');
          List<String> crimeCoordinates = location.split(', ');

          double userLat = double.parse(userCoordinates[0]);
          double userLon = double.parse(userCoordinates[1]);
          double crimeLat = double.parse(crimeCoordinates[0]);
          double crimeLon = double.parse(crimeCoordinates[1]);

          double distance = calculateDistance(userLat, userLon, crimeLat, crimeLon);

          // Check if the distance is within 2m radius
          if (distance <= 2) {
            // Add phoneNumber to recipients list
            recipients.add(phoneNumber);
          }
        });

        // Send WhatsApp message to all recipients
        recipients.forEach((phoneNumber) {
          // Compose the WhatsApp message
          String message = 'A new crime was registered in your area.';

          // Send WhatsApp message
          sendWhatsAppMessage(phoneNumber, message);
        });
      }
    } as FutureOr Function(DatabaseEvent value));
  }
}
