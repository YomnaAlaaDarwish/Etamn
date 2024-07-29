import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelperr.dart';
import 'LabTest_model.dart';
import 'Lab_model.dart';
//import 'models/Laboratory.dart';
import 'main.dart';

class LabProfile extends StatelessWidget {
  final Lab lab;

  LabProfile({required this.lab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('Lab Profile')),
        actions: [
          _buildHeader(context),
        ],
      ),
      body: FutureBuilder<List<LabTest>>(
        future: DatabaseHelper.instance.getLabTests(lab.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.translate('No lab tests found for') + ' ${lab.name}.'));
          } else {
            List<LabTest> labTests = snapshot.data!;
            // Filter out lab tests that are not 'pending'
            labTests.retainWhere((test) => test.status == 'pending');

            if (labTests.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.translate('No pending lab tests')));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('Welcome,'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  lab.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: labTests.length,
                    itemBuilder: (context, index) {
                      LabTest labTest = labTests[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(AppLocalizations.of(context)!.translate('Request') + ' ${index + 1}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  _updateLabTestStatus(labTest.labTestId, 'accepted', context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  _updateLabTestStatus(labTest.labTestId, 'rejected', context);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            _showFullImage(context, labTest.imageUrl);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
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

  void _updateLabTestStatus(int? labTestId, String newStatus, BuildContext context) async {
    if (labTestId == null) {
      return; // Handle case where labTestId is null (should not happen based on UI logic)
    }

    DatabaseHelper db = DatabaseHelper.instance;
    LabTest labTest = await db.getLabTestById(labTestId);

    if (labTest.status != 'pending') {
      // Handle case where lab test status is already accepted or rejected
      List<LabTest> updatedLabTests = await db.getLabTests(lab.id);
      // Filter out lab tests that are not 'pending'
      updatedLabTests.removeWhere((test) => test.status != 'pending');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('Lab test') + ' ${labTest.labTestId} ' + AppLocalizations.of(context)!.translate('status cannot be updated as it is already') + ' ${labTest.status}.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Refresh UI with filtered list after state change
      if (updatedLabTests.isEmpty) {
        Navigator.pop(context); // Navigate back if no lab tests left
      } else {
        // Update state to trigger rebuild
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LabProfile(lab: lab)));
      }
      return;
    }

    // If lab test status is 'pending', proceed with updating status
    labTest.status = newStatus;
    await db.updateLabTest(labTest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate('Lab test')+' '+ (newStatus == 'accepted' ? AppLocalizations.of(context)!.translate('accepted') : AppLocalizations.of(context)!.translate('rejected'))),
        duration: Duration(seconds: 2),
      ),
    );

    // Remove lab test from UI by filtering out the updated list
    List<LabTest> updatedLabTests = await db.getLabTests(lab.id);
    updatedLabTests.removeWhere((test) => test.labTestId == labTestId);

    // Refresh UI with updated list after state change
    if (updatedLabTests.isEmpty) {
      // Navigator.pop(context); // Navigate back if no lab tests left
    } else {
      // Update state to trigger rebuild with the updated list
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LabProfile(lab: lab)));
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Align widget for img87316612.png in the top right corner
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
}
