import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'BlockchainHelper.dart';
import 'LoginLabs.dart';
import 'LoginDoctors.dart';
import 'dart:io';
import 'BlockchainHelperr.dart';
import 'models/Laboratory.dart';
import 'AppLocalizations.dart';
import'package:ass2/Lab_model.dart';

class SignUpLabs extends StatefulWidget {
  const SignUpLabs({super.key});

  @override
  State<SignUpLabs> createState() => _SignUpLabsState();
}

class _SignUpLabsState extends State<SignUpLabs> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? _image;
  String _extractedText = '';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer();
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extractedText = recognizedText.text;
      setState(() {
        _extractedText = extractedText;
      });
    } catch (e) {
      print('Failed to recognize text: $e');
      setState(() {
        _extractedText = 'Failed to extract text. Please try again.';
      });
    } finally {
      textRecognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(171, 210, 231, 0.5644),
              Color.fromRGBO(8, 54, 68, 0.1577),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        width: 350,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(255, 255, 255, 0.68),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.translate('Sign Up'),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(174, 98, 137, 1),
                  shadows: [
                    Shadow(
                      offset: Offset(4, 4),
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2),
            _buildTextField(AppLocalizations.of(context)!.translate('Name'), _nameController, validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter Name');
              }
              return null;
            }),

            SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.translate('Email'), _emailController, validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter Email');
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return AppLocalizations.of(context)!.translate( 'Please enter a valid email address');
              }
              return null;
            }),
            SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.translate('Create Password'), _passwordController, obscureText: true, validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter Password');
              } else if (value.length < 8) {
                return AppLocalizations.of(context)!.translate('Password must be at least 8 characters long');
              }
              return null;
            }),
            SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.translate('Confirm Password'), _confirmPasswordController, obscureText: true, validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter Confirm Password');
              } else if (value != _passwordController.text) {
                return AppLocalizations.of(context)!.translate('Passwords do not match');
              }
              return null;
            }),
            SizedBox(height: 10),
            _buildUploadSection(),
            if (_extractedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Extracted Text: $_extractedText',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Laila',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Laila',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(83, 101, 167, 1),
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
        ),
        Container(
          width: 317,
          height: 47,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }



  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.translate('Upload the Accreditation certificate'),
              style: TextStyle(
                fontFamily: 'Laila',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(83, 101, 167, 1),
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
              ),
            ),
            SizedBox(width: 1),
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Image.asset('assets/upload.png', width: 40, height: 40)
                  : Image.file(_image!, width: 40, height: 40),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _image != null) {
              // Extract text from the uploaded image
              await _extractTextFromImage();

              // Gather form data
              String name = _nameController.text.trim();
              String email = _emailController.text.trim();
              String password = _passwordController.text.trim();
              String accreditationText = "ss";

              // Insert data into the database
              try {
                DatabaseHelper databaseHelper = DatabaseHelper.instance;
                final BlockchainHelper blockchainHelper = BlockchainHelper();
                blockchainHelper.insertLaboratory(name: _nameController.text, imageHash: _image!.path, email: _emailController.text, password: _passwordController.text);
                await databaseHelper.insertLab(Lab(
                  id: 7,
                  name: name,
                ));

                // Navigate to the login screen or any other screen upon successful signup
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginLabs()),
                );
              } catch (e) {
                print('Error inserting data: $e');
                // Handle error or display an error message
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(83, 101, 167, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.translate( 'Submit'),
            style: TextStyle(
              fontFamily: 'Laila',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: SignUpLabs(),
  ));
}
