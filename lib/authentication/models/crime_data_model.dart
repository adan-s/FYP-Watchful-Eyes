import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeDataModel {
  final String? id;
  final String fullName;
  final String phoneNumber;
  final String date;
  final String time;
  final String crimeType;
  final String attachments;
  final String description;
  final bool isAnonymous;
  final String voiceMessageUrl;
  final String location;

  CrimeDataModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.crimeType,
    required this.attachments,
    required this.description,
    required this.isAnonymous,
    required this.voiceMessageUrl,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'crimeType': crimeType,
      'attachments': attachments,
      'description': description,
      'isAnonymous': isAnonymous,
      'voiceMessageUrl': voiceMessageUrl,
      'location': location,
    };
  }

  factory CrimeDataModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CrimeDataModel(
      id: document.id,
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      date: data['date'],
      time: data['time'],
      crimeType: data['crimeType'],
      attachments: data['attachements'],
      description: data['description'],
      isAnonymous: data['isAnonymous'],
      voiceMessageUrl: data['voiceMessageUrl'],
      location: data['location'],
    );
  }
}