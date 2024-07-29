class XRay {
  String? id;
  int? nationalId;
  String? imageUrl;
  String? date;

  XRay({
    this.id,
    this.nationalId,
    this.imageUrl,
    this.date,
  });

  // Convert an XRay into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationalId': nationalId,
      'imageUrl': imageUrl,
      'date': date,
    };
  }

  factory XRay.fromMap(Map<String, dynamic> map) {
    return XRay(
      id: map['id'],
      nationalId: map['nationalId'],
      imageUrl: map['imageUrl'],
      date: map['date'],
    );
  }

}
