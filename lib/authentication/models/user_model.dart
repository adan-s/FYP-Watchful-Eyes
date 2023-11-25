

class usermodel{
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

}