import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final Auth = FirebaseAuth.instance;
}
