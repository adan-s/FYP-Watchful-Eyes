import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  RxString errorMessage = ''.obs;
  Future<void> login() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // You can access the user data using userCredential.user
      print('Login successful: ${userCredential.user?.uid}');
    } catch (e) {
      // Handle login errors
      print('Login error: $e');

      if (e is FirebaseAuthException) {
        // Firebase authentication specific errors
        if (e.code == 'user-not-found') {
          errorMessage.value = 'Incorrect email';
        } else if (e.code == 'wrong-password') {
          errorMessage.value = 'Incorrect password';
        } else {
          errorMessage.value = 'Login failed. Please try again.';
        }
      } else {
        // Other types of errors
        errorMessage.value = 'An unexpected error occurred.';
      }
      rethrow;
    }
  }
}
