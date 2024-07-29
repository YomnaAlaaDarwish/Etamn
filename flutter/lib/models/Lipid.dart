class Lipid {
  int ? id;
  int nationalId;
  int ?labId;
  String imageUrl;
  String status;
  String cholesterolTotal;
  String triglycerides;
  String hdlCholesterol;
  String ldlCholesterol;
  String date; // New date field

  Lipid({
    this.id,
    required this.nationalId,
     this.labId,
    required this.imageUrl,
    required this.status,
    required this.cholesterolTotal,
    required this.triglycerides,
    required this.hdlCholesterol,
    required this.ldlCholesterol,
    required this.date, // Add this to the constructor
  });

  // Convert a Lipid into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationalId': nationalId,
      'labId': labId,
      'imageUrl': imageUrl,
      'status': status,
      'cholesterolTotal': cholesterolTotal,
      'triglycerides': triglycerides,
      'hdlCholesterol': hdlCholesterol,
      'ldlCholesterol': ldlCholesterol,
      'date': date, // Add this to the map
    };
  }

  factory Lipid.fromMap(Map<String, dynamic> map) {
    return Lipid(
      id: map['id'],
      nationalId: map['nationalId'],
      labId: map['labId'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      cholesterolTotal: map['cholesterolTotal'],
      triglycerides: map['triglycerides'],
      hdlCholesterol: map['hdlCholesterol'],
      ldlCholesterol: map['ldlCholesterol'],
      date: map['date'], // Add this to the factory constructor
    );
  }

}