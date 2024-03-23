import 'dart:async';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'map.dart';

class NotificationService {
  final LatLng? userLocation;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC1256b2c87ddd7e33a5b5b3e21830e699',
    authToken: '548867947d0c7e45fe181cfea229362e',
    twilioNumber: '+14155238886',
  );

  NotificationService({required this.userLocation});

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    await twilioFlutter.sendWhatsApp(
      toNumber: phoneNumber,
      messageBody: message,
    );
  }

  // Function to calculate the distance between two coordinates using Haversine formula
  double calculateDistance(LatLng point1, LatLng point2) {
    const int radiusOfEarth = 6371;

    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarth * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void sendNotifications() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Set<String> recipients = {}; ;
      String crimeType = "null";
      String fullName = "null";
      bool isAnonymous = false;
      String date = "null";
      String time = "null";
      QuerySnapshot querySnapshot =
      await firestore.collection('crimeData').get();

      List<CrimeData?> crimeDataList = querySnapshot.docs
          .map((doc) {
        Map<String, dynamic> crimeDataMap =
        doc.data() as Map<String, dynamic>;

        if (crimeDataMap.containsKey('location') &&
            crimeDataMap['location'] != null) {
          double latitude = crimeDataMap['location']['latitude'];
          double longitude = crimeDataMap['location']['longitude'];

          String phoneNumber = crimeDataMap['phoneNumber'];
          // Remove first 0 from phoneNumber
          String phoneNumber1 = '+92${phoneNumber.substring(1)}';
          LatLng crimeLatLng = LatLng(latitude, longitude);
          print(phoneNumber1);

          print(crimeDataMap['location']);
          print(userLocation);


          if (crimeDataMap.containsKey('location') && crimeDataMap['location'] != null) {
            double crimeLatitude = crimeDataMap['location']['latitude'];
            double crimeLongitude = crimeDataMap['location']['longitude'];

            // Compare latitude and longitude values
            if (userLocation != null &&
                userLocation!.latitude == crimeLatitude &&
                userLocation!.longitude == crimeLongitude) {
              crimeType = crimeDataMap['crimeType'];
              fullName = crimeDataMap['fullName'];
              isAnonymous = crimeDataMap['isAnonymous'] ?? false;
              date = crimeDataMap['date'];
              time = crimeDataMap['time'];
            }
          }


          double distance = calculateDistance(userLocation!, crimeLatLng);
          if (distance <= 2) {
            recipients.add(phoneNumber1);
          }
        } else {
          print("Warning: 'location' map is missing or null in crime data");
          return null;
        }
      })
          .where((crimeData) => crimeData != null)
          .toList();

      String message = 'A new crime is registered in your area:\n'
          'Date: $date\n'
          'Time: $time\n'
          'Crime Type: $crimeType\n'
          'Location: https://www.google.com/maps?q=${userLocation!.latitude},${userLocation!.longitude}\n';

      if (!isAnonymous) {
        message += 'Name: $fullName\n';
      }

      recipients.forEach((phoneNumber) async {
        try {
          await sendWhatsAppMessage(phoneNumber, message);
          print('WhatsApp message sent successfully to $phoneNumber');
        } catch (e) {
          print('Failed to send WhatsApp message to $phoneNumber: $e');
        }
      });
    } catch (e) {
      print("Error fetching all crime data: $e");
    }
  }
}