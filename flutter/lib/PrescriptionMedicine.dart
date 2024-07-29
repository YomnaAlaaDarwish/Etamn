import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart'; // Replace with your AppLocalizations import
import 'BlockchainHelperr.dart';
import 'models/Medicine.dart';
import 'models/Patient.dart';
import 'user_model.dart';
import 'profileicon.dart';
import 'MedicineImage.dart';
import 'local_notifications.dart';
import 'all_notifications_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Import the ML Kit package

class PrescriptionMedicine extends StatefulWidget {
  final Patient user;

  PrescriptionMedicine({required this.user});


  @override
  _PrescriptionMedicineState createState() => _PrescriptionMedicineState();
}

class _PrescriptionMedicineState extends State<PrescriptionMedicine> {
  int frequency = 1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  bool _imageSelected = false;
  File? _image;
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  void incrementFrequency() {
    setState(() {
      frequency++;
    });
  }

  void decrementFrequency() {
    setState(() {
      if (frequency > 1) {
        frequency--;
      }
    });
  }

  Future<void> extractMedicineName(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String largestWord = '';
    double largestFontSize = 0;

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          final fontSize = element.boundingBox.height;
          if (fontSize > largestFontSize) {
            largestFontSize = fontSize;
            largestWord = element.text;
          }
        }
      }
    }

    setState(() {
      nameController.text = largestWord;
    });

    textRecognizer.close();
  }

  Future<void> saveMedicine() async {
    final medicineName = nameController.text;
    final medicineDose = doseController.text;

    if (medicineName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('enter_medicine_name'))),
      );
      return;
    }
    Medicine newMedicine = Medicine(
      name: medicineName,
      dose: medicineDose,
      numOfTimes: frequency,
      nationalId: widget.user.nationalId,
      img: _image != null ? _image!.path : '',
    );
    await _databaseHelper.insertMedicine(newMedicine);
    String medicineReminderTitle = AppLocalizations.of(context).translate('medicine_reminder_title');
    String medicineReminderBody = AppLocalizations.of(context).translate('medicine_reminder_body');
    medicineReminderBody = medicineReminderBody.replaceAll('{medicineName}', medicineName);
    medicineReminderBody = medicineReminderBody.replaceAll('{frequency}', frequency.toString());
    medicineReminderBody = medicineReminderBody.replaceAll('{medicineDose}', medicineDose);

    LocalNotifications.showPeriodicNotification(
      title: medicineReminderTitle,
      body: medicineReminderBody,
      payload: "Scheduled medicine reminder",
      medicineName: medicineName,
      medicineDose: medicineDose,
      userId: widget.user.nationalId.toString(),
      frequency: frequency,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).translate('medicine_saved_success'))),

    );

    // Clear fields and reset state after saving
    setState(() {
      nameController.clear();
      doseController.clear();
      _imageSelected = false;
      _image = null;
      frequency = 1; // Reset frequency to 1
    });
  }

  void cancelAllNotifications() {
    LocalNotifications.cancelAll();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).translate('all_notifications_canceled'))),
    );
  }

  void showAllNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationsPage(userId: widget.user.nationalId,)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ProfileIcon(user: widget.user),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('enter_medicine_name_label'),
              style: TextStyle(
                fontSize: 20,
                color: Colors.indigo[900],
                fontFamily: 'Laila',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('medicine_name_hint'),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('take_image_instead'),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Laila',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.camera_alt_outlined),
                  mini: true,
                  shape: StadiumBorder(),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicineImage(user: widget.user)),
                    );
                    if (result != null && result is File) {
                      setState(() {
                        _imageSelected = true;
                        _image = result;
                      });
                      await extractMedicineName(result);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            _imageSelected
                ? Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).translate('enter_medicine_dose_label'),
              style: TextStyle(
                fontSize: 20,
                color: Colors.indigo[900],
                fontFamily: 'Laila',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: TextFormField(
                controller: doseController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('medicine_dose_hint'),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).translate('number_of_times_label'),
              style: TextStyle(
                fontSize: 20,
                color: Colors.indigo[900],
                fontFamily: 'Laila',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: decrementFrequency,
                  icon: Icon(Icons.remove_circle, color: Colors.deepPurple),
                ),
                Text(
                  "$frequency",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: incrementFrequency,
                  icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveMedicine,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(83, 101, 167, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).translate('save_medicine_button'),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => showAllNotifications(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(83, 101, 167, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).translate('show_all_notifications_button'),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
