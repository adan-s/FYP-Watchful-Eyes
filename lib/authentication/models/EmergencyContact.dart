class EmergencyContact {
  String name;
  String phoneNumber;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'phoneNumber' : phoneNumber,
    };
  }


  // Create an instance from a map received from Firebase
  factory EmergencyContact.fromMap(String id, Map<String, dynamic> data) {
    return EmergencyContact(
      name: data['name'],
      phoneNumber: data['phoneNumber'],
    );
  }
}
