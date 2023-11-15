
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:watchfuleyes/authentication/controllers/signup_controller.dart';

class Signup extends StatefulWidget{
  const Signup ({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup>{
  final _formKey = GlobalKey<FormState>();
  final usernameEditingContoller = new TextEditingController();
  final firstNameEditingContoller=new TextEditingController();
  final lastNameEditingContoller=new TextEditingController();
  final emailEditingContoller=new TextEditingController();
  final contactNoEditingContoller=new TextEditingController();
  final dobEditingContoller=new TextEditingController();
  final cnicEditingContoller=new TextEditingController();
  final genderEditingContoller=new TextEditingController();
  final passwordEditingContoller=new TextEditingController();
  final confirmPasswordEditingContoller=new TextEditingController();

  @override
  Widget build(BuildContext context){
    final controller = Get.put(Signupcontroller());
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameEditingContoller,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          usernameEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "User-Name",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );

    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingContoller,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          firstNameEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "First Name",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );


    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingContoller,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if (value != null) {
          lastNameEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "Last Name",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );


    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingContoller,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        if (value != null) {
          emailEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "Email",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );


    final contactNoField = TextFormField(
      autofocus: false,
      controller: contactNoEditingContoller,
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        if (value != null) {
          contactNoEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "Contact No",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );


    final dobField = TextFormField(
      autofocus: false,
      controller: dobEditingContoller,
      keyboardType: TextInputType.datetime,
      onSaved: (value) {
        if (value != null) {
          dobEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "Date of Birth",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );


    final cnicField = TextFormField(
      autofocus: false,
      controller: cnicEditingContoller,
      keyboardType: TextInputType.number,

      onSaved: (value) {
        if (value != null) {
          cnicEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.credit_card),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "CNIC",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );




    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingContoller,
      onSaved: (value) {
        if (value != null) {
          passwordEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "Password",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingContoller,
      onSaved: (value) {
        if (value != null) {
          confirmPasswordEditingContoller.text = value;
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          contentPadding: EdgeInsets.fromLTRB(20, 15 , 20 ,15),
          hintText: "Confirm-Password",
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )
      ),
    );

    final signupButton=Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          if (_formKey.currentState!.validate()){
            Signupcontroller.instance.RegisterUser(controller.email.text.trim(), controller.password.text.trim());
          }
        },
        child: Text(
          "Sign-Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
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
                      child: Image.asset("assets/images.png",fit: BoxFit.contain,),
                    ),
                    SizedBox(height: 45),
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
                    cnicField,
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
    );
  }
}