import 'package:flutter/material.dart';
import 'BlockchainHelper.dart';
import 'models/Patient.dart';
import 'profileicon.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'BlockchainHelperr.dart';
import 'models/Medicine.dart';
import 'prescription_request_model.dart';

class MainScreen extends StatelessWidget {
  final Patient user;

  MainScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[50],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // actions: [
          //   ProfileIcon(user: user),
          // ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Prescriptions'),
              Tab(text: 'Medicines'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShowPrescriptions(user: user),
            ShowMedicines(user: user),
          ],
        ),
      ),
    );
  }
}

class ShowPrescriptions extends StatefulWidget {
  final Patient user;

  ShowPrescriptions({required this.user});

  @override
  _ShowPrescriptionsState createState() => _ShowPrescriptionsState();
}

class _ShowPrescriptionsState extends State<ShowPrescriptions> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<PrescriptionRequest> _prescriptions = [];
  final BlockchainHelper blockchainHelper = BlockchainHelper();
  @override
  void initState() {
    super.initState();
    blockchainHelper.getPrescriptionByNationalId(nationalId: widget.user.nationalId);
    _fetchPrescriptions();
  }

  Future<void> _fetchPrescriptions() async {
    List<PrescriptionRequest> prescriptions = await _databaseHelper.getPrescriptionRequests(widget.user.nationalId);
    setState(() {
      _prescriptions = prescriptions.where((prescription) => prescription.status != 'rejected').toList();
    });
  }

  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: PhotoView(
            imageProvider: FileImage(File(imageUrl)),
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: _prescriptions.isEmpty
          ? Center(
              child: Text('No prescriptions found'),
            )
          : ListView.builder(
              itemCount: _prescriptions.length,
              itemBuilder: (context, index) {
                PrescriptionRequest prescription = _prescriptions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prescription ${prescription.id}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Status: ${prescription.status}',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        prescription.imageUrl!.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () => _showFullImage(prescription.imageUrl.toString()),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ShowMedicines extends StatefulWidget {
  final Patient user;

  ShowMedicines({required this.user});

  @override
  _ShowMedicinesState createState() => _ShowMedicinesState();
}

class _ShowMedicinesState extends State<ShowMedicines> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    List<Medicine> medicines = await _databaseHelper.getMedicinesByNationalId(widget.user.nationalId);
    setState(() {
      _medicines = medicines;
    });
  }

  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: PhotoView(
            imageProvider: FileImage(File(imageUrl)),
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: _medicines.isEmpty
          ? Center(
              child: Text('No medicines found'),
            )
          : ListView.builder(
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                Medicine medicine = _medicines[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medicine ${medicine.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Dose: ${medicine.dose}',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                'Number of times per day: ${medicine.numOfTimes}',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        medicine.img!.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () => _showFullImage(medicine.img),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
