import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'BlockchainHelperr.dart';
import 'Lab_model.dart';
import 'LabTest_model.dart';
import 'models/Blood.dart';
import 'models/Lipid.dart';
import 'user_model.dart';
import 'profileicon.dart'; // Assuming this is a widget to display user profile information
import 'AppLocalizations.dart'; // Import localization
import 'models/Patient.dart';
class UploadLab extends StatefulWidget {
  final Patient user;

  UploadLab({required this.user});

  @override
  _UploadLabState createState() => _UploadLabState();
}

class _UploadLabState extends State<UploadLab> {
  File? _image;
  bool _isUploaded = false;
  String _message = '';
  Map<String, String> _extractedValues = {};
  String _largestWord = '';
   bool lipidcheck = false;
  bool Bloodcheck = false;

  final imagePicker = ImagePicker();

  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _isUploaded = true;
        _message = AppLocalizations.of(context).translate('Image uploaded successfully. Extracting text...');
      });
      await _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      Map<String, String> extractedValues = _parseRecognizedText(recognizedText.text);
      String largestWord = _findLargestWord(recognizedText);
      setState(() {
        _extractedValues = extractedValues;
        _largestWord = largestWord;
        _message = AppLocalizations.of(context).translate('Text extracted successfully.');
      });

      await _handleLabTestInsertion(largestWord, _image!.path);
    } catch (e) {
      print('Failed to recognize text: $e');
      setState(() {
        _message = AppLocalizations.of(context).translate('Failed to extract text. Please try again.');
      });
    } finally {
      textRecognizer.close();
    }
  }

Map<String, String> _parseRecognizedText(String text) {
  Map<String, String> LIPIDvalues = {
    'Cholesterol, Total': '',
    'Triglycerides': '',
    'HDL Cholesterol': '',
    'LDL Cholesterol': ''
  };
  Map<String, String> Bloodvalues = {
    'Haemoglobin': '',
    'Haematocrit': '',
    'RBCs': ''
  };

  List<String> lines = text.split('\n');
  List<double> extractedNumbers = [];

  RegExp exp = RegExp(r'(\d+\.?\d*)');
  for (var line in lines) {
    Match? match = exp.firstMatch(line);
    if (match != null) {
      extractedNumbers.add(double.parse(match.group(0) ?? ''));
    }
  }

  // Reset flags
  lipidcheck = false;
  Bloodcheck = false;

  for (var line in lines) {
    String word = line.toLowerCase();
    if (word.contains('lipid')) {
      lipidcheck = true;
    }
    if (word.contains('blood')) {
      Bloodcheck = true;
    }
  }

  if (extractedNumbers.isNotEmpty && lipidcheck) {
    int index = 0;
    for (var key in LIPIDvalues.keys) {
      if (index < extractedNumbers.length) {
        LIPIDvalues[key] = extractedNumbers[index].toString();
        index++;
      }
    }
    return LIPIDvalues;
  } else if (extractedNumbers.isNotEmpty && Bloodcheck) {
    int index = 0;
    for (var key in Bloodvalues.keys) {
      if (index < extractedNumbers.length) {
        Bloodvalues[key] = extractedNumbers[index].toString();
        index++;
      }
    }
    return Bloodvalues;
  }
  
  // Return LIPIDvalues by default if no valid condition is met
  return LIPIDvalues;
}


  String _findLargestWord(RecognizedText recognizedText) {
    String largestWord = '';
    double maxArea = 0;

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          double area = element.boundingBox.width * element.boundingBox.height;
          if (area > maxArea) {
            maxArea = area;
            largestWord = element.text;
          }
        }
      }
    }

    return largestWord;
  }

  Future<void> _handleLabTestInsertion(String largestWord, String imagePath) async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Lab> labs = await db.getLabs();
            // Check if lipid values are not empty
  for (Lab lab in labs) {
      if (lab.name.contains(largestWord) || largestWord.contains(lab.name) || largestWord == lab.name) {
        LabTest labTest = LabTest(
          userId: widget.user.nationalId, // Assuming user.id is reqired in LabTest model
          labId: lab.id,
          testName: largestWord,
          imageUrl: imagePath,
          status: 'pending',
        );
        await db.insertLabTest(labTest);

        setState(() {
          _message = '${AppLocalizations.of(context).translate('Lab test request added for lab:')} ${lab.name}';
        });
        return;

      }
      }
  if (Bloodcheck) {
    // Insert blood values into the database
    Blood blood = Blood(
      haemoglobin: _extractedValues['Haemoglobin'] ?? '',
      haematocrit: _extractedValues['Haematocrit'] ?? '',
      rbcs: _extractedValues['RBCs'] ?? '',
      imageUrl: imagePath,
      nationalId: widget.user.nationalId,
      status: 'pending',
      date: DateTime.now().toString(),
    );

      await db.insertBlood(blood);
      setState(() {
        _message = '${AppLocalizations.of(context).translate('Blood data added successfully.')}';
      });

      }
      if (lipidcheck) {
    // Assuming you have a Lipid model with appropriate fields
    Lipid lipid = Lipid(
      cholesterolTotal: _extractedValues['Cholesterol, Total'] ?? '',
      triglycerides: _extractedValues['Triglycerides'] ?? '',
      hdlCholesterol: _extractedValues['HDL Cholesterol'] ?? '',
      ldlCholesterol: _extractedValues['LDL Cholesterol'] ?? '',
      imageUrl: imagePath, nationalId:widget.user.nationalId , status:'pending', date: DateTime.now().toString(),
    );

    // Insert into database using your DatabaseHelper
    await db.insertLipid(lipid);

    setState(() {
      _message = '${AppLocalizations.of(context).translate('Lipid data added successfully.')}';
    });
  } 
    
    
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Get the localization instance

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
          ProfileIcon(user: widget.user), // Display user profile icon in AppBar
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text(
                localizations.translate('No Image'),
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
                    // if (_extractedValues.isNotEmpty) // Display extracted values if available
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       Text(
                    //         localizations.translate('Extracted Values:'),
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //           fontFamily: 'Laila',
                    //         ),
                    //       ),
                    //       SizedBox(height: 8),
                    //       Table(
                    //         border: TableBorder.all(),
                    //         children: _extractedValues.entries.map((entry) {
                    //           return TableRow(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(
                    //                   entry.key,
                    //                   style: TextStyle(fontFamily: 'Laila'),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(
                    //                   entry.value,
                    //                   style: TextStyle(fontFamily: 'Laila'),
                    //                 ),
                    //               ),
                    //             ],
                    //           );
                    //         }).toList(),
                    //       ),
                    //    ],
                    //  ),
                    // if (_largestWord.isNotEmpty) // Display largest word if found
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       SizedBox(height: 20),
                    //       Text(
                    //         localizations.translate('Largest Word:'),
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //           fontFamily: 'Laila',
                    //         ),
                    //       ),
                    //       SizedBox(height: 8),
                    //       Text(
                    //         _largestWord,
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontFamily: 'Laila',
                    //         ),
                       //   ),
                    //    ],
                   //   ),
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
        onPressed: getImage,
      ),
    );
  }
}
