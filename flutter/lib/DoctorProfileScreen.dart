import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'QRCodeScanner.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelperr.dart';
import 'main.dart';
import 'models/Doctor.dart';
import 'prescription_request_model.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String doctorName;
  final int doctorId;

  const DoctorProfileScreen({Key? key, required this.doctorName, required this.doctorId}) : super(key: key);

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  TextEditingController _specialtyController = TextEditingController();
  String? _specialty;

  @override
  void initState() {
    super.initState();
    _loadDoctorSpecialty();
  }

  Future<void> _loadDoctorSpecialty() async {
    DatabaseHelper db = DatabaseHelper.instance;
    Doctor? doctor = await db.getDoctorByNationalId(widget.doctorId);
    if (doctor != null && doctor.speciality != null) {
      setState(() {
        _specialty = doctor.speciality;
        _specialtyController.text = doctor.speciality!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('Doctor Profile')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>QRCodeScanner()));
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
          _buildHeader(context),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TabBar(
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.translate('Prescription Requests')),
                  Tab(text: AppLocalizations.of(context)!.translate('Edit Specialty')),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPrescriptionRequestsView(),
                    _buildEditSpecialtyView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionRequestsView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('Prescription Requests'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2),
            SizedBox(height: 10),
            FutureBuilder<List<PrescriptionRequest>>(
              future: DatabaseHelper.instance.getDoctorPrescriptionRequests(widget.doctorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)!.translate('No prescription requests found')));
                } else {
                  List<PrescriptionRequest> requests = snapshot.data!;
                  requests.retainWhere((request) => request.status == 'pending');

                  if (requests.isEmpty) {
                    return Center(child: Text(AppLocalizations.of(context)!.translate('No pending prescription requests')));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      PrescriptionRequest request = requests[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('${AppLocalizations.of(context)!.translate('Request')} ${index + 1}'),
                          subtitle: Text('${AppLocalizations.of(context)!.translate('Status')}: ${request.status}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  _updateRequestStatus(request.id, 'accepted', context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  _updateRequestStatus(request.id, 'rejected', context);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            _showFullImage(context, request.imageUrl);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditSpecialtyView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('Edit Specialty'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _specialtyController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('Specialty'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveSpecialty,
                icon: Icon(Icons.save),
                label: Text(AppLocalizations.of(context)!.translate('Save Specialty')),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.file(File(imageUrl)),
      ),
    );
  }

  void _updateRequestStatus(int? requestId, String newStatus, BuildContext context) async {
    if (requestId == null) {
      return;
    }

    DatabaseHelper db = DatabaseHelper.instance;
    PrescriptionRequest request = await db.getPrescriptionRequestById(requestId);

    if (request.status != 'pending') {
      List<PrescriptionRequest> updatedRequests = await db.getDoctorPrescriptionRequests(widget.doctorId);
      updatedRequests.removeWhere((req) => req.status != 'pending');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request ${request.id} status cannot be updated as it is already ${request.status}.'),
          duration: Duration(seconds: 2),
        ),
      );

      if (updatedRequests.isEmpty) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorProfileScreen(doctorName: widget.doctorName, doctorId: widget.doctorId)),
        );
      }
      return;
    }

    request.status = newStatus;
    await db.updatePrescriptionRequest(request);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate('Prescription Request is ') + (newStatus == 'accepted' ? AppLocalizations.of(context)!.translate('accepted') : AppLocalizations.of(context)!.translate('rejected'))),
        duration: Duration(seconds: 2),
      ),
    );

    List<PrescriptionRequest> updatedRequests = await db.getDoctorPrescriptionRequests(widget.doctorId);
    updatedRequests.removeWhere((req) => req.id == requestId);

    if (updatedRequests.isEmpty) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorProfileScreen(doctorName: widget.doctorName, doctorId: widget.doctorId)),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                _changeLanguage(context);
              },
              child: Container(
                height: 37,
                width: 20,
                child: Image.asset('assets/img87316612.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeLanguage(BuildContext context) {
    LocaleNotifier localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    Locale newLocale = localeNotifier.locale.languageCode == 'en' ? Locale('ar', '') : Locale('en', '');
    localeNotifier.setLocale(newLocale);
  }

  Future<void> _saveSpecialty() async {
    String specialty = _specialtyController.text;
    if (specialty.isNotEmpty) {
      DatabaseHelper db = DatabaseHelper.instance;
      await db.updateDoctorSpeciality(widget.doctorId, specialty);
      setState(() {
        _specialty = specialty;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('Specialty saved successfully')),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('Specialty cannot be empty')),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
