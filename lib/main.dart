import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/authentication/authentication_repo.dart';
import 'package:fyp/screens/CrimeDataPage.dart';
import 'package:fyp/screens/analyticsandreports.dart';
import 'package:fyp/screens/journeyTrack.dart';
import 'package:fyp/screens/login_screen.dart';
import 'package:fyp/screens/signup.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyBhcF3CgybYcpRRAk3TE-ZvgFlkJRagmgU',
          appId: '1:321253756082:web:9843f6a0837010ea788dab',
          messagingSenderId: '321253756082',
          projectId: 'watchfuleyes-c2a9d',
          authDomain: 'watchfuleyes-c2a9d.firebaseapp.com',
          databaseURL: 'https://watchfuleyes-c2a9d-default-rtdb.firebaseio.com',
          storageBucket: 'gs://watchfuleyes-c2a9d.appspot.com',
        ),
      );
    } catch (e) {
      // Handle initialization errors
      print('Error initializing Firebase: $e');
    }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthenticationRepository authRepository = AuthenticationRepository();
    authRepository.checkLocalUserDetails();

    return GetMaterialApp(
      title: 'Watchful Eyes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Pass the initialized AuthenticationRepository to your screens
      initialBinding: BindingsBuilder(() {
        Get.put(authRepository);
      }),
      home: Obx(
            () {
          var user = authRepository.firebaseUser.value;
          return user == null ? CrimeDataPage() : UserPanel();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


