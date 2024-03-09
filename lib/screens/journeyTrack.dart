import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../authentication/EmergencycontactsRepo.dart';
import '../authentication/authentication_repo.dart';

class JourneyTracker extends StatefulWidget {
  @override
  _JourneyTrackerState createState() => _JourneyTrackerState();
}

class _JourneyTrackerState extends State<JourneyTracker> {
  late LocationData? currentLocation;
  Timer? alarmTimer;
  Duration customAlarmDuration = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _startJourneyTracking();
  }

  @override
  void dispose() {
    super.dispose();
    alarmTimer?.cancel(); // Cancel timer when disposing the widget
  }

  Future<void> _startJourneyTracking() async {
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

  void _setAlarm(Duration duration, String reason) {
    alarmTimer = Timer(duration, () {
      _sendEmergencyNotification();
    });
    print('Alarm set for $reason after ${duration.inMinutes} minutes');
  }

  void _turnOffAlarm() {
    if (alarmTimer != null && alarmTimer!.isActive) {
      alarmTimer!.cancel(); // Turn off the alarm timer
      print('Alarm turned off');
    } else {
      print('No active alarm to turn off');
    }
  }

  Future<void> _sendEmergencyNotification() async {
    try {
      User? user = AuthenticationRepository.instance.firebaseUser.value;
      if (user != null) {
        var userEmail = user.email;
        print('User Email: $userEmail');

        var contacts = await EmergencycontactsRepo().getEmergencyContacts(userEmail!);

        var locationLink =
            'https://maps.google.com/?q=${currentLocation!.latitude},${currentLocation!.longitude}';
        var message = 'Emergency! User has not turned off the alarm. Current location: $locationLink';

        // Send messages to emergency contacts
        for (var contact in contacts) {
          await _sendSMS(contact.phoneNumber, message);
        }
      }
    } catch (e) {
      print('Error sending emergency message: $e');
    }
  }

  Future<bool> _isPermissionGranted() async {
    return await Permission.sms.status.isGranted;
  }

  Future<void> _sendSMS(String phoneNumber, String message) async {
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
  Future<void> _showCustomAlarmDialog() async {
    TimeOfDay? selectedTime;

    final newDuration = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Custom Alarm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                },
                child: Text(
                  selectedTime != null
                      ? 'Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}'
                      : 'Select Time',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedTime != null) {
                    final now = DateTime.now();
                    final selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    final difference = selectedDateTime.difference(now);
                    final newDuration = Duration(
                      hours: difference.inHours,
                      minutes: difference.inMinutes.remainder(60),
                    );

                    Navigator.of(context).pop(newDuration);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a time.'),
                      ),
                    );
                  }
                },
                child: Text('Set'),
              ),
            ],
          ),
        );
      },
    );

    if (newDuration != null) {
      setState(() {
        customAlarmDuration = newDuration;
      });
      _turnOffAlarm(); // Turn off existing alarm
      _setAlarm(customAlarmDuration, 'custom duration');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tracking user\'s journey...',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _turnOffAlarm();
              },
              child: Text('Turn off Alarm'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showCustomAlarmDialog,
              child: Text('Set Custom Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
