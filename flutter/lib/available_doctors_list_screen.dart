import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppLocalizations.dart';
import 'models/Patient.dart';
import 'profileicon.dart';
import 'user_model.dart';

// Import your database helper and Doctor model
import 'BlockchainHelperr.dart';
import 'models/Doctor.dart';

class AvailableDoctorsListScreen extends StatefulWidget {
  final Patient user;

  AvailableDoctorsListScreen({required this.user});

  @override
  State<AvailableDoctorsListScreen> createState() =>
      _AvailableDoctorsListScreenState();
}

class _AvailableDoctorsListScreenState
    extends State<AvailableDoctorsListScreen> {
  
  String selectedDepartment = "All"; // State variable to store selected department
  List<String> departments = ["All"]; // List of departments including "All"
  List<Doctor> doctorsList = []; // List to store doctors fetched from database

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
  try {
    List<Doctor> doctors = await DatabaseHelper.instance.getDoctors(); // Replace with your database fetch method
    
    // Extract unique specialties and filter out null or empty values
    Set<String> specialties = doctors
        .map((doctor) => doctor.speciality.toString())
        .where((speciality) => speciality != 'null' && speciality.isNotEmpty)
        .toSet();

    setState(() {
      doctorsList = doctors;
      departments.addAll(specialties);
    });
  } catch (e) {
    print('Error fetching doctors: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.cyan[50], // Set background color to light baby blue
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              _buildNinety(context),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildThirtyThree(context),
                    SizedBox(height: 20),
                    _buildDoctorList(context), // Display list of doctors here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNinety(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        AppLocalizations.of(context)!.translate("Show Available Doctors"),
        style: TextStyle(
          fontSize: 24,
          color: Color.fromRGBO(174, 98, 137, 1),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDepartment(BuildContext context, String departmentName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDepartment == departmentName
            ? Colors.indigo
            : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedDepartment = departmentName;
        });
      },
      child: Text(
        departmentName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: selectedDepartment == departmentName ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildThirtyThree(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.translate("Filters:"),
            style: TextStyle(
              fontSize: 18,
              color:Color.fromRGBO(174, 98, 137, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
          DropdownButton<String>(
            value: selectedDepartment,
            onChanged: (String? newValue) {
              setState(() {
                selectedDepartment = newValue!;
              });
            },
            items: departments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(AppLocalizations.of(context)!.translate(value)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorList(BuildContext context) {
    // Filter doctors based on selectedDepartment
    List<Doctor> filteredDoctors = selectedDepartment == "All"
        ? doctorsList
        : doctorsList.where((doc) => doc.speciality == selectedDepartment).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredDoctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(filteredDoctors[index]);
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name, // Doctor name
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate("Specialty: ") + doctor.speciality.toString(), // Specialty
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            // Add other doctor details as needed
          ],
        ),
      ),
    );
  }
}
