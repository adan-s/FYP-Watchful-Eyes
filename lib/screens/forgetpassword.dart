import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Get.snackbar(
        'Password Reset Email Sent',
        'Check your email to reset your password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
      );
    } catch (e) {
      print('Password reset error: $e');

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Get.snackbar(
            'User Not Found',
            'No user found with this email address.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to send password reset email. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/loginbgg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Centered content
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Positioned circular image with padding
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0), // Adjust top value as needed
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width > 600 ? 100.0 : 80.0,
                        // Adjust radius based on screen width
                        backgroundImage: AssetImage('assets/forget1.jpg'),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Forget Password text
                    Text(
                      'Forget Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'outfit',
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Additional text
                    Text(
                      'Your Account Security is Our Priority! We Have Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'outfit',
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 25.0),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),



                    SizedBox(height: 50.0),
                    ElevatedButton(
                      onPressed: () {
                        sendPasswordResetEmail();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        primary: Colors.transparent,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF000104),
                              Color(0xFF18293F),
                              Color(0xFF141E2C),
                              Color(0xFF18293F),
                              Color(0xFF000104),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
