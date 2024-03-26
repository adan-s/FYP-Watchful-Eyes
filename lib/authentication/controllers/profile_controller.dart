import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/authentication/authentication_repo.dart';
import 'package:fyp/user_repository.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<usermodel> getUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return await _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to Continue",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,);
      throw Exception("User not logged in");
    }
  }

  Future<bool> isUsernameUnique(String username) async {
    try {
      // Check if the username already exists in the database
      return await _userRepo.isUsernameUnique(username);
    } catch (e) {
      print("Error checking username uniqueness: $e");
      return false;
    }
  }

  Future<bool> isContactNoUnique(String contactNo) async {
    try {
      // Check if the contact number already exists in the database
      return await _userRepo.isContactNoUnique(contactNo);
    } catch (e) {
      print("Error checking contact number uniqueness: $e");
      return false;
    }
  }

  Future<void> updateUserData({
    required String email,
    required String UserName,
    required String ContactNo,

  }) async {
    try {
      if (email.isEmpty) {
        Get.snackbar(
          "Error",
          "Email is Empty!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // Check if the document with the specified email exists
      var userDoc = await _database.collection('Users').where('Email', isEqualTo: email).get();
      if (userDoc.docs.isEmpty) {
        Get.snackbar("Error", "User with email $email not found");
        return;
      }

      if (UserName.isEmpty) {
        Get.snackbar(
          "Error",
          "Username is Empty!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      if (ContactNo.isEmpty) {
        Get.snackbar(
          "Error",
          "Contact No is Empty!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }


      // Update the document
      await _database.collection('Users').doc(userDoc.docs.first.id).update({
        'UserName': UserName,
        'ContactNo': ContactNo,

      });

      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      print('Error updating user data: $e');
      Get.snackbar("Error", "Failed to update profile");
    }
  }

  Future<void> updateProfileImage({required String email, required String imageUrl}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.update({'profileImage': imageUrl});
        });

        print('Profile image updated successfully');
        Get.snackbar(
          "Success",
          "Profile image updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print('User with email $email not found');
      }
    } catch (e) {
      print('Error updating profile image: $e');
      Get.snackbar(
        "Error",
        "Error updating image",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      // Handle the error as needed
    }
  }

}
