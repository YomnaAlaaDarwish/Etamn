import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelper.dart';
import 'LoginDoctors.dart';
import 'LoginScreen.dart';
import 'BlockchainHelperr.dart';
import 'models/Doctor.dart';


class SignUpDoctors extends StatefulWidget {
  const SignUpDoctors({Key? key}) : super(key: key);

  @override
  State<SignUpDoctors> createState() => _SignUpDoctorsState();
}

class _SignUpDoctorsState extends State<SignUpDoctors> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final BlockchainHelper blockchainHelper = BlockchainHelper();
  String? certificateHash;
  Future<void> _i() async {
    blockchainHelper.insertDoctor(
      nationalId: 11,
      name: 'vhc',
      email:  'vhc',
      dateOfBirth:  'vhc',
      password: 'vhc',
      certificateHash:  'vhc',
    );
  }

  Future<void> _insertDoctor() async {
    if (_formKey.currentState!.validate()) {
      final doctor = Doctor(
        nationalId: int.parse(nationalIdController.text),
        name: nameController.text,
        dateOfBirth: dobController.text,
        email: emailController.text,
        password: passwordController.text,
        certificateHash:"hhh",// certificateHash ?? '',
      );

      await DatabaseHelper.instance.insertDoctor(doctor);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Doctor inserted successfully'),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginDoctors()),
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
              _buildUploadCertificateSection(context),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginDoctors()),
                    );
                    blockchainHelper.insertDoctor(
                      nationalId: int.parse(nationalIdController.text),
                      name: nameController.text,
                      email: emailController.text,
                      dateOfBirth: dobController.text,
                      password: passwordController.text,
                      certificateHash: certificateHash!,
                    );
                    _insertDoctor();
                    _i();

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

  Widget _buildUploadCertificateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('Upload Certificate'),
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
        Center(
          child: ElevatedButton(
            onPressed: () async {
              // Implement certificate upload functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(83, 101, 167, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.translate('Upload'),
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
    );
  }
}