import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppLocalizations.dart';
import 'PatientNotifier.dart';
import 'BlockchainHelperr.dart';
import 'models/Patient.dart';

class EditPatientScreen extends StatefulWidget {
  final Patient patient;

  EditPatientScreen({required this.patient});

  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _hasSurgeriesBeforeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _dateOfBirthController = TextEditingController(text: widget.patient.dateOfBirth);
    _emailController = TextEditingController(text: widget.patient.email);
    _passwordController = TextEditingController(text: widget.patient.password);
    _hasSurgeriesBeforeController = TextEditingController(text: widget.patient.hasSurgeriesBefore);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _hasSurgeriesBeforeController.dispose();
    super.dispose();
  }

  Future<void> _updatePatient() async {
    if (_formKey.currentState!.validate()) {
      Patient updatedPatient = Patient(
        nationalId: widget.patient.nationalId,
        name: _nameController.text,
        dateOfBirth: _dateOfBirthController.text,
        email: _emailController.text,
        password: _passwordController.text,
        hasSurgeriesBefore: _hasSurgeriesBeforeController.text,
      );

      await DatabaseHelper.instance.updatePatient(updatedPatient);
      //Provider.of<PatientNotifier>(context, listen: false).updatePatient(updatedPatient);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('Edit Patient')),
        backgroundColor: Colors.cyan[50],
      ),
      body: Container(
        color: Colors.cyan[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              buildInputField(context, 'Name', _nameController),
              buildInputField(context, 'DateOfBirth', _dateOfBirthController),
              buildInputField(context, 'Email', _emailController),
              buildInputField(context, 'Password', _passwordController, obscureText: true),
              buildInputField(context, 'Has Surgeries Before', _hasSurgeriesBeforeController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(83, 101, 167, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 4,
                  shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('Submit'),
                  style: TextStyle(
                    fontFamily: 'Laila',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(BuildContext context, String labelText, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate(labelText),
            style: TextStyle(
              fontFamily: 'Laila',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(83, 101, 167, 1),
            ),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white.withOpacity(0.75),
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.translate('Please enter $labelText');
                }
                return null;
              },
              obscureText: obscureText,
            ),
          ),
        ],
      ),
    );
  }
}
