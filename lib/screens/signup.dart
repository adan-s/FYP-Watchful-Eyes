import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/screens/otp_screen.dart';
import 'package:get/get.dart';

import '../authentication/authentication_repo.dart';
import '../authentication/controllers/signup_controller.dart';
import '../authentication/models/user_model.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Signupcontroller());
    final authenticationRepository = Get.put(AuthenticationRepository());

    final usernameField = TextFormField(
      autofocus: false,
      controller: controller.username,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          controller.username.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User-Name",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );

    final firstNameField = TextFormField(
      autofocus: false,
      controller: controller.firstName,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          controller.firstName.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      controller: controller.lastName,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          controller.lastName.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Last Name",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );

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
        prefixIcon: Icon(Icons.mail, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );

    final contactNoField = TextFormField(
      autofocus: false,
      controller: controller.contactNo,
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        if (value != null) {
          // Format the phone number to comply with E.164 standards
          final formattedPhoneNumber = '+92$value'; // Assuming the country code for Pakistan is +92
          controller.contactNo.text = formattedPhoneNumber;
        }
      },

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );


    final dobField = TextFormField(
      autofocus: false,
      controller: controller.dob,
      keyboardType: TextInputType.datetime,
      onSaved: (value) {
        if (value != null) {
          controller.dob.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of Birth is required';
        }

        final RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
        if (!dateRegExp.hasMatch(value)) {
          return 'Enter a valid date format (MM/DD/YYYY)';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Date of Birth",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: controller.password,
      onSaved: (value) {
        if (value != null) {
          controller.password.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: controller.confirmPassword,
      onSaved: (value) {
        if (value != null) {
          controller.confirmPassword.text = value;
        }
      },
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm Password is required';
        } else if (value != controller.password.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
    );

    final signupButton = Container(
      width: double.infinity,
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
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Signupcontroller.instance.RegisterUser(
              controller.email.text.trim(),
              controller.password.text.trim());
              /*Signupcontroller.instance.PhoneAuthentication(controller.contactNo.text.trim());
              Get.to(()=> const OTPSCREEN());*/
            final user = usermodel(
              username: controller.username.text.trim(),
              firstName: controller.firstName.text.trim(),
              lastName: controller.lastName.text.trim(),
              contactNo: controller.contactNo.text.trim(),
              dob: controller.dob.text.trim(),
              cnic: controller.cnic.text.trim(),
              gender: controller.gender.text.trim(),

            );
            Signupcontroller.instance.createUser(user);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Sign-Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of the screen width
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
                    padding: const EdgeInsets.all(20.0),
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
                          usernameField,
                          SizedBox(height: 20),
                          firstNameField,
                          SizedBox(height: 20),
                          lastNameField,
                          SizedBox(height: 20),
                          emailField,
                          SizedBox(height: 20),
                          contactNoField,
                          SizedBox(height: 20),
                          dobField,
                          SizedBox(height: 20),
                          passwordField,
                          SizedBox(height: 20),
                          confirmPasswordField,
                          SizedBox(height: 25),
                          signupButton,
                          SizedBox(height: 20),
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
