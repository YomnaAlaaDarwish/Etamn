import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppLocalizations.dart';
import 'ForgetPassword.dart';
import 'SignUpDoctors.dart'; // Import the SignUpDoctors file
import 'DoctorProfileScreen.dart'; // Import the DoctorProfileScreen file
import 'models/Doctor.dart';
import 'BlockchainHelperr.dart';

class LoginDoctors extends StatefulWidget {
  @override
  _LoginDoctorsState createState() => _LoginDoctorsState();
}

class _LoginDoctorsState extends State<LoginDoctors> {
  bool rememberMe = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nationalIDController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    _buildHeader(),
                    SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.translate("ETAMN"),
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 32,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        height: 47.84 / 32,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildFormFields(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(86),
            ),
            child: Image.asset('assets/imgellipse1.png'),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                //_changeLanguage(context);
              },
              child: Container(
                height: 37,
                width: 37,
                child: Image.asset('assets/img87316612.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // void _changeLanguage(BuildContext context) {
  //   LocaleNotifier localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
  //   Locale newLocale = localeNotifier.locale.languageCode == 'en' ? Locale('ar', '') : Locale('en', '');
  //   localeNotifier.setLocale(newLocale);
  // }

  Widget _buildFormFields(BuildContext context) {
    return Container(
      width: 352,
      height: 490,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.61),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Container(
            height: 100,
            child: Image.asset(
              "assets/imgectangle49.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10),
          _buildInputFieldNationalID(AppLocalizations.of(context)!.translate("National ID")),
          SizedBox(height: 10),
          _buildInputFieldPassword(AppLocalizations.of(context)!.translate("Password")),
          SizedBox(height: 10),
          _buildForgetPasswordButton(context),
          _buildRememberMe(context),
          SizedBox(height: 20),
          _buildLoginButton(context),
          SizedBox(height: 30),
          _buildSignup(),
          SizedBox(height: 20),
          _buildJoinAs(),
        ],
      ),
    );
  }

  Widget _buildInputFieldNationalID(String hintText) {
    return Container(
      width: 312,
      height: 45,
      decoration: BoxDecoration(
        color: Color.fromRGBO(217, 217, 217, 0.47),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: _nationalIDController,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.translate('Please enter National ID');
            } else if (value.length != 14 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
              return AppLocalizations.of(context)!.translate('National ID must be 14 digits');
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildInputFieldPassword(String hintText) {
    return Container(
      width: 312,
      height: 45,
      decoration: BoxDecoration(
        color: Color.fromRGBO(217, 217, 217, 0.47),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            prefixIcon: Icon(Icons.lock_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.translate('Please enter Password');
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildForgetPasswordButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgetPassword()),
        );
      },
      child: Container(
        width: 123,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Text(
          AppLocalizations.of(context)!.translate('Forget Password?'),
          style: TextStyle(
            fontFamily: 'Laila',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            shadows: [
              Shadow(
                offset: Offset(4, 4),
                blurRadius: 4,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildRememberMe(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color.fromRGBO(220, 222, 228, 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Checkbox(
            value: rememberMe,
            onChanged: (value) {
              setState(() {
                rememberMe = value ?? false;
              });
            },
            checkColor: Colors.black,
            activeColor: Colors.transparent,
          ),
        ),
        SizedBox(width: 2),
        Container(
          width: 97,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate('Remember me'),
              style: TextStyle(
                fontFamily: 'Laila',
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.55),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            int nationalId = int.parse(_nationalIDController.text.trim());
            String password = _passwordController.text.trim();

            Doctor? doctor = await DatabaseHelper.instance.getDoctorByNationalId(nationalId);

            if (doctor != null && doctor.password == password) {
              print("found");
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorProfileScreen(
                  doctorName: doctor.name,
                  doctorId: doctor.nationalId,
                ),
              ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.translate('Invalid credentials. Please try again.')),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        child: Container(
          width: 144,
          height: 52,
          decoration: BoxDecoration(
            color: Color.fromRGBO(10, 97, 125, 1),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate('Login'),
              style: TextStyle(
                fontFamily: 'Josefin Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.01,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Don't have an account?"),
              style: TextStyle(
                fontFamily: 'Laila',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 0, 0, 0.76),
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpDoctors()),
            );
          },
          child: Container(
            width: 70,
            height: 22,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Sign Up"),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(10, 97, 125, 1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinAs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 22,
          child: Text(
            AppLocalizations.of(context)!.translate("Join as"),
            style: TextStyle(
              fontFamily: 'Laila',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            // Navigate to the Doctor login page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginDoctors()),
            );
          },
          child: Container(
            child: Text(
              AppLocalizations.of(context)!.translate("Doctor"),
              style: TextStyle(
                fontFamily: 'Laila',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(10, 97, 125, 1),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: 44,
          height: 22,
          child: Text(
            AppLocalizations.of(context)!.translate("Or"),
            style: TextStyle(
              fontFamily: 'Laila',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            // Navigate to the Laboratory login page
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => LoginLabs()),
            // );
          },
          child: Container(
            child: Text(
              AppLocalizations.of(context)!.translate("Laboratory"),
              style: TextStyle(
                fontFamily: 'Laila',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(10, 97, 125, 1),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginDoctors(),
  ));
}