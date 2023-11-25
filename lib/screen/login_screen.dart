import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:watchfuleyes/screen/signup.dart';

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
    final emailField = TextFormField(
      autofocus: false,
      controller: controller.email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        if (value != null) {
          controller.email.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
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
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
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
                builder: (context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select One!", style: Theme.of(context).textTheme.headline3),
                      const SizedBox(height: 30.0,),
                      GestureDetector(
                        onTap: () async {
                          // Close the bottom sheet
                          Navigator.pop(context);

                          // Show dialog or navigate to a screen to input email
                          // and initiate the password reset via email
                          // Use FirebaseAuth for password reset
                          String? email = await forgetpasswordd(context);
                          if (email != null) {
                            try {
                              await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: email,
                              );
                              print("Password reset email sent to $email");
                            } catch (e) {
                              print("Error sending password reset email: $e");
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black12,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.mail_outline_rounded, size: 60.0),
                              const SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email", style: Theme.of(context).textTheme.headline6,),
                                  Text("Reset via Email Verification",
                                    style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black12,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone,size: 60.0),
                          const SizedBox(width: 5.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Contact No",style: Theme.of(context).textTheme.headline6,),
                              Text("Reset via Phone Verification",
                                style:Theme.of(context).textTheme.bodyText2 ,)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),


            ));
          },
          child: Text(
            "                                                Forget Password",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
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
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final errorText = Obx(() => Text(
      controller.errorMessage.value,
      style: TextStyle(color: Colors.red),
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/images.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45),
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
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the signup screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
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
                prefixIcon: Icon(Icons.email), // Add email icon
                hintText: "Enter  Email", // Add a placeholder
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


