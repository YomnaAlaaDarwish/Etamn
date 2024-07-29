class Lab {
  final int id;
  final String name;
  // Add other fields as necessary

  Lab({required this.id, required this.name});

  factory Lab.fromMap(Map<String, dynamic> map) {
    return Lab(
      id: map['id'],
      name: map['name'],
      // Initialize other fields
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // Map other fields
    };
  }
}
