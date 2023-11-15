
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Signupcontroller extends GetxController{
  static Signupcontroller get instance => Get.find();

  final username = TextEditingController();
  final firstName = TextEditingController();
  final  lastName = TextEditingController();
  final email = TextEditingController();
  final contactNo = TextEditingController();
  final dob = TextEditingController();
  final cnic = TextEditingController();
  final gender = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  void RegisterUser(String email, String password){

  }

}

