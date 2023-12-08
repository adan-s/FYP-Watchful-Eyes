

import 'package:fyp/authentication/authentication_repo.dart';
import 'package:fyp/screens/login_screen.dart';
import 'package:get/get.dart';

class otpcontroller extends GetxController{
  static otpcontroller get instance => Get.find();

  void VerifyOTP(String otp) async{
    var isVerified = await AuthenticationRepository.instance.verifyotp(otp);
    isVerified ? Get.offAll(const LoginScreen()) : Get.back();
  }
}