import '/models/Patient.dart';
import 'package:flutter/material.dart';
import 'AllUploads.dart';
import 'QRCodeScanner.dart';
import 'reports.dart';
import 'showuploads.dart';
import 'user_model.dart';
import 'BlockchainHelperr.dart'; // Ensure you import the DatabaseHelper

class ShowForDoctor extends StatefulWidget {
  final String scannedData;

  ShowForDoctor({required this.scannedData});

  @override
  _ShowForDoctorState createState() => _ShowForDoctorState();
}

class _ShowForDoctorState extends State<ShowForDoctor> {
  late Future<Patient?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserDetails(widget.scannedData);
  }

  Future<Patient?> _fetchUserDetails(String scannedData) async {
    int userId = int.parse(scannedData);
    return await DatabaseHelper.instance.getPatientByNationalId(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Uploads'),
      ),
      body: Center(
        child: FutureBuilder<Patient?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('User not found');
            } else {
              Patient user = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User ID: ${user.nationalId}'),
                  Text('Name: ${user.name}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllUploads(user: user),
                        ),
                      );
                    },
                    child: Text('Show Reports'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScanner(),
                        ),
                      );
                    },
                    child: Text('Scan Another QR Code'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
