import 'package:cloud_firestore/cloud_firestore.dart';

class usermodel{
  final String? id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNo;
  final String dob;
  final String cnic;
  final String gender;
  final String password;
  final String confirmPassword;


  const usermodel({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    required this.dob,
    required this.cnic,
    required this.gender,
    required this.password,
    required this.confirmPassword,


  });


  toJson(){
    return{

      "UserName": username,
      "FirstName":firstName,
      "LastName":lastName,
      "Email":email,
      "ContactNo":contactNo,
      "DOB":dob,
      "CNIC":cnic,
      "Gender":gender,
      "Password":password,
      "ConfirmPassword":confirmPassword,


    };
  }
  factory usermodel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data = document.data()!;
    return usermodel(
        id: document.id,
        username: data["UserName"],
        firstName: data["FirstName"],
        lastName: data["LastName"],
        email: data["Email"],
        contactNo:data["ContactNo"],
        dob: data["DOB"],
        cnic: data["CNIC"],
        gender: data["Gender"],
        password: data["Password"],
        confirmPassword: data["ConfirmPassword"]

    );

  }

}