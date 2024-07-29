class Surgery {
  int? id;
  int? nationalId;
  String? imageUrl;
  String? date;

  Surgery({
    this.id,
    this.nationalId,
    this.imageUrl,
    this.date,
  });

  // Convert a Surgery into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationalId': nationalId,
      'imageUrl': imageUrl,
      'date': date,
    };
  }

  factory Surgery.fromMap(Map<String, dynamic> map) {
    return Surgery(
      id: map['id'],
      nationalId: map['nationalId'],
      imageUrl: map['imageUrl'],
      date: map['date'],
    );
  }
}
