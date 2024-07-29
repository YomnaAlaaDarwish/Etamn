class User {
  int nationalId;
  String name;
  String dateOfBirth;
  String email;
  String password;
  String hasSurgeriesBefore;

  User({
    required this.nationalId,
    required this.name,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.hasSurgeriesBefore,
  });

  Map<String, dynamic> toMap() {
    return {
      'nationalId': nationalId,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'password': password,
      'hasSurgeriesBefore': hasSurgeriesBefore,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nationalId: map['nationalId'],
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      email: map['email'],
      password: map['password'],
      hasSurgeriesBefore: map['hasSurgeriesBefore'],
    );
  }
}