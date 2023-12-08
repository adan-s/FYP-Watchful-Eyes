import 'package:fyp/authentication/authentication_repo.dart';
import 'package:fyp/user_repository.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

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
      final isUnique = await _userRepo.isUsernameUnique(username);
      return isUnique;
    } catch (e) {
      print("Error checking username uniqueness: $e");
      return false;
    }
  }

  Future<bool> isContactNoUnique(String contactNo) async {
    try {
      // Check if the contact number already exists in the database
      final isUnique = await _userRepo.isContactNoUnique(contactNo);
      return isUnique;
    } catch (e) {
      print("Error checking contact number uniqueness: $e");
      return false;
    }
  }

  Future<void> updateUserData({
    required String username,
    required String contactNo,
    // Add more fields as needed
  }) async {
    try {
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
      await _userRepo.updateUserData(
        username: username,
        contactNo: contactNo,
        // Add more fields as needed
      );
      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      print("Error updating user data: $e");
      Get.snackbar("Error", "Failed to update profile");
    }
  }
}
