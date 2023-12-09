import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/authentication/authentication_repo.dart';
import 'package:fyp/user_repository.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  // Add this line to reference your Firestore instance
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
    required String username,
    required String contactNo,
    // Add more fields as needed
  }) async {
    try {
      if (email.isEmpty) {
        Get.snackbar("Error", "User email is empty");
        return;
      }

      // Try to update the document
      await _database.collection('Users').doc(email).update({
        'username': username,
        'contactNo': contactNo,
        // Add more fields as needed
      });

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      // If the document is not found, create it and then update
      if (e is FirebaseException && e.code == 'not-found') {
        await _database.collection('Users').doc(email).set({
          'username': username,
          'contactNo': contactNo,
          // Add more fields as needed
        });

        Get.snackbar("Success", "Profile created and updated successfully");
      } else {
        print('Error updating user data: $e');
        Get.snackbar("Error", "Failed to update profile");
      }
    }
  }
}
