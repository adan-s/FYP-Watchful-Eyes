import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../authentication/EmergencycontactsRepo.dart';
import '../authentication/authentication_repo.dart';
import 'blogs.dart';

class JourneyTracker extends StatefulWidget {
  @override
  _JourneyTrackerState createState() => _JourneyTrackerState();
}

class _JourneyTrackerState extends State<JourneyTracker> {
  late LocationData? currentLocation;
  Timer? alarmTimer;
  Duration customAlarmDuration = Duration(minutes: 30);
  late String selectedReason = '';
  late TextEditingController otherReasonController = TextEditingController();
  late Duration remainingTime = Duration();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    alarmTimer?.cancel();
    otherReasonController.dispose();
  }

  Future<void> _setAlarm(Duration duration, String reason) async {
    remainingTime = duration;
    alarmTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime -= Duration(seconds: 1);
        } else {
          timer.cancel();
          _sendEmergencyNotification(reason);
        }
      });
    });
  }

  Future<void> _sendEmergencyNotification(String reason) async {
    try {
      // Check SMS permission before sending
      if (await _isPermissionGranted()) {
        User? user = AuthenticationRepository.instance.firebaseUser.value;
        if (user != null) {
          var userEmail = user.email;
          print('User Email: $userEmail');

          // Get emergency contacts
          var contacts =
              await EmergencycontactsRepo().getEmergencyContacts(userEmail!);

          // Check if current location is available
          if (currentLocation != null) {
            var locationLink =
                'https://maps.google.com/?q=${currentLocation!.latitude},${currentLocation!.longitude}';
            var message =
                'Emergency! User has not turned off the alarm. Current location: $locationLink. Reason: $reason';

            // Send messages to emergency contacts
            for (var contact in contacts) {
              await _sendSMS(contact.phoneNumber, message);
            }
          } else {
            print('Current location is null');
            Get.snackbar(
              "Error! ",
              "Failed to fetch location.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          print('User is not authenticated');
          Get.snackbar(
            "Error! ",
            "User is not authenticated.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        print('SMS permission not granted');
        Get.snackbar(
          "Error! ",
          "SMS permission not granted.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error sending emergency message: $e');
      Get.snackbar(
        "Error! ",
        "Can't send emergency message.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> _isPermissionGranted() async {
    return await Permission.sms.status.isGranted;
  }

  Future<void> _sendSMS(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: 1,
    );

    if (result == SmsStatus.sent) {
      print('Message sent successfully');

      Get.snackbar(
        "Alert!",
        "Message sent successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    } else {
      print('Failed to send message');
      Get.snackbar(
        "Alert!",
        "Message not sent.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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

      // Show reason selection dialog only if the reason is not set
      if (selectedReason.isEmpty) {
        String? reason = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
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
        );

        if (reason != null) {
          if (reason == 'Write My Own') {
            _showWriteReasonDialog();
          } else {
            selectedReason = reason;
          }
        }
      }

      // Set the alarm if the reason is already set
      if (selectedReason.isNotEmpty) {
        _setAlarm(customAlarmDuration, selectedReason);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please select a time'),
        ),
      );
    }
  }

  void _stopAlarm() {
    if (alarmTimer != null) {
      alarmTimer!.cancel();
      setState(() {
        remainingTime = Duration();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF769DC9),
        appBar: AppBar(
          title: Text(
            'Journey Tracker',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF769DC9),
          elevation: 0,
          centerTitle: true,
          leading: ResponsiveAppBarActions(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/safety.jpg',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Select Reason'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 8),
                        child: Icon(Icons.info_outline, color: Colors.black),
                      ),
                      Text(
                        selectedReason.isEmpty
                            ? 'Select Reason'
                            : selectedReason,
                        // Display selected reason if available
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _showCustomAlarmDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 8),
                        child: Icon(
                          Icons.alarm,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Set Alarm',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Remaining Time: ${_formatDuration(remainingTime)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    // Adjust the padding as needed
                    child: ElevatedButton(
                      onPressed: _stopAlarm,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.alarm_off, color: Colors.black),
                          // Icon on the left side
                          SizedBox(width: 4),
                          // Adjust the width as needed
                          Text(
                            'Stop Alarm',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
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

  void _showWriteReasonDialog() {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
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

  Widget _buildReasonButton(String reason) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(reason);
      },
      child: Row(
        children: [
          Icon(Icons.circle_outlined, color: Colors.black, size: 16),
          SizedBox(width: 8), // Add some space between bullet point and text
          Text(
            reason,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
