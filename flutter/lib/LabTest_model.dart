class LabTest {
  int? labTestId; // Add labTestId as the primary key
  int userId;
  int labId;
  String testName;
  String imageUrl;
  String status; // Add status field

  LabTest({
    this.labTestId,
    required this.userId,
    required this.labId,
    required this.testName,
    required this.imageUrl,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'labId': labId,
      'testName': testName,
      'imageUrl': imageUrl,
      'status': status,
    };

    if (labTestId != null) {
      map['labTestId'] = labTestId;
    }

    return map;
  }

  factory LabTest.fromMap(Map<String, dynamic> map) {
    return LabTest(
      labTestId: map['labTestId'],
      userId: map['userId'],
      labId: map['labId'],
      testName: map['testName'],
      imageUrl: map['imageUrl'],
      status: map['status'], // Assign status from map
    );
  }
}
