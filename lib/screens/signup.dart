import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../authentication/authentication_repo.dart';
import '../authentication/controllers/signup_controller.dart';
import '../authentication/models/user_model.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();

    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 5 || i == 12) {
        newText.write('-'); // Add hyphen at index 5 and 12
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(
        offset: newText.length,
      ),
    );
  }
}


class _MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;

  _MaskedTextInputFormatter({required this.mask});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final List<String> maskChars = mask.split('');

    final StringBuffer newText = StringBuffer();
    int maskIndex = 0;

    for (int i = 0; i < maskChars.length; i++) {
      if (maskChars[i] == 'D') {
        if (maskIndex < newValue.text.length) {
          newText.write(newValue.text[maskIndex]);
          maskIndex++;
        } else {
          newText.write(' ');
        }
      } else {
        newText.write(maskChars[i]);
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(
        offset: newText.length,
      ),
    );
  }
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool isEmailAuthentication = true;

  @override
  Widget build(BuildContext context) {
    String selectedGender = 'Female';
    final controller = Get.put(Signupcontroller());
    final authenticationRepository = Get.put(AuthenticationRepository());

    final usernameField = TextFormField(
      autofocus: false,
      controller: controller.username,
      maxLength: 15,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          controller.username.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.white),
        counterText: '',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User-Name",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username is required';
        } else if (value.length > 15) {
          return 'Username must be at most 15 characters long';
        }
        return null;
      },
    );

    final firstNameField = TextFormField(
      autofocus: false,
      controller: controller.firstName,
      maxLength: 20,
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
      ],
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
        counterText: '',
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
        if (!RegExp(r'^[a-zA-Z]*$').hasMatch(value)) {
          return 'Enter a valid First Name (only letters allowed)';
        }
        return null;
      },
    );


    final lastNameField = TextFormField(
      autofocus: false,
      controller: controller.lastName,
      keyboardType: TextInputType.name,
      maxLength: 20,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
      ],
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
        counterText: '',
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

        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Enter a valid Last Name (only letters allowed)';
        }
        return null;
      },
    );


    final emailField = TextFormField(
      autofocus: false,
      controller: controller.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!value.endsWith("@gmail.com")) {
          return 'Please enter a valid Gmail address';
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
        hintText: "Email (abc@gmail.com)",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
    );

    final cnicField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      controller: controller.cnic,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
        _CnicInputFormatter(),
      ],
      onSaved: (value) {
        if (value != null && value.isNotEmpty) {
          controller.cnic.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.credit_card, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "CNIC (12345-3389712-0)",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'CNIC is required';
        }
        if (!RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(value)) {
          return 'Enter a valid CNIC (e.g., 12345-3389712-0)';
        }
        return null;
      },
    );

    final genderField = DropdownButtonFormField<String>(
      value: selectedGender,
      onChanged: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Select Gender",
        hintStyle: TextStyle(fontFamily: 'outfit', color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontFamily: 'outfit', color: Colors.white),
      dropdownColor: Color(0xFF769DC9),
      items: ['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(

            // Set the background color for each dropdown item
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Gender is required';
        }
        return null;
      },
    );

    final contactNoField = TextFormField(
      autofocus: false,
      maxLength: 13,
      controller: controller.contactNo,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),

      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Contact number is required';
        }

        final cleanedPhoneNumber = value.replaceAll(RegExp(r'\D'), '');
        if (cleanedPhoneNumber.length != 12) {
          return 'Enter a valid phone number';
        }

        return null;
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
        hintText: "Contact No (+923215722553)",
        counterText: '',
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
      inputFormatters: [
        _MaskedTextInputFormatter(mask: 'MM/DD/YYYY'),
      ],
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          String formattedMonth = selectedDate.month.toString().padLeft(2, '0');
          String formattedDay = selectedDate.day.toString().padLeft(2, '0');
          controller.dob.text = "$formattedMonth/$formattedDay/${selectedDate.year}";

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

        try {
          // Parse the selected date using the correct format
          DateTime selectedDate = DateFormat('MM/dd/yyyy').parseStrict(value);

          // Calculate age
          DateTime currentDate = DateTime.now();
          int age = currentDate.year - selectedDate.year;

          // Check if the user is at least 18 years old
          if (currentDate.month < selectedDate.month ||
              (currentDate.month == selectedDate.month &&
                  currentDate.day < selectedDate.day)) {
            age--; // Subtract 1 year if the birthday hasn't occurred yet
          }

          if (age < 18) {
            return 'You must be at least 18 years old';
          }
        } catch (e) {
          return 'Enter a valid date';
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
      maxLength: 20,
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
        counterText: '',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: TextStyle(
          fontFamily: 'outfit',
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        } else if (!RegExp(r'[@#$%^&+=]').hasMatch(value)) {
          return 'Password must contain at least one symbol (@, #, %, ^, &, +, =)';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (controller.email.text.isNotEmpty) {
              usermodel newUser = usermodel(
                username: controller.username.text.trim(),
                firstName: controller.firstName.text.trim(),
                lastName: controller.lastName.text.trim(),
                email: controller.email.text.trim(),
                contactNo: controller.contactNo.text.trim(),
                cnic: controller.cnic.text.trim(),
                dob: controller.dob.text.trim(),
                gender: selectedGender,
                password: controller.password.text.trim(),
                confirmPassword: controller.confirmPassword.text.trim(),
                profileImage: '',
              );

              // User is signing up with email
              await Signupcontroller.instance.RegisterUser(
                controller.email.text.trim(),
                controller.password.text.trim(),
                newUser,
              );
              controller.username.clear();
              controller.firstName.clear();
              controller.lastName.clear();
              controller.email.clear();
              controller.contactNo.clear();
              controller.cnic.clear();
              controller.dob.clear();
              controller.password.clear();
              controller.confirmPassword.clear();
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, color: Colors.black),
            SizedBox(width: 10),
            Text(
              "Sign-Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'outfit',
                fontSize: 20,
                color: Colors.black,
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
          gradient: LinearGradient(
            colors: [
              Color(0xFFCBE1EE),
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                      cnicField,
                      SizedBox(height: 20),
                      dobField,
                      SizedBox(height: 20),
                      genderField,
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
            if (kIsWeb && screenWidth > 700) lottieAnimation,
          ],
        ),
      ),
    );
  }
}
