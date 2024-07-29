import 'dart:io';
import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelper.dart';
import 'Surgeries.dart';
import 'LoginScreen.dart';
import 'BlockchainHelperr.dart';
import 'user_model.dart';
import 'models/Patient.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedOption = '';
  String? surgeryInfo;
  File? surgeryImage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final BlockchainHelper blockchainHelper = BlockchainHelper();

  Future<void> _insertPatient() async {
    if (_formKey.currentState!.validate()) {
      final patient = Patient(
        nationalId: int.parse(nationalIdController.text),
        name: nameController.text,
        dateOfBirth: dobController.text,
        email: emailController.text,
        password: passwordController.text,
        hasSurgeriesBefore: 'yes',
      );
      print('Not added');
      await DatabaseHelper.instance.insertPatient(patient);
      print('added');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Patient inserted successfully'),
      ));

    }
  }

  Future<void> _signup(BuildContext context) async {
    final dbHelper = DatabaseHelper.instance;
    User u = User(
      nationalId: 11,
      name: 'hh',
      dateOfBirth: 'hh',
      email: 'hh',
      password: 'hh',
      hasSurgeriesBefore: 'hh',
    );
    await dbHelper.insertUser(u);

    if (_formKey.currentState?.validate() ?? false) {
      User newUser = User(
        nationalId: int.parse(nationalIdController.text),
        name: nameController.text,
        dateOfBirth: dobController.text,
        email: emailController.text,
        password: passwordController.text,
        hasSurgeriesBefore: selectedOption == 'Yes' ? 'Yes' : 'No',
      );

      await dbHelper.insertUser(newUser);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPageScreen()),
      );
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
                    child: _buildForm(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(255, 255, 255, 0.68),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
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
              SizedBox(height: 16),
              _buildTextField(AppLocalizations.of(context)!.translate('Name'), nameController, AppLocalizations.of(context)!.translate('Please enter Name')),
              SizedBox(height: 16),
              _buildTextField(AppLocalizations.of(context)!.translate('National ID'), nationalIdController, AppLocalizations.of(context)!.translate('Please enter National ID'), keyboardType: TextInputType.number),
              SizedBox(height: 16),
              _buildDateOfBirthField(context),
              SizedBox(height: 16),
              _buildTextField(AppLocalizations.of(context)!.translate('Email'), emailController, AppLocalizations.of(context)!.translate('Please enter Email'), keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildPasswordField(),
              SizedBox(height: 16),
              _buildConfirmPasswordField(),
              SizedBox(height: 16),
              _buildHasSurgeriesSection(context),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: ()  {
                    blockchainHelper.insertPatient(
                        nationalId:123, //int.parse(nationalIdController.text),
                        name: 'hh',//nameController.text,
                        email: 'oo',//emailController.text,
                        dateOfBirth:'ii',// dobController.text,
                        password: 'aa',//passwordController.text,
                        hasSurgeriesBefore: 'hl'//selectedOption,
                    );
                    _insertPatient();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPageScreen()),
                    );},
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String errorMessage, {TextInputType keyboardType = TextInputType.text}) {
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
        SizedBox(height: 8),
        Container(
          width: 317,
          height: 47,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            keyboardType: keyboardType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return errorMessage;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('Date Of Birth'),
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

  Widget _buildPasswordField() {
    return _buildTextField(AppLocalizations.of(context)!.translate('Create Password'), passwordController, AppLocalizations.of(context)!.translate('Please enter Password'), keyboardType: TextInputType.visiblePassword);
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('Confirm Password'),
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
            controller: confirmPasswordController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter Confirm Password');
              } else if (value != passwordController.text) {
                return AppLocalizations.of(context)!.translate('Passwords do not match');
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHasSurgeriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                      if (selectedOption == 'Yes') {
                        // Navigate to surgeries screen to add surgery info
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Surgeries(
                              onSubmit: (surgeryInfo, surgeryImage) {
                                setState(() {
                                  this.surgeryInfo = surgeryInfo;
                                  this.surgeryImage = surgeryImage;
                                  selectedOption = 'Yes';
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.translate('Yes'),
                  style: TextStyle(
                    fontFamily: 'Laila',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(83, 101, 167, 1),
                  ),
                ),
              ],
            ),
            SizedBox(width: 60),
            Row(
              children: [
                Radio<String>(
                  value: 'No',
                  groupValue: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                      if (selectedOption == 'No') {
                        // Clear surgery info if any
                        setState(() {
                          surgeryInfo = null;
                          surgeryImage = null; // Clear surgery image as well
                        });
                      }
                    });
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.translate('No'),
                  style: TextStyle(
                    fontFamily: 'Laila',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(83, 101, 167, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (surgeryInfo != null && surgeryImage != null) ...[
          SizedBox(height: 10),
          Text(
            'Surgery Info: $surgeryInfo',
            style: TextStyle(
              fontFamily: 'Laila',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(83, 101, 167, 1),
            ),
          ),
          SizedBox(height: 10),
          Image.file(
            surgeryImage!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ],
      ],
    );
  }
}