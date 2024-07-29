
import 'AppLocalizations.dart';
import 'Navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'QRCodeScanner.dart';
import 'ShowLabTests.dart';
import 'ShowSugeries.dart';
import 'ShowXrays.dart';
import 'Showprescriptions.dart';
import 'reports.dart';
import 'PatientNotifier.dart';
import 'models/Patient.dart';

class AllUploads extends StatefulWidget {
  final Patient user;

  AllUploads({required this.user});

  @override
  State<AllUploads> createState() => _AllUploadsState();
}

class _AllUploadsState extends State<AllUploads> {
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
                localizations.translate('Show Options'),
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
                          localizations.translate('Show Lab Tests'),
                          'assets/blood-tube.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowLabTests(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                        buildMenuOption(
                          context,
                          localizations.translate('Show Prescription'),
                          'assets/prescription.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen(user: widget.user)),
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
                          localizations.translate('Show X-Rays'),
                          'assets/x-rays.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowXrays(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                        buildMenuOption(
                          context,
                          localizations.translate('Show Surgery Info'),
                          'assets/operating-room.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowSurgeries(user: widget.user)),
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
