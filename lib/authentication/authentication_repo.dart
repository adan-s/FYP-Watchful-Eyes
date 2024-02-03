import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_screen.dart';
import '../screens/user-panel.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  var verificationId = ''.obs;

  late final Rx<User?> firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());

    checkLocalUserDetails();
  }

  Future<void> checkLocalUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? userEmail = prefs.getString('userEmail');

    if (userId != null && userEmail != null) {
      try {
        final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: '',
        );
        firebaseUser.value = result.user;

        print('User signed in with locally stored details');
      } catch (e) {
        // Handle sign-in errors
        print('Sign-in error: $e');
      }
    }
  }
  Future<void> saveUserDetailsLocally(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.uid);
    prefs.setString('userEmail', user.email ?? '');
    print('User details saved locally');
  }

  Future<void> registerUser(String email, String password, String username) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final currentUser = FirebaseAuth.instance.currentUser;

      // Send email verification to the user
      await currentUser?.sendEmailVerification();

      await FirebaseFirestore.instance.collection('Users').doc(email).set({
        'username': username,
        'email': email,
      });
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await FirebaseFirestore.instance.collection('Users').doc(email).get();

      return result.user;
    } catch (e) {
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

  Future<bool> VerifyOTP(String otp) async{
    var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verificationId.value, smsCode: otp));
    return credentials.user !=null ? true:false;
  }
  Future<void> logout() async {
    print('Before Logout: ${_auth.currentUser}');
    try {
      await _auth.signOut();

      // Clear locally stored user details upon logout
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('userId');
      prefs.remove('userEmail');

      print('After Logout: ${_auth.currentUser}');
    } catch (e) {
      print('Logout error: $e');
    }
  }


}