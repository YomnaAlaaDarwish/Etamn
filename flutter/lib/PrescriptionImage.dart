import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'BlockchainHelper.dart';
import 'BlockchainHelperr.dart';
// import 'doctor_model.dart';
import 'models/Doctor.dart';
import 'models/Patient.dart';
import 'prescription_request_model.dart';
import 'user_model.dart';
import 'profileicon.dart';
import 'AppLocalizations.dart';

class PrescriptionImage extends StatefulWidget {
  final Patient user;

  PrescriptionImage({required this.user});

  @override
  State<PrescriptionImage> createState() => _PrescriptionImageState();
}

class _PrescriptionImageState extends State<PrescriptionImage> {
  File? _image;
  bool _isUploaded = false;
  String _message = '';
  List<List<String>> _extractedRows = [];
  String? _doctorName;

  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  Future<void> _getImage() async {
    final XFile? imageFile =
    await _imagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
        _isUploaded = true;
        _message = AppLocalizations.of(context).translate('imageUploadedSuccessfully');
      });
      await _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    try {
      final RecognizedText recognizedText =
      await _textRecognizer.processImage(inputImage);
      List<List<String>> extractedRows =
      _parseRecognizedText(recognizedText.text);

      // Check if any doctor name from the database is present in the extracted text
      List<Doctor> doctors = await DatabaseHelper.instance.getDoctors();
      Doctor? matchedDoctor =
      _findDoctorInExtractedText(extractedRows, doctors);

      if (matchedDoctor != null) {
        // Insert the image into the prescription requests
        String imageUrl = _image!.path; // Use the correct path here
        PrescriptionRequest request = PrescriptionRequest(
          userId: widget.user.nationalId,
          doctorId: matchedDoctor.nationalId,
          imageUrl: imageUrl,
          status: 'pending',
        );

        // Insert prescription request into database
        await DatabaseHelper.instance.insertPrescriptionRequest(request);
        final BlockchainHelper blockchainHelper = BlockchainHelper();
        blockchainHelper.insertPrescription(nationalId: widget.user.nationalId, imageUrl: imageUrl, date: DateTime.now().toLocal().toIso8601String().split('T').first,);

        setState(() {
          _message = AppLocalizations.of(context).translate('prescriptionRequestAdded').replaceAll('%s', matchedDoctor.name);
        });
      } else {
        setState(() {
          _message = AppLocalizations.of(context).translate('doctorNotRecognized');
        });
      }

      setState(() {
        _extractedRows = extractedRows;
        _doctorName = matchedDoctor?.name;
      });
    } catch (e) {
      print('Failed to recognize text: $e');
      setState(() {
        _message = AppLocalizations.of(context).translate('failedToExtractText');
      });
    }
  }

  List<List<String>> _parseRecognizedText(String text) {
    List<String> lines = text.split('\n');
    List<List<String>> rows = [];
    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        rows.add(line.split(RegExp(r'\s{2,}')));
      }
    }
    return rows;
  }

  Doctor? _findDoctorInExtractedText(
      List<List<String>> extractedRows, List<Doctor> doctors) {
    for (var row in extractedRows) {
      String lowerCaseRow = row.join(' ').toLowerCase();
      for (Doctor doctor in doctors) {
        if (lowerCaseRow.contains(doctor.name.toLowerCase())) {
          return doctor;
        }
      }
    }
    return null;
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
        // actions: [
        //   ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
        // ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text(
                AppLocalizations.of(context).translate('noImage'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Laila',
                ),
              )
                  : Image.file(_image!),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Laila',
                        color: _isUploaded ? Colors.green : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    // if (_doctorName != null)
                    //   Text(
                    //     "${AppLocalizations.of(context).translate('extractedText')} $_doctorName",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       fontFamily: 'Laila',
                    //     ),
                    //   ),
                    SizedBox(height: 10),
                    if (_extractedRows.isNotEmpty) // Check if text is extracted
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        //  Text(
                        //     "${AppLocalizations.of(context).translate('extractedText')}",
                        //     style: TextStyle(
                        //        fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //       fontFamily: 'Laila',
                        //     ),
                        //   
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[200],
        child: Icon(Icons.camera_alt_outlined),
        onPressed: _getImage,
      ),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }
}
