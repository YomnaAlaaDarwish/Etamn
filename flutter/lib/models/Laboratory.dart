class Laboratory {
  int ? id;
  String name;
  String imageHash;
  String email;
  String password;

  Laboratory({
    this.id,
    required this.name,
    required this.imageHash,
    required this.email,
    required this.password,
  });

  // Convert a Laboratory into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageHash': imageHash,
      'email': email,
      'password': password,
    };
  }

  factory Laboratory.fromMap(Map<String, dynamic> map) {
    return Laboratory(
      id: map['id'],
      name: map['name'],
      imageHash: map['imageHash'],
      email: map['email'],
      password: map['password'],
    );
  }

}
