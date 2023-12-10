import 'package:cloud_firestore/cloud_firestore.dart';
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
      Get.snackbar("Error", "Login to Continue");
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
        Get.snackbar("Error", "User email is empty");
        return;
      }

      // Check if the document with the specified email exists
      var userDoc = await _database.collection('Users').where('Email', isEqualTo: email).get();
      if (userDoc.docs.isEmpty) {
        Get.snackbar("Error", "User with email $email not found");
        return;
      }

      // Update the document
      await _database.collection('Users').doc(userDoc.docs.first.id).update({
        'UserName': UserName,
        'ContactNo': ContactNo,

      });

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      print('Error updating user data: $e');
      Get.snackbar("Error", "Failed to update profile");
    }
  }

}
