import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/Patient.dart';
import 'prescription_request_model.dart';
import 'Lab_model.dart';
import 'LabTest_model.dart';
import 'user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BlockchainHelper {

// SignUp & Login Patient
Future<void> insertPatient({
required int nationalId,
required String name,
required String email,
required String dateOfBirth,
required String password,
required String hasSurgeriesBefore,
}) async {
// Define the URL of your backend API
final String url = 'http://192.168.1.9:8000/api/add-patient';

// Create the request body
final Map<String, dynamic> body = {
'nationalid': nationalId,
'name': name,
'email': email,
'dateOfBirth': dateOfBirth,
'password': password,
'hasSurgeriesBefore': hasSurgeriesBefore,
};

// Send the HTTP POST request
final http.Response response = await http.post(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(body),
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
print('Patient inserted successfully');
} else {
// Request failed
print('Failed to insert patient: ${response.statusCode}');
print('Response body: ${response.body}');
}
}

Future<Type?> getPatient({required int nationalId}) async {
  // Define the URL of your backend API with the nationalId as a query parameter
  final String url = 'http://192.168.1.9:8000/api/getPatient?nationalid=$nationalId';

  // Send the HTTP GET request
  final http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  // Check the response status
  if (response.statusCode == 200) {
    // Request was successful
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print('Patient data: $responseData');
    return Patient;
  } else {
    // Request failed
    print('Failed to get patient: ${response.statusCode}');
    print('Response body: ${response.body}');
    return null;
  }
}

// SignUp and Login Doctor
Future<void> insertDoctor({
required int nationalId,
required String name,
required String email,
required String dateOfBirth,
required String password,
required String certificateHash,
}) async {
// Define the URL of your backend API
final String url = 'http://192.168.1.9:8000/api/add-doctor';

// Create the request body
final Map<String, dynamic> body = {
'nationalId': nationalId,
'name': name,
'email': email,
'dateOfBirth': dateOfBirth,
'password': password,
'certificateHash': certificateHash,
};

// Send the HTTP POST request
final http.Response response = await http.post(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(body),
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
print('Doctor inserted successfully');
} else {
// Request failed
print('Failed to insert Doctor: ${response.statusCode}');
print('Response body: ${response.body}');
}
}

Future<void> getDoctor({required int nationalId}) async {
// Define the URL of your backend API with the nationalId as a query parameter
final String url = 'http://192.168.1.9:8000/api/getPatient?nationalid=$nationalId';

// Send the HTTP GET request
final http.Response response = await http.get(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
final Map<String, dynamic> responseData = jsonDecode(response.body);
print('Patient data: $responseData');
} else {
// Request failed
print('Failed to get patient: ${response.statusCode}');
print('Response body: ${response.body}');
}
}



// SignUp and Login Laboratory
Future<void> insertLaboratory({
required String name,
required String imageHash,
required String email,
required String password,
}) async {
// Define the URL of your backend API
final String url = 'http://192.168.1.9:8000/api/add-Laboratory';

// Create the request body
final Map<String, dynamic> body = {
'name': name,
'imageHash': imageHash,
'email': email,
'password': password,
};

// Send the HTTP POST request
final http.Response response = await http.post(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(body),
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
print('Laboratory inserted successfully');
} else {
// Request failed
print('Failed to insert Laboratory: ${response.statusCode}');
print('Response body: ${response.body}');
}
}

Future<void> getLaboratory({required int nationalId}) async {
// Define the URL of your backend API with the nationalId as a query parameter
final String url = 'http://192.168.1.9:8000/api/getPatient?nationalid=$nationalId';

// Send the HTTP GET request
final http.Response response = await http.get(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
final Map<String, dynamic> responseData = jsonDecode(response.body);
print('Patient data: $responseData');
} else {
// Request failed
print('Failed to get patient: ${response.statusCode}');
print('Response body: ${response.body}');
}
}


// Upload Prescription
// Show Prescriptions for specific nationalId
Future<void> insertPrescription({
required int nationalId,
required String imageUrl,
required String date,
}) async {
// Define the URL of your backend API
final String url = 'http://192.168.1.9:8000/api/Upload_Prescription';

// Create the request body
final Map<String, dynamic> body = {
'nationalId': nationalId,
'imageUrl': imageUrl,
'date': date,
};

// Send the HTTP POST request
final http.Response response = await http.post(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(body),
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
print('prescreption inserted successfully');
} else {
// Request failed
print('Failed to insert prescreption: ${response.statusCode}');
print('Response body: ${response.body}');
}
}

