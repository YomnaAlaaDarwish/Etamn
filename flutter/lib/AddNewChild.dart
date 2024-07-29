import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelper.dart';
import 'BlockchainHelperr.dart';
import 'Surgeries.dart';
import 'ChildList.dart';
import 'models/Patient.dart';

class AddNewChild extends StatefulWidget {
  final Patient patient;
  final String? surgeryInfo;
  final Function(Patient) onChildAdded;

  const AddNewChild({
    Key? key,
    this.surgeryInfo,
    required this.onChildAdded,
    required this.patient,
  }) : super(key: key);

  @override
  State<AddNewChild> createState() => _AddNewChildState();
}

class _AddNewChildState extends State<AddNewChild> {

  String selectedOption = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  final _formKey = GlobalKey<FormState>();

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
    return Container(
      width: 350,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(255, 255, 255, 0.68),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.translate('New Child'),
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
            _buildTextField( AppLocalizations.of(context)!.translate('Name'), nameController,  AppLocalizations.of(context)!.translate('Please enter Name')),
            SizedBox(height: 10),
            _buildTextField( AppLocalizations.of(context)!.translate('National ID'), nationalIdController,  AppLocalizations.of(context)!.translate('Please enter National ID')),
            SizedBox(height: 10),
            _buildDateOfBirthField(),
            SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.translate('Email'), emailController, AppLocalizations.of(context)!.translate('Please enter Email')),
            SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.translate('Create Password'), passwordController, AppLocalizations.of(context)!.translate('Please enter Password')),
            SizedBox(height: 10),
            _buildTextField(AppLocalizations.of(context)!.translate('Confirm Password'), confirmPasswordController, AppLocalizations.of(context)!.translate('Please enter Confirm Password')),
            SizedBox(height: 10),
            _buildRadioButtons(),
            SizedBox(height: 10),
            _buildSubmitButton(),
            if (widget.surgeryInfo != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('Surgery Info: ${widget.surgeryInfo}'),
                  style: TextStyle(
                    fontFamily: 'Laila',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String validationMessage) {
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
            decoration: InputDecoration(border: InputBorder.none),
            validator: (value) {
              if (label == AppLocalizations.of(context)!.translate('National ID')) {
                // Validate National ID should be exactly 14 digits
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.translate('Please enter National ID');
                } else if (value.length != 14 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return AppLocalizations.of(context)!.translate('National ID must be 14 digits');
                }
                return null;

              } else if (label == AppLocalizations.of(context)!.translate('Date Of Birth')) {
                // Validate Date of Birth format (you can add more specific validations if needed)
                // if (value == null || value.isEmpty || !DateTime.tryParse(value)!.isBefore(DateTime.now())) {
                //   return validationMessage;
                // }
              } else if (label == AppLocalizations.of(context)!.translate('Email')) {
                // Validate Email format
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.translate('Please enter Email');
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return AppLocalizations.of(context)!.translate('Please enter a valid email address');
                }
                return null;
              } else if (label == AppLocalizations.of(context)!.translate('Create Password')) {
                // Validate Password should be at least 8 characters
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.translate('Please enter Password');
                } else if (value.length < 8) {
                  return AppLocalizations.of(context)!.translate( 'Password must be at least 8 characters long');
                }
                return null;
              } else if (label == AppLocalizations.of(context)!.translate('Confirm Password')) {
                // Validate Confirm Password should match Create Password
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.translate('Please enter Confirm Password');
                } else if (value != passwordController.text) {
                  return AppLocalizations.of(context)!.translate('Passwords do not match');
                }
                return null;
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate( 'Date Of Birth'),
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
        SizedBox(height: 8),
        Container(
          width: 317,
          height: 47,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextFormField(
            controller: dobController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              hintText: 'YYYY-MM-DD',
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter Date Of Birth');
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('Has Surgeries Before'),
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
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.translate('Upload Surgery Info'),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          // Navigate to the ChildList page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChildList(patient: widget.patient)),
          );
          print("Form validated");
          // Save the new child to the database
          Patient child = Patient(
            nationalId: int.parse(nationalIdController.text),
            name: nameController.text,
            dateOfBirth: dobController.text,
            email: emailController.text,
            password: passwordController.text,
            hasSurgeriesBefore: selectedOption == 'Yes' ? 'Yes' : 'No',
            parentId: widget.patient.nationalId,
          );
          await DatabaseHelper.instance.addChild(child);
          print("Child added to DB");
          Map<String, dynamic> newchild = {
            'name': nameController.text,
            'nationalId': nationalIdController.text,
            'dob': dobController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'surgeryInfo': widget.surgeryInfo ?? '',
            'parentId': widget.patient.nationalId,
          };
          // Notify the parent widget about the new child
          widget.onChildAdded(child);



          print("Navigating to ChildList");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(83, 101, 167, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.translate('Submit'),
        style: TextStyle(
          fontFamily: 'Laila',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}