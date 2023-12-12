import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/screens/login_screen.dart';
import 'package:fyp/screens/otp_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
  bool isEmailAuthentication = true;
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
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
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
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First Name is required';
        }
        // Check if the input contains only alphabetical characters
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Enter a valid First Name (letters only)';
        }
        return null;
      },
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
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Last Name is required';
        }
        // Check if the input contains only alphabetical characters
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Enter a valid Last Name (letters only)';
        }
        return null;
      },
    );


    final emailField = TextFormField(
      autofocus: false,
      controller: controller.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (controller.contactNo.text.isEmpty && (value == null || value.isEmpty)) {
          return 'Email is required';
        }

        if (controller.contactNo.text.isNotEmpty && value != null && value.isNotEmpty) {
          return 'Email should be empty';
        }

        if (value != null && value.isNotEmpty) {
          if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
            return 'Enter a valid email address';
          }
        }
        return null;
      },
      onSaved: (value) {
        if (value != null && value.isNotEmpty) {
          controller.email.text = value;
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
    );



    final contactNoField = TextFormField(
      autofocus: false,
      controller: controller.contactNo,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (controller.email.text.isEmpty && (value == null || value.isEmpty)) {
          // If signing up with phone number and contact number is empty
          return 'Contact number is required';
        }

        if (controller.email.text.isNotEmpty && value != null && value.isNotEmpty) {
          // If signing up with email and contact number is not empty
          return 'Contact number should be empty';
        }

        if (value != null && value.isNotEmpty) {
          // Format the phone number to comply with E.164 standards
          final cleanedPhoneNumber = value.replaceAll(RegExp(r'\D'), '');
          if (cleanedPhoneNumber.length == 13) {
            return 'Enter a valid phone number with country code';
          }
        }

        return null; // Validation passed
      },
      onSaved: (value) {
        if (value != null && value.isNotEmpty) {
          final cleanedPhoneNumber = value.replaceAll(RegExp(r'\D'), '');
          final formattedPhoneNumber = '+92$cleanedPhoneNumber';
          controller.contactNo.text = formattedPhoneNumber;
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Contact No",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
    );


    final dobField = TextFormField(
      autofocus: false,
      controller: controller.dob,
      keyboardType: TextInputType.datetime,
      onTap: () async {

        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        // Update the controller with the selected date
        if (selectedDate != null) {
          controller.dob.text = "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
        }
      },
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
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
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
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
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
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
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
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
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

    final screenWidth = MediaQuery.of(context).size.width;
    final lottieAnimation = kIsWeb
        ? Expanded(
            child: Container(
              width: screenWidth * 0.5,
              height: screenWidth * 0.5, // Set an appropriate height
              child: Lottie.asset('assets/loginuser.json'),
            ),
          )
        : SizedBox.shrink();

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
            if (controller.email.text.isNotEmpty) {
              // User is signing up with email
              Signupcontroller.instance.RegisterUser(
                controller.email.text.trim(),
                controller.password.text.trim(),
              );
            } else if (controller.contactNo.text.isNotEmpty)
            {
              // User is signing up with phone number
              Signupcontroller.instance.PhoneAuthentication(controller.contactNo.text.trim());
              Get.to(() => const OTPSCREEN());
            }

            // Additional code for creating the user and clearing fields
            if (controller.email.text.isNotEmpty || controller.contactNo.text.isNotEmpty) {
              final user = usermodel(
                username: controller.username.text.trim(),
                firstName: controller.firstName.text.trim(),
                lastName: controller.lastName.text.trim(),
                contactNo: controller.contactNo.text.trim(),
                email: controller.email.text.trim(),
                dob: controller.dob.text.trim(),
                cnic: controller.cnic.text.trim(),
                gender: controller.gender.text.trim(),
                password: controller.password.text.trim(),
                confirmPassword: controller.confirmPassword.text.trim(),
                profileImage: " ",
              );
              Signupcontroller.instance.createUser(user);
              controller.username.clear();
              controller.firstName.clear();
              controller.lastName.clear();
              controller.email.clear();
              controller.contactNo.clear();
              controller.dob.clear();
              controller.password.clear();
              controller.confirmPassword.clear();

            }
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
                fontFamily: 'outfit',
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loginbgg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                          'assets/logo.png',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account? ",
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
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              "LogIn",
                              style: TextStyle(
                                fontFamily: 'outfit',
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
            if (kIsWeb && screenWidth>700) lottieAnimation,

          ],
        ),
      ),
    );
  }
}