Future<void> getPrescriptionByNationalId({required int nationalId}) async {
// Define the URL of your backend API with the nationalId as a query parameter
final String url = 'http://192.168.1.9:8000/api/Show_Prescriptions?nationalid=$nationalId';

// Send the HTTP GET request
final http.Response response = await http.get(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
final Map<String, dynamic> responseData = jsonDecode(response.body);
print('prescreption data: $responseData');
} else {
// Request failed
print('Failed to get patient: ${response.statusCode}');
print('Response body: ${response.body}');
}
}

// Upload LabTest
// Show LabTest for specific nationalId


// Upload Surgery
// Show Surgery for specific nationalId

Future<void> insertSurgery({
required int nationalId,
required String imageUrl,
required String date,
}) async {
// Define the URL of your backend API
final String url = 'http://192.168.1.9:8000/api/add-Surgery';

// Create the request body
final Map<String, dynamic> body = {
'nationalId': nationalId,
'imageUrl': imageUrl,
'date': date,
};

// Send the HTTP POST request
final http.Response response = await http.post(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(body),
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
print('Surgery inserted successfully');
} else {
// Request failed
print('Failed to insert Surgery: ${response.statusCode}');
print('Response body: ${response.body}');
}
}


Future<void> getSurgery({required int nationalId}) async {
// Define the URL of your backend API with the nationalId as a query parameter
final String url = 'http://192.168.1.9:8000/api/getPatient?nationalid=$nationalId';

// Send the HTTP GET request
final http.Response response = await http.get(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
final Map<String, dynamic> responseData = jsonDecode(response.body);
print('Patient data: $responseData');
} else {
// Request failed
print('Failed to get patient: ${response.statusCode}');
print('Response body: ${response.body}');
}
}

//Upload XRay
// Show XRay for specific nationalId
Future<void> insertXRay({
required int nationalId,
required String imageUrl,
required String date,
}) async {
// Define the URL of your backend API
final String url = 'http://192.168.1.9:8000/api/add-XRay';

// Create the request body
final Map<String, dynamic> body = {
'nationalId': nationalId,
'imageUrl': imageUrl,
'date': date,
};

// Send the HTTP POST request
final http.Response response = await http.post(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(body),
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
print('XRay inserted successfully');
} else {
// Request failed
print('Failed to insert XRay: ${response.statusCode}');
print('Response body: ${response.body}');
}
}


Future<void> getXRay({required int nationalId}) async {
// Define the URL of your backend API with the nationalId as a query parameter
final String url = 'http://192.168.1.9:8000/api/getPatient?nationalid=$nationalId';

// Send the HTTP GET request
final http.Response response = await http.get(
Uri.parse(url),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
);

// Check the response status
if (response.statusCode == 200) {
// Request was successful
final Map<String, dynamic> responseData = jsonDecode(response.body);
print('XRay data: $responseData');
} else {
// Request failed
print('Failed to get XRay: ${response.statusCode}');
print('Response body: ${response.body}');
}
}


// Upload LabLipid
  // Show LabLipid for specific nationalId
  Future<void> insertLipid({
    required int nationalId,
    required int labId,
    required String imageUrl,
    required String status,
    required String cholesterolTotal,
    required String triglycerides,
    required String hdlCholesterol,
    required String ldlCholesterol,
    required String date,
  }) async {
    // Define the URL of your backend API
    final String url = 'http://192.168.1.9:8000/api/add-Lipid';

    // Create the request body
    final Map<String, dynamic> body = {
      'nationalId': nationalId,
      'labId': labId,
      'imageUrl': imageUrl,
      'status': status,
      'cholesterolTotal': cholesterolTotal,
      'triglycerides': triglycerides,
      'hdlCholesterol': hdlCholesterol,
      'ldlCholesterol': ldlCholesterol,
      'date': date,
    };

    // Send the HTTP POST request
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Request was successful
      print('Lipid inserted successfully');
    } else {
      // Request failed
      print('Failed to insert Lipid: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> getLipidByNationalId({required int nationalId}) async {
    // Define the URL of your backend API with the nationalId as a query parameter
    final String url = 'http://192.168.1.9:8000/api/Show_Prescriptions?nationalid=$nationalId';

    // Send the HTTP GET request
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Request was successful
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Lipid data: $responseData');
    } else {
      // Request failed
      print('Failed to get Lipid: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

//Add Child

//Edit Profile


}