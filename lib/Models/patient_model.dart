class Patient {
  String id;
  String firstName;
  String lastName;
  String age;
  String gender;
  String phoneNumber;
  String email;
  List<String> allergies;
  List<String> medicalHistory;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.allergies,
    required this.medicalHistory,
  });

  void addAllergy(String allergy) {
    allergies.add(allergy);
  }

  void editInfo({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? age
  }) 
    {
      if (firstName != null) this.firstName = firstName;
      if (lastName != null) this.lastName = lastName;
      if(age != null) this.age = age;
      if (phoneNumber != null) this.phoneNumber = phoneNumber;
      if (email != null) this.email = email;
    }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'allergies': allergies,
      'medicalHistory': medicalHistory,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      allergies: List<String>.from(json['allergies']),
      medicalHistory: List<String>.from(json['medicalHistory']),
    );
  }
}
