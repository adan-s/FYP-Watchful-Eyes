import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _database = FirebaseFirestore.instance;

  createUser(usermodel user) async {
    try {
      await _database.collection("Users").add(user.toJson());
      Get.snackbar(
        "Success",
        "Account has been Created",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } catch (error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong...Try Again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      print(error.toString());
    }
  }

  Future<usermodel> getUserDetails(String email) async {
    try {
      final snapshot = await _database
          .collection("Users")
          .where('Email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userData = usermodel.fromSnapshot(snapshot.docs.first);
        return userData;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching user details: $e");
      throw e;
    }
  }

  Future<bool> isUsernameUnique(String username) async {
    try {
      // Implement the logic to check if the username is unique in your database
      final snapshot = await _database
          .collection("Users")
          .where('username', isEqualTo: username)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      print("Error checking username uniqueness: $e");
      throw e;
    }
  }

  Future<bool> isContactNoUnique(String contactNo) async {
    try {
      // Implement the logic to check if the contact number is unique in your database
      final snapshot = await _database
          .collection("Users")
          .where('contactNo', isEqualTo: contactNo)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      print("Error checking contact number uniqueness: $e");
      throw e;
    }
  }

  Future<void> updateUserData({
    required String username,
    required String contactNo,
    // Add more fields as needed
  }) async {
    try {
      // Implement logic to update user data in Firestore
      // For example, you might use Firebase Firestore here
      // Replace the following lines with your actual implementation

      // You need to get the user's email from the authentication system
      final email = ''; // Replace with actual email retrieval logic

      // Check if the updated username is unique
      final isUniqueUsername = await isUsernameUnique(username);
      if (!isUniqueUsername) {
        Get.snackbar("Error", "Username is already taken");
        return;
      }

      // Check if the updated contact number is unique
      final isUniqueContactNo = await isContactNoUnique(contactNo);
      if (!isUniqueContactNo) {
        Get.snackbar("Error", "Contact number is already taken");
        return;
      }

      // Update user data if both username and contact number are unique
      await _database.collection('Users').doc(email).update({
        'username': username,
        'contactNo': contactNo,
        // Add more fields as needed
      });

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      print('Error updating user data: $e');
      Get.snackbar("Error", "Failed to update profile");
    }
  }
}
