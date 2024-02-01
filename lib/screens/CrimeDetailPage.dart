import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CrimeDetailPage extends StatelessWidget {
  final Map<String, dynamic> crimeData;

  CrimeDetailPage({Key? key, required this.crimeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF769DC9), Color(0xFF769DC9)],
            ),
          ),
        ),
        title: Text(
          'Crime Details',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'outfit'),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full Name: ${crimeData['fullName']}'),
              Text('Phone Number: ${crimeData['phoneNumber']}'),
              Text('Date: ${crimeData['date']}'),
              Text('Time: ${crimeData['time']}'),
              Text('Crime Type: ${crimeData['crimeType']}'),
              Text('Description: ${crimeData['description']}'),
              SizedBox(height: 16),
              Text(
                'Attachments:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildImageWidgets(crimeData['attachments']),
              SizedBox(height: 36),
              if (crimeData['voiceMessageUrl'] != null && crimeData['voiceMessageUrl'] != "")
                ElevatedButton(
                  onPressed: () {
                    downloadRecording(crimeData['voiceMessageUrl']);
                  },
                  child: Text('Download Recording'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidgets(dynamic attachments) {
    if (attachments == null || attachments.isEmpty) {
      return Text('No attachments available.');
    }

    if (attachments is String) {
      List<String> attachmentList = attachments.split(',');

      return Column(
        children: attachmentList
            .map((imageUrl) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            imageUrl.trim(),
            height: 250,
            width: 250,
            fit: BoxFit.cover,
          ),
        ))
            .toList(),
      );
    } else if (attachments is List) {
      return Column(
        children: attachments
            .map((imageUrl) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            imageUrl,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
        ))
            .toList(),
      );
    } else {
      return Text('Invalid attachment format.');
    }
  }

  void downloadRecording(String? voiceMessageUrl) async {
    if (voiceMessageUrl == null) {
      print('No recording available.');
      return;
    }
    try {
      await launchUrlString(voiceMessageUrl);
    } catch (_) {
      try {
        await Process.run('open', [voiceMessageUrl]);
      } catch (error) {
        print('Error launching the recording download link: $error');
      }
    }
  }
}
