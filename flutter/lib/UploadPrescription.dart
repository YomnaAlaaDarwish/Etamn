import 'Navigation.dart';
import 'PrescriptionImage.dart';
import 'user_model.dart';
import 'package:flutter/material.dart';
import 'PrescriptionMedicine.dart';
import 'profileicon.dart';
import 'AppLocalizations.dart';
import 'models/Patient.dart';
// Import localization

class UploadPrescription extends StatelessWidget {
  final Patient user;

  UploadPrescription({required this.user});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ProfileIcon(user: user), // This adds the ProfileIcon widget to the AppBar
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMenuOption(
                context,
                AppLocalizations.of(context).translate('Prescription Image'),
                'assets/prescription.png',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrescriptionImage(user: user)),
                  );
                },
                screenSize,
                isSmallScreen,
              ),
              SizedBox(height: 60),
              buildMenuOption(
                context,
                AppLocalizations.of(context).translate('Prescription Medicine'),
                'assets/medicine.png',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrescriptionMedicine(user: user)),
                  );
                },
                screenSize,
                isSmallScreen,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(user: user),
    );
  }

  Widget buildMenuOption(BuildContext context, String text, String imagePath, VoidCallback onTap, Size screenSize, bool isSmallScreen) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Color.fromRGBO(158, 169, 214, 0.87),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(imagePath, width: 90, height: 80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
