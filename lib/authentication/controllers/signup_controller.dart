import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> RegisterUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


    } catch (e) {

      print('Registration error: $e');
      rethrow;
    }
  }
  Future<void> createUser(usermodel user) async {
    await user_repositoryy.createUser(user);
  }
  Future<void> PhoneAuthentication(String phoneNo) async {
    try {
    //  AuthenticationRepository.instance.phoneauthentication(phoneNo);
    } catch (e) {
      print('Phone authentication error: $e');
      // Add additional error handling as needed
    }
  }



}
