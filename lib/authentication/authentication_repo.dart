import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  var verificationId = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String email, String password, String username) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'username': username,
        'email': email,
        // Add more fields as needed
      });
    } catch (e) {
      // Handle registration errors
      print('Registration error: $e');
      rethrow; // Re-throw the exception for handling in the calling code
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve additional user data from Firestore
      final userData = await FirebaseFirestore.instance.collection('users').doc(email).get();

      // Use the userData as needed

      return result.user;
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: $e');
      return null;
    }
  }

  Future<void> phoneauthentication(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e){
        if (e.code == 'Invalid Contact-No'){
          Get.snackbar('Error', 'Contact No is not Valid');
        }else{
          Get.snackbar('Error', 'Try Again');
        }
      },
      codeSent: (verificationId, resendToken){
        this.verificationId.value=verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId){
        this.verificationId.value=verificationId;
      },

    );

  }
  Future<bool> verifyotp(String otp) async{
    var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verificationId.value, smsCode: otp));
    return credentials.user !=null ? true:false;
  }
}