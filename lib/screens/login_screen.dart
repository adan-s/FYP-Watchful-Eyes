import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/signup.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../authentication/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginController controller = LoginController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchAndNavigateToUserProfile() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: controller.email.text.trim(),
        password: controller.password.text.trim(),
      );

      if (userCredential.user != null) {
        // Now navigate to the user profile page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(),
          ),
        );
      }
    } catch (e) {
      print('Login error: $e');
      // Handle login errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final lottieAnimation = kIsWeb
        ? Expanded(
            child: Container(
              width: screenWidth * 0.5,
              height: screenWidth * 0.5,
              child: Lottie.asset('assets/loginuser.json'),
            ),
          )
        : SizedBox.shrink();

    final emailField = TextFormField(
      autofocus: false,
      controller: controller.email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        if (value != null) {
          controller.email.text = value;
        }
      },
      style: TextStyle(color: Colors.white),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: controller.password,
          obscureText: true,
          onSaved: (value) {
            if (value != null) {
              controller.password.text = value;
            }
          },
          style: TextStyle(color: Colors.white),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.key, color: Colors.white),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Color(0xFF769DC9),
              builder: (context) => Material(
                color: Colors.transparent,
                child: Container(
                  width: 400,
                  height:250,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0), // Smaller border radius
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Reset Password",
                        style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pop(context);
                                  String? email = await forgetPassword(context);
                                  if (email != null) {
                                    try {
                                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                      print("Password reset email sent to $email");
                                    } catch (e) {
                                      print("Error sending password reset email: $e");
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.mail_outline_rounded, size: 40.0, color: Colors.white),
                                      const SizedBox(width: 5.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16.0, color: Colors.white),
                                          ),
                                          Text(
                                            "Reset via Email Verification",
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14.0, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                fontFamily: 'outfit',
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ),

      ],
    );

    final loginButton = Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          // Display the loading animation
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    'assets/loginloadingbar.json',
                    width: 300,
                    height: 300,
                  ),
                ),
              );
            },
          );

          // Set the callback for successful login
          controller.setOnLoginSuccess(() async {

            Get.offAll(() => UserPanel());
          });

          // Call the login method
          await controller.login();

          // Clear email and password fields after login attempt
          controller.email.clear();
          controller.password.clear();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'outfit',
                fontSize: 20,
                color:  Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.login,
              color:  Colors.black,
            ),
          ],
        ),
      ),
    );

    final errorText = Obx(() => Center(
      child: Text(
        controller.errorMessage.value,
        style: TextStyle(color: Colors.red),
      ),
    ));


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF769DC9),
              Color(0xFF769DC9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            if (kIsWeb && screenWidth > 700) lottieAnimation,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: kIsWeb
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: kIsWeb ? 350 : 480,
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: kIsWeb ? 400 : null, // Set the desired width
                          child: emailField,
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: kIsWeb ? 400 : null, // Set the desired width
                          child: passwordField,
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: loginButton,
                        ),
                        SizedBox(height: 25),
                        errorText,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontFamily: 'outfit',
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()),
                                );
                              },
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                  fontFamily: 'outfit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> forgetPassword(BuildContext context) async {
  TextEditingController emailController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF769DC9), // Set background color
        title: Text(
          "Enter your email",
          style: TextStyle(color: Colors.white), // Set text color
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintText: "Enter Email",
                hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red, // Set cancel button background color
            ),
            child: Text('Cancel', style: TextStyle(color: Colors.white)), // Set cancel button text color
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, emailController.text.trim());

              // Send the reset email
              String? email = emailController.text.trim();
              if (email != null) {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  print("Password reset email sent to $email");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Email sent successfully',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print("Error sending password reset email: $e");
                }
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green, // Set OK button background color
            ),
            child: Text('OK', style: TextStyle(color: Colors.white)), // Set OK button text color
          ),
        ],
      );
    },
  );
}
