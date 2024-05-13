import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volume_watcher/volume_watcher.dart';
import '../authentication/EmergencycontactsRepo.dart';
import '../authentication/authentication_repo.dart';
import 'blogs.dart';

class PanicButton extends StatefulWidget {
  @override
  _PanicButtonState createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> {
  LocationData? currentLocation;
  int volumeUpCount = 0;
  double _previousVolume = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF769DC9),
          title: Text(
            'Panic Button',
            style: TextStyle(color: Colors.white), // White color for the text
          ),
          centerTitle: true,
          leading: ResponsiveAppBarActions(),
        ),
        body: VolumeWatcher(
          onVolumeChangeListener: (volume) {
            if (volume >= _previousVolume) {
              volumeUpCount++;
              if (volumeUpCount == 3) {
                _handlePanicButtonPress();
                volumeUpCount = 0;
              }
            }
            _previousVolume = volume;
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF769DC9),
                  Color(0xFF769DC9),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20), // Adjusted padding
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: GestureDetector(
                      onTap: _handlePanicButtonPress,
                      child: Container(
                        width: 250,
                        height: 250,
                        child: Image.asset(
                          'assets/panic button.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text(
                    'In case of emergency, press the volume button three times to send the message to your emergency contacts along with your current location.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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

  Future<void> _simulateSendMessage(String phoneNumber, String message) async {
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
