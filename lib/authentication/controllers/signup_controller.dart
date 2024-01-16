import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../user_repository.dart';
import '../authentication_repo.dart';
import '../models/user_model.dart';


class Signupcontroller extends GetxController {
  static Signupcontroller get instance => Get.find();



  final username = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final contactNo = TextEditingController();
  final dob = TextEditingController();
  final cnic = TextEditingController();
  final gender = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final user_repositoryy = Get.put(UserRepository());

  Future<void> RegisterUser(String email, String password, usermodel user) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? currentUser = FirebaseAuth.instance.currentUser;
      await currentUser?.sendEmailVerification();

      // Display a snackbar for successful registration and email verification
      Get.snackbar(
        'Registration Successful',
        'Verification email sent. Please verify your email before logging in.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Now, you can store the user data in the database
      await createUser(user);
    } catch (e) {
      // Handle registration errors
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // Handle email already in use error
          Get.snackbar(
            'Registration Failed',
            'The email address is already in use. Please use a different email.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          // Handle other FirebaseAuthException errors
          Get.snackbar(
            'Registration Failed',
            'An error occurred during registration. Please try again later.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Handle other non-FirebaseAuthException errors
        Get.snackbar(
          'Registration Failed',
          'An unexpected error occurred. Please try again later.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      // Rethrow the exception after handling
      rethrow;
    }
  }


  Future<void> createUser(usermodel user) async {
    await user_repositoryy.createUser(user);
  }
  Future<void> PhoneAuthentication(String phoneNo) async {
    try {
     AuthenticationRepository.instance.phoneauthentication(phoneNo);
    } catch (e) {
      print('Phone authentication error: $e');

    }
  }



}
