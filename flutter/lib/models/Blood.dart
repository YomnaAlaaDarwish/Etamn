class Blood {
  int ? id;
  int  nationalId;
  int? labId;
  String imageUrl;
  String status;
  String haemoglobin;
  String haematocrit;
  String rbcs;
  String date;

  Blood({
    this.id,
    required this.nationalId,
     this.labId,
    required this.imageUrl,
    required this.status,
    required this.haemoglobin,
    required this.haematocrit,
    required this.rbcs,
    required this.date,
  });

  // Convert a Blood into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationalId': nationalId,
      'labId': labId,
      'imageUrl': imageUrl,
      'status': status,
      'haemoglobin': haemoglobin,
      'haematocrit': haematocrit,
      'rbcs': rbcs,
      'date': date,
    };
  }

  factory Blood.fromMap(Map<String, dynamic> map) {
    return Blood(
      id: map['id'],
      nationalId: map['nationalId'],
      labId: map['labId'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      haemoglobin: map['haemoglobin'],
      haematocrit: map['haematocrit'],
      rbcs: map['rbcs'],
      date: map['date'],
    );
  }

}
