import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/crime_data_model.dart';

class CrimeRegistrationController extends GetxController {
  static CrimeRegistrationController get instance =>
      Get.find<CrimeRegistrationController>();

  final CollectionReference crimeCollection =
      FirebaseFirestore.instance.collection('crimeData');

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final selectedDateController = TextEditingController();
  final selectedTimeController = TextEditingController();
  RxString crimeType = ''.obs;
  RxString attachments = ''.obs;
  final descriptionController = TextEditingController();
  RxBool isAnonymous = false.obs;
  RxString voiceMessageUrl = ''.obs;

  Future<void> submitCrimeReport() async {
    try {
      // Create a CrimeDataModel instance with the collected data
      CrimeDataModel crimeData = CrimeDataModel(
        fullName: fullNameController.text,
        phoneNumber: phoneNumberController.text,
        date: selectedDateController.text,
        time: selectedTimeController.text,
        crimeType: crimeType.value,
        attachments: attachments.value,
        description: descriptionController.text,
        isAnonymous: isAnonymous.value,
        voiceMessageUrl: voiceMessageUrl.value,
      );

      // Convert CrimeDataModel to a Map
      Map<String, dynamic> crimeMap = crimeData.toMap();

      // Add the crime data to Firestore
      await crimeCollection.add(crimeMap);

      Get.snackbar(
        'Crime Report Submitted',
        'The crime report has been submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form fields after submission
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
    crimeType.value = '';
    attachments.value = '';
    descriptionController.clear();
    isAnonymous.value = false;
    voiceMessageUrl.value = '';
  }
}
