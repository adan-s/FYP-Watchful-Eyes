import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/login_screen.dart';
import '../screens/user-panel.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  late final Rx<User?> firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());

  }

  Future<void> registerUser(String email, String password, String username) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
      // Handle sign-in errors
      print('Sign-in error: $e');
      return null;
    }
  }
}