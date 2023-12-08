import 'package:fyp/authentication/authentication_repo.dart';
import 'package:fyp/user_repository.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';


class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _authRepo = Get.find<AuthenticationRepository>();
  final _userRepo = Get.find<UserRepository>();

  Future<usermodel?> getUserData() async {
    try {
      final currentUser = await _authRepo.getCurrentUser();
      final email = currentUser?.email;

      if (email != null) {
        return await _userRepo.getUserDetails(email);
      } else {
        Get.snackbar("Error", "Login to Continue");
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}

