import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fyp/screens/user-panel.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  RxString errorMessage = ''.obs;

  // Callback to handle navigation
  late VoidCallback onLoginSuccess;

  // Setter for the callback
  void setOnLoginSuccess(VoidCallback callback) {
    onLoginSuccess = callback;
  }

  Future<void> login() async {
    try {
      if (kIsWeb && email.text.trim() == 'admin123@gmail.com' && password.text.trim() == 'admin123') {
        // Admin login successful on the web
        onLoginSuccess(); // Call the callback
        Get.snackbar(
          'Login Successful',
          'Welcome, Admin!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
        );
      } else {
        // For regular users or non-web admin login, perform Firebase authentication
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // Check if the user is a regular user (you can replace this condition with your user identification logic)
        if (userCredential.user?.uid != null && userCredential.user?.uid != 'admin_uid') {
          // Regular user login successful
          Get.offAll(() => UserPanel());
          Get.snackbar(
            'Login Successful',
            'Welcome, User!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey,
          );
        } else {
          // Handle other cases if needed
        }
      }
    } catch (e) {
      // Handle login errors
      print('Login error: $e');

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage.value = 'Incorrect email';
        } else if (e.code == 'wrong-password') {
          errorMessage.value = 'Incorrect password';
        } else {
          errorMessage.value = 'Login failed. Please try again.';
        }
      } else {
        errorMessage.value = 'An unexpected error occurred.';
      }
      rethrow;
    }
  }
}
