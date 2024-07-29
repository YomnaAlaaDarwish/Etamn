class Patient {
  int nationalId;
  String name;
  String dateOfBirth;
  String email;
  String password;
  String hasSurgeriesBefore;
  int ? parentId; // Add parentId

  Patient({
    required this.nationalId,
    required this.name,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.hasSurgeriesBefore,
    this.parentId, // Add parentId
  });

  Map<String, dynamic> toMap() {
    return {
      'nationalId': nationalId,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'password': password,
      'hasSurgeriesBefore': hasSurgeriesBefore,
      'parentId': parentId, // Add parentId
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      nationalId: map['nationalId'],
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      email: map['email'],
      password: map['password'],
      hasSurgeriesBefore: map['hasSurgeriesBefore'],
      parentId: map['parentId'], // Add parentId
    );
  }


  //static Future<Patient?> fromJson(Map<String, dynamic> responseData) {return;}

}