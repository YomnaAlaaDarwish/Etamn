import 'dart:io';
import 'package:flutter/material.dart';
import 'models/Lipid.dart';
import 'profileicon.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelperr.dart';
import 'user_model.dart';
import 'LabTest_model.dart';
import 'prescription_request_model.dart';
import 'models/Patient.dart';
import 'models/Surgery.dart';

class Reports extends StatefulWidget {
  final Patient user;

  Reports({required this.user});

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<PrescriptionRequest> _prescriptionRequests = [];
  List<LabTest> _labTests = [];
  List<Lipid> _lipids = [];
  List<Surgery> _surgeries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<PrescriptionRequest> prescriptions =
          await DatabaseHelper.instance.getUserPrescriptionRequests(widget.user.nationalId);
      List<LabTest> labTests =
          await DatabaseHelper.instance.getUserLabTests(widget.user.nationalId);
      List<Lipid> lipids =
          await DatabaseHelper.instance.getLipidsByNationalId(widget.user.nationalId);
      List<Surgery> surgeries =
          await DatabaseHelper.instance.getSurgeryByNationalId(widget.user.nationalId);

      setState(() {
        _prescriptionRequests = prescriptions;
        _labTests = labTests;
        _lipids = lipids;
        _surgeries = surgeries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _openImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ProfileIcon(user: widget.user),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle("Prescription Requests:", _prescriptionRequests.isEmpty),
                      _buildPrescriptionList(),
                      _buildSectionTitle("Lab Tests:", _labTests.isEmpty),
                      _buildLabTestList(),
                      _buildSectionTitle("Lipid Tests:", _lipids.isEmpty),
                      _buildLipidList(),
                      _buildSectionTitle("Surgeries:", _surgeries.isEmpty),
                      _buildSurgeryList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, bool isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate(title),
          style: TextStyle(
            fontFamily: 'Laila',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(174, 98, 137, 1),
          ),
        ),
        SizedBox(height: 8),
        if (isEmpty) Center(child: Text(AppLocalizations.of(context)!.translate("No " + title.toLowerCase()))),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPrescriptionList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _prescriptionRequests.length,
      itemBuilder: (context, index) {
        PrescriptionRequest request = _prescriptionRequests[index];
        return ListTile(
          leading: Icon(Icons.description, color: Colors.blueGrey),
          title: Text(
            AppLocalizations.of(context)!.translate("Prescription") + ' ${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            '${AppLocalizations.of(context)!.translate("Status:")} ${request.status}',
            style: TextStyle(
              color: request.status == 'accepted'
                  ? Colors.green
                  : request.status == 'rejected'
                      ? Colors.red
                      : Colors.black,
            ),
          ),
          trailing: request.imageUrl.isNotEmpty
              ? GestureDetector(
                  onTap: () => _openImage(request.imageUrl),
                  child: Image.file(File(request.imageUrl)),
                )
              : null,
        );
      },
    );
  }

  Widget _buildLabTestList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _labTests.length,
      itemBuilder: (context, index) {
        LabTest labTest = _labTests[index];
        return ListTile(
          leading: Icon(Icons.science, color: Colors.blueGrey),
          title: Text(
            '${AppLocalizations.of(context)!.translate("Lab Test")} ${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            '${AppLocalizations.of(context)!.translate("Status:")} ${labTest.status}\n'
            '${AppLocalizations.of(context)!.translate("Lab Name:")} ${labTest.testName}',
            style: TextStyle(
              color: labTest.status == 'accepted'
                  ? Colors.green
                  : labTest.status == 'rejected'
                      ? Colors.red
                      : Colors.black,
            ),
          ),
          trailing: labTest.imageUrl.isNotEmpty
              ? GestureDetector(
                  onTap: () => _openImage(labTest.imageUrl),
                  child: Image.file(File(labTest.imageUrl)),
                )
              : null,
        );
      },
    );
  }

  Widget _buildLipidList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _lipids.length,
      itemBuilder: (context, index) {
        Lipid lipid = _lipids[index];
        return ListTile(
          leading: Icon(Icons.local_hospital, color: Colors.blueGrey),
          title: Text(
            '${AppLocalizations.of(context)!.translate("Lipid Test")} ${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            '${AppLocalizations.of(context)!.translate("Cholesterol Total:")} ${lipid.cholesterolTotal}\n'
            '${AppLocalizations.of(context)!.translate("Triglycerides:")} ${lipid.triglycerides}\n'
            '${AppLocalizations.of(context)!.translate("HDL Cholesterol:")} ${lipid.hdlCholesterol}\n'
            '${AppLocalizations.of(context)!.translate("LDL Cholesterol:")} ${lipid.ldlCholesterol}',
          ),
        );
      },
    );
  }

  Widget _buildSurgeryList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _surgeries.length,
      itemBuilder: (context, index) {
        Surgery surgery = _surgeries[index];
        return ListTile(
          leading: Icon(Icons.healing, color: Colors.blueGrey),
          title: Text(
            '${AppLocalizations.of(context)!.translate("Surgery")} ${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: surgery.imageUrl != null
              ? GestureDetector(
                  onTap: () => _openImage(surgery.imageUrl!),
                  child: Image.file(File(surgery.imageUrl!)),
                )
              : null,
        );
      },
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imagePath;

  ImageScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
