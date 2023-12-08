import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fyp/authentication/controllers/otp_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OTPSCREEN extends StatelessWidget {
  const OTPSCREEN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(otpcontroller());
    var OTP;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CO\nDE",
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
                fontSize: 70.0,
              ),
            ),
            Text("Verification", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 40.0),
            Text(
              "Enter the verification code at hadiahadia402@gmail.com",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black,
              filled: true,
              onSubmit: (code){
                OTP=code;
                otpcontroller.instance.VerifyOTP(OTP);
              }),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  otpcontroller.instance.VerifyOTP(OTP);
                },
                child: const Text("NEXT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
