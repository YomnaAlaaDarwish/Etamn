import 'AppLocalizations.dart';

import 'Navigation.dart';
import 'user_model.dart';
import 'package:flutter/material.dart';
import 'available_labslist_screen.dart';
import 'available_doctors_list_screen.dart';
import 'profileicon.dart';
import 'models/Patient.dart';

import 'models/Patient.dart';
class DoctorOrLabScreen extends StatelessWidget {
  final Patient user;

  DoctorOrLabScreen({required this.user});

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
        // actions: [
        //   ProfileIcon(user: user), // This adds the ProfileIcon widget to the AppBar
        // ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMenuOption(
                context,
                AppLocalizations.of(context)!.translate("Show Available Doctors"),
                'assets/img_5996026_1.png',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AvailableDoctorsListScreen(user: user)),
                  );
                },
                screenSize,
                isSmallScreen,
              ),
              SizedBox(height: 60),
              buildMenuOption(
                context,
                AppLocalizations.of(context)!.translate("Show Available Laboratories"),
                'assets/img_9599668_1.png',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AvailableLabsListScreen(user: user)),
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
