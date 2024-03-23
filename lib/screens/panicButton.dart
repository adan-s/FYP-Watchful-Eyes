import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volume_watcher/volume_watcher.dart';
import '../authentication/EmergencycontactsRepo.dart';
import '../authentication/authentication_repo.dart';

class PanicButton extends StatefulWidget {
  @override
  _PanicButtonState createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> {
  LocationData? currentLocation;
  int volumeUpCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panic Button'),
      ),
      body: VolumeWatcher(
        onVolumeChangeListener: (volume) {
          if (volume >= 1 || volume == 0 ) { // Volume up button pressed
            volumeUpCount++;
            if (volumeUpCount == 3) {
              _handlePanicButtonPress();
              volumeUpCount = 0; // Reset volume up count
            }
          }
        },
        child: Center(
          child: Text(
            'Press Volume Up three times to trigger panic button.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<bool> _isLocationPermissionGranted() async {
    return await Permission.location.status.isGranted;
  }

  Future<void> _getCurrentLocation() async {
    try {
      var location = Location();
      LocationData userLocation = await location.getLocation();
      print("User Location: $userLocation");
      setState(() {
        currentLocation = userLocation;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _sendEmergencyMessage() async {
    try {
      User? user = AuthenticationRepository.instance.firebaseUser.value;
      if (user != null) {
        var userEmail = user.email;
        print('User Email: $userEmail');

        var contacts =
        await EmergencycontactsRepo().getEmergencyContacts(userEmail!);

        var locationLink =
            'https://maps.google.com/?q=${currentLocation!.latitude},${currentLocation!.longitude}';
        var message =
            'Emergency! I need help. My current location is: $locationLink';

        // Send messages to emergency contacts
        for (var contact in contacts) {
          await _simulateSendMessage(contact.phoneNumber, message);
        }
      }
    } catch (e) {
      print('Error sending emergency message: $e');
    }
  }

  Future<void> _simulateSendMessage(
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
          Fluttertoast.showToast(msg: 'Message sent successfully');
        } else {
          print('Failed to send message');
          Fluttertoast.showToast(msg: 'Failed to send message');
        }
      } else {
        Fluttertoast.showToast(msg: 'SMS permission not granted');
      }
    } catch (e) {
      print('Error sending SMS: $e');
      Fluttertoast.showToast(msg: 'Error sending SMS: $e');
    }
  }

  Future<bool> _isPermissionGranted() async {
    return await Permission.sms.status.isGranted;
  }

  void _handlePanicButtonPress() async {
    // Check if location permission is granted
    if (await _isLocationPermissionGranted()) {
      try {
        // Get the current location
        await _getCurrentLocation();

        // Send emergency message
        await _sendEmergencyMessage();
      } catch (e) {
        print("Error handling panic button press: $e");
      }
    } else {
      print("Location permission not granted");
      Fluttertoast.showToast(msg: 'Location permission not granted');
    }
  }
}
