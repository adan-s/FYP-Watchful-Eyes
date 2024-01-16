import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeDataModel {
  final String? id;
  final String fullName;
  final String phoneNumber;
  final String date;
  final String time;
  final String crimeType;
  final String attachment;
  final String description;
  final bool isAnonymous;

  CrimeDataModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.crimeType,
    required this.attachment,
    required this.description,
    required this.isAnonymous,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'crimeType': crimeType,
      'attachment': attachment,
      'description': description,
      'isAnonymous': isAnonymous,
    };
  }

  factory CrimeDataModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CrimeDataModel(
      id: document.id,
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      date: data['date'],
      time: data['time'],
      crimeType: data['crimeType'],
      attachment: data['attachment'],
      description: data['description'],
      isAnonymous: data['isAnonymous'],
    );
  }
}
