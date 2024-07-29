import 'UploadLab.dart';
//import 'user_model.dart';
import 'package:flutter/material.dart';
import 'Navigation.dart';
import 'profileicon.dart';
import 'UploadPrescription.dart';
import 'UploadingImage.dart';
import 'AppLocalizations.dart';
import 'models/Patient.dart';
import 'package:ass2/UploadImage.dart';

class UploadingPage extends StatefulWidget {
  final Patient user;

  UploadingPage({required this.user});

  @override
  State<UploadingPage> createState() => _UploadingPageState();
}

class _UploadingPageState extends State<UploadingPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final localizations = AppLocalizations.of(context); // Get the localization instance

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.cyan[50],
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                localizations.translate('Upload Options'),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Laila',
                  color: Color.fromRGBO(174, 98, 137, 1),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildMenuOption(
                          context,
                          localizations.translate('Upload Lab Tests'),
                          'assets/blood-tube.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadLab(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                        buildMenuOption(
                          context,
                          localizations.translate('Upload Prescription'),
                          'assets/prescription.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadPrescription(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Second Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildMenuOption(
                          context,
                          localizations.translate('Upload X-Rays'),
                          'assets/x-rays.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadImage(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                        buildMenuOption(
                          context,
                          localizations.translate('Upload Surgery Info'),
                          'assets/operating-room.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadingImage(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(user: widget.user),
    );
  }

  Widget buildMenuOption(BuildContext context, String text, String imagePath,
      VoidCallback onTap, Size screenSize, bool isSmallScreen) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSmallScreen ? screenSize.width * 0.45 : 180,
        height: isSmallScreen ? screenSize.height * 0.25 : 180,
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
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(imagePath, width: 90, height: 70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
