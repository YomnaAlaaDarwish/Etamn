import 'package:provider/provider.dart';

import 'AppLocalizations.dart';
import 'PatientNotifier.dart';
import 'main.dart';
import 'user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ChildList.dart';
import 'EditInformation.dart';
import 'LoginScreen.dart';
import 'Navigation.dart';
import 'profileicon.dart';
import 'QRCodePage.dart';
import 'models/Patient.dart';

class Profile extends StatefulWidget {

  final Patient user;
  Profile({required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    //final patientNotifier = Provider.of<PatientNotifier>(context);
    //final user = patientNotifier.patient;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: Text(widget.user.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
        // ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.cyan[50],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(
                context,
            AppLocalizations.of(context)!.translate('Edit Information'),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditPatientScreen(patient: widget.user)),
                  );
                },
              ),

              SizedBox(height: 20),
              buildButton(
                context,
                AppLocalizations.of(context)!.translate('Child Accounts'),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChildList(patient: widget.user)),
                  );
                },
              ),
              SizedBox(height: 20),
              buildButton(
                context,
                AppLocalizations.of(context)!.translate('Change Language'),
                    () {
                  _changeLanguage(context);
                },
              ),

              SizedBox(height: 20),
              buildButton(
                context,
                AppLocalizations.of(context)!.translate('QR Code'),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QRCodePage(user: widget.user)),
                      );

                    },
              ),
              SizedBox(height: 20),
              buildButton(
                context,
                AppLocalizations.of(context)!.translate('Sign out'),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPageScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(user: widget.user),
    );
  }
  void _changeLanguage(BuildContext context) {
    LocaleNotifier localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    Locale newLocale = localeNotifier.locale.languageCode == 'en' ? Locale('ar', '') : Locale('en', '');
    localeNotifier.setLocale(newLocale);
  }
  Widget buildButton(BuildContext context, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromRGBO(83, 101, 167, 1),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Laila',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}




