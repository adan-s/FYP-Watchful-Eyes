

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CrimeRegistrationController extends GetxController {
  static CrimeRegistrationController get instance =>
      Get.find<CrimeRegistrationController>();

  final CollectionReference crimeCollection =
  FirebaseFirestore.instance.collection('crimeData');

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final selectedDateController = TextEditingController();
  final selectedTimeController = TextEditingController();
  final crimeTypeController = TextEditingController();
  final attachmentController = TextEditingController();
  final descriptionController = TextEditingController();
  final isAnonymousController = TextEditingController();

  Future<void> submitCrimeReport() async {
    try {
      await crimeCollection.add({
        'fullName': fullNameController.text,
        'phoneNumber': phoneNumberController.text,
        'date': selectedDateController.text,
        'time': selectedTimeController.text,
        'crimeType': crimeTypeController.text,
        'attachment': attachmentController.text,
        'description': descriptionController.text,
        'isAnonymous': isAnonymousController.text == 'true',
      });

      Get.snackbar(
        'Crime Report Submitted',
        'The crime report has been submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFormFields();
    } catch (e) {
      print('Error submitting crime report: $e');

      Get.snackbar(
        'Submission Failed',
        'An error occurred during the submission. Please try again later.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      rethrow;
    }
  }


  void clearFormFields() {
    fullNameController.clear();
    phoneNumberController.clear();
    selectedDateController.clear();
    selectedTimeController.clear();
    crimeTypeController.clear();
    attachmentController.clear();
    descriptionController.clear();
    isAnonymousController.clear();
  }
}
