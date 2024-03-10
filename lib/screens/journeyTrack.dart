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
  late String selectedReason = ''; // Add selectedReason variable
  late TextEditingController otherReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startJourneyTracking();
  }

  @override
  void dispose() {
    super.dispose();
    alarmTimer?.cancel(); // Cancel timer when disposing the widget
    otherReasonController.dispose();
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
      _sendEmergencyNotification(reason); // Pass the reason to the method
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

  Future<void> _sendEmergencyNotification(String reason) async {
    try {
      User? user = AuthenticationRepository.instance.firebaseUser.value;
      if (user != null) {
        var userEmail = user.email;
        print('User Email: $userEmail');

        var contacts = await EmergencycontactsRepo().getEmergencyContacts(
            userEmail!);

        var locationLink =
            'https://maps.google.com/?q=${currentLocation!
            .latitude},${currentLocation!.longitude}';
        var message = 'Emergency! User has not turned off the alarm. Current location: $locationLink. Reason: $reason';

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

  void _showCustomAlarmDialog() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      final difference = selectedDateTime.difference(now);
      final newDuration = Duration(
        hours: difference.inHours,
        minutes: difference.inMinutes.remainder(60),
      );
      setState(() {
        customAlarmDuration = newDuration;
      });

      // Show reason selection dialog
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Select or Write Reason'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReasonButton('Walking Alone'),
                _buildReasonButton('Going for a Run'),
                _buildReasonButton('Taking Transportation'),
                _buildReasonButton('Hiking'),
                _buildReasonButton('Write My Own'),
              ],
            ),
          );
        },
      ).then((selected) {
        if (selected != null) {
          if (selected == 'Write My Own') {
            _showWriteReasonDialog();
          } else {
            _turnOffAlarm();
            _setAlarm(customAlarmDuration, selected);
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please select a time'),),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF769DC9), // Set Scaffold background color
      appBar: AppBar(
        title: Text(
          'Journey Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF769DC9), // Set app bar background color
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/safety.jpg',
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Container(
                width: 300,
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(text: selectedReason),
                  decoration: InputDecoration(
                    hintText: 'Reason',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Select Reason'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildReasonButton('Walking Alone'),
                              _buildReasonButton('Going for a Run'),
                              _buildReasonButton('Taking Transportation'),
                              _buildReasonButton('Hiking'),
                              _buildReasonButton('Write My Own'),
                            ],
                          ),
                        );
                      },
                    ).then((selected) {
                      if (selected != null) {
                        setState(() {
                          if (selected == 'Write My Own') {
                            _showWriteReasonDialog();
                          } else {
                            selectedReason = selected;
                          }
                        });
                      }
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.only(left: 20.5),
              child: Container(
                width: 300,
                padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onTap: _showCustomAlarmDialog,

                    child: Text(
                      'Set Alarm',
                      style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }


  void _showWriteReasonDialog() {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Write Your Own Reason'),
          content: TextField(
            controller: reasonController,
            decoration: InputDecoration(
              hintText: 'Enter your reason',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (reasonController.text.isNotEmpty) {
                  setState(() {
                    selectedReason = reasonController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }



  Widget _buildReasonButton(String reason){
    return TextButton(
      onPressed:(){
        Navigator.of(context).pop(reason);
      },
      child: Text(
        reason,
        style: TextStyle(color: Colors.white),
      ),
    );
  }


}