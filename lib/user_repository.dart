
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watchfuleyes/authentication/models/user_model.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _database=FirebaseFirestore.instance;
  
  createUser(usermodel user) async {
    await _database.collection("Users").add(user.toJson()).whenComplete(() =>
    Get.snackbar("Success", "Account has been Created",snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.white,
    colorText: Colors.black),
    )
    .catchError((error,stackTrace){
      Get.snackbar("Error", "Something went wrong...Try Again",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black);
      print(error.toString());
    });

  }
}