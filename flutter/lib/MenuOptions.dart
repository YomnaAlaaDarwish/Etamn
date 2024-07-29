import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'showuploads.dart';
import 'AppLocalizations.dart';
import 'reports.dart';
import 'doctor_or_lab_screen.dart';
import 'medicine_page_screen.dart';
import 'profileicon.dart';
import 'Navigation.dart';
import 'user_model.dart';
import 'models/Patient.dart';
import 'PatientNotifier.dart';

class MenuOptions extends StatefulWidget {
   final Patient user;

   MenuOptions({required this.user});
  @override
  State<MenuOptions> createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var isSmallScreen = screenSize.width < 400;

    // Access the patient data from the PatientNotifier
    //final patientNotifier = Provider.of<PatientNotifier>(context);
    //final patient = patientNotifier.patient;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        actions: [
          ProfileIcon(user: widget.user),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.cyan[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(
                AppLocalizations.of(context)!.translate('Menu Options'),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
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
                          AppLocalizations.of(context)!.translate('Show Uploads'),
                          'assets/upload.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUploadsPage(user: widget.user,
                                   // Replace with actual scanned data if applicable
                                ),
                              ),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                        buildMenuOption(
                          context,
                          AppLocalizations.of(context)!.translate('Personal Report'),
                          'assets/report.png',
                              () {
                            Navigator.push(
                             context,
                            MaterialPageRoute(
                                builder: (context) => Reports(user: widget.user)),
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
                          AppLocalizations.of(context)!.translate('Feeling Ill ?'),
                          'assets/feelingill.png',
                              () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorOrLabScreen(user: widget.user)),
                            );
                          },
                          screenSize,
                          isSmallScreen,
                        ),
                        buildMenuOption(
                          context,
                          AppLocalizations.of(context)!.translate('Storing Medicine'),
                          'assets/medicine.png',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MedicinePageScreen(user: widget.user)),
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
                  fontSize: 24,
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
