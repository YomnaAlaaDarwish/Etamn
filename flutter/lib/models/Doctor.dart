class Doctor {
  int nationalId;
  String name;
  String dateOfBirth;
  String email;
  String password;
  String certificateHash;
  String? speciality;  // Optional speciality attribute

  Doctor({
    required this.nationalId,
    required this.name,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.certificateHash,
    this.speciality,  // Initialize the optional speciality
  });

  Map<String, dynamic> toMap() {
    return {
      'nationalId': nationalId,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'password': password,
      'certificateHash': certificateHash,
      'speciality': speciality,  // Include speciality in the map
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      nationalId: map['nationalId'],
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      email: map['email'],
      password: map['password'],
      certificateHash: map['certificateHash'],
      speciality: map['speciality'],  // Extract speciality from map
    );
  }
}
