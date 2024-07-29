import 'dart:io';
import '/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'user_model.dart';
import 'profileicon.dart';
// Import the Medicine model
import 'BlockchainHelperr.dart'; // Import the DatabaseHelper
import 'models/Medicine.dart';
import 'models/Patient.dart';

class MedicinePageScreen extends StatefulWidget {
  final Patient user;

  MedicinePageScreen({required this.user});

  @override
  _MedicinePageScreenState createState() => _MedicinePageScreenState();
}

class _MedicinePageScreenState extends State<MedicinePageScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController doseController = TextEditingController();
  TextEditingController numOfTimesController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _extractedText = "";

  @override
  void dispose() {
    nameController.dispose();
    doseController.dispose();
    numOfTimesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Enter Name Of Medicine:"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.translate("Enter Dose:"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: doseController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.translate("Enter Number Of Times:"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: numOfTimesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveMedicine();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromRGBO(83, 101, 167, 1),
                        elevation: 6,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate("Confirm"),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  AppLocalizations.of(context)!.translate("If You Want To Take An Image Instead"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _takePhoto(context),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 80, color: Colors.grey[600])
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 20),
                if (_extractedText.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate("Extracted Text:"),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(_extractedText),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _takePhoto(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(_imageFile!);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String largestWord = '';
    double maxFontSize = 0;

    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        for (var word in line.elements) {
          if (word.boundingBox.height > maxFontSize) {
            maxFontSize = word.boundingBox.height;
            largestWord = word.text;
          }
        }
      }
    }

    setState(() {
      _extractedText = largestWord;
      nameController.text = largestWord;
    });

    textRecognizer.close();
  }

  void _saveMedicine() async {
    final medicine = Medicine(
      nationalId: widget.user.nationalId,
      name: nameController.text,
      img: _imageFile?.path ?? '',
      dose: doseController.text,
      numOfTimes: int.tryParse(numOfTimesController.text) ?? 0,
    );

    // Save medicine to the database
    await DatabaseHelper.instance.insertMedicine(medicine);

    // Clear the form
    nameController.clear();
    doseController.clear();
    numOfTimesController.clear();
    setState(() {
      _imageFile = null;
      _extractedText = "";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.translate("Medicine saved successfully!"))),
    );
  }
}