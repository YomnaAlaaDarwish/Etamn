class Prescription {
  String? id;
  String? nationalId;
  String? imageUrl;
  String? date;

  Prescription({
    this.id,
    this.nationalId,
    this.imageUrl,
    this.date,
  });

  // Convert a Prescription into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationalId': nationalId,
      'imageUrl': imageUrl,
      'date': date,
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'],
      nationalId: map['nationalId'],
      imageUrl: map['imageUrl'],
      date: map['date'],
    );
  }

}
