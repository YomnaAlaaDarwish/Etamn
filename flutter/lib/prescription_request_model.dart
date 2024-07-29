class PrescriptionRequest {
  int? id;
  final int userId;
  final int doctorId;
  final String imageUrl;
  String status; // Add status field

  PrescriptionRequest({
    this.id,
    required this.userId,
    required this.doctorId,
    required this.imageUrl,
    required this.status, // Initialize with a default status
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'imageUrl': imageUrl,
      'status': status, // Include status in the map
    };
  }

  factory PrescriptionRequest.fromMap(Map<String, dynamic> map) {
    return PrescriptionRequest(
      id: map['id'],
      userId: map['userId'],
      doctorId: map['doctorId'],
      imageUrl: map['imageUrl'],
      status: map['status'], // Assign status from map
    );
  }
}
