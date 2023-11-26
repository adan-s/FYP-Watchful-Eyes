import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/signup.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../authentication/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginController controller = LoginController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
        hintStyle: TextStyle(color: Colors.white),
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
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            // Show the password recovery options
            await showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              builder: (context) => Material(
                color: Colors.transparent,
                child: Container(
                  width: 400, // Take full width
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    // Add white border
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Select One!",
                        style: Theme.of(context)
                            .textTheme
                            .headline6, // Adjust the font size
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // Close the bottom sheet
                                  Navigator.pop(context);

                                  // Show dialog or navigate to a screen to input email
                                  // and initiate the password reset via email
                                  // Use FirebaseAuth for password reset
                                  String? email =
                                      await forgetpasswordd(context);
                                  if (email != null) {
                                    try {
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                        email: email,
                                      );
                                      print(
                                          "Password reset email sent to $email");
                                    } catch (e) {
                                      print(
                                          "Error sending password reset email: $e");
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.mail_outline_rounded,
                                          size: 40.0, color: Colors.black),
                                      const SizedBox(width: 5.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(fontSize: 16.0),
                                          ),
                                          Text(
                                            "Reset via Email Verification",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone,
                                          size: 40.0, color: Colors.black),
                                      const SizedBox(width: 5.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Contact No",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(fontSize: 16.0),
                                          ),
                                          Text(
                                            "Reset via Phone Verification",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(fontSize: 14.0),
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
                color: Colors.blue,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );

    final loginButton = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF000104),
            Color(0xFF18293F),
            Color(0xFF141E2C),
            Color(0xFF18293F),
            Color(0xFF000104)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          // Handle login logic using the LoginController
          controller.login();

          // Clear text fields after clicking on login
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
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.login,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );

    final errorText = Obx(() => Text(
          controller.errorMessage.value,
          style: TextStyle(color: Colors.red),
        ));

    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Color(0xFF000104),
        //       Color(0xFF0E121B),
        //       Color(0xFF141E2C),
        //       Color(0xFF18293F),
        //       Color(0xFF193552),
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        color:Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    screenWidth > 600 ? screenWidth * 0.2 : screenWidth * 0.02,
              ),
              child: Card(
                elevation: 10,
                color: Colors.transparent,
                // Set the card background color to transparent
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 300,
                            child: Image.asset(
                              "logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 20),
                          emailField,
                          SizedBox(height: 25),
                          passwordField,
                          SizedBox(height: 35),
                          loginButton,
                          SizedBox(height: 15),
                          errorText, // Display error message
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the signup screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()),
                                  );
                                },
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                    color: Colors.lightBlue,
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
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> forgetpasswordd(BuildContext context) async {
  TextEditingController emailController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Enter your email"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.black),
                // Add email icon
                hintText: "Enter  Email",
                // Add a placeholder
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, emailController.text.trim());
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
