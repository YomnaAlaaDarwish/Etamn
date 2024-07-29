import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelperr.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    final String code = _codeController.text;
    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // Validate input
    if (newPassword != confirmPassword) {
      // Show error message if passwords do not match
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context)!.translate('Passwords do not match')),
          );
        },
      );
      return;
    }

    try {
      // Assuming code represents nationalId for simplicity
      final int nationalId = int.parse(code);

      int result = await DatabaseHelper.instance.updatePatientPassword(nationalId, newPassword);
      if (result > 0) {
        // Show success message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(AppLocalizations.of(context)!.translate('Password updated successfully')),
            );
          },
        );
      } else {
        // Show error message if the old password does not match
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(AppLocalizations.of(context)!.translate('Old password is incorrect')),
            );
          },
        );
      }
    } catch (e) {
      // Show error message for invalid nationalId format
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context)!.translate('Invalid code format')),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(171, 210, 231, 0.5644),
                  Color.fromRGBO(8, 54, 68, 0.1577),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 330,
              height: 750,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.75),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.translate("Never Mind"),
                    style: TextStyle(
                      fontFamily: "Laila",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3333333432674408,
                      color: Color.fromRGBO(141, 30, 86, 1),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.translate("Please provide the code sent to you in your email"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Laila",
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      letterSpacing: -0.3333333432674408,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 62,
                    height: 22,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Code"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "Laila",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3333333432674408,
                          color: Color.fromRGBO(83, 101, 167, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 286,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(234, 232, 232, 0.75),
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 30,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Old Password"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "Laila",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3333333432674408,
                          color: Color.fromRGBO(83, 101, 167, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 286,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(234, 232, 232, 0.75),
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: TextField(
                      controller: _oldPasswordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 30,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("New Password"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "Laila",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3333333432674408,
                          color: Color.fromRGBO(83, 101, 167, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 286,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(234, 232, 232, 0.75),
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 30,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Confirm Password"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "Laila",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3333333432674408,
                          color: Color.fromRGBO(83, 101, 167, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 286,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(234, 232, 232, 0.75),
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: _updatePassword,
                    child: Container(
                      width: 144,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        color: Color.fromRGBO(83, 101, 167, 1),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate('Submit'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 166.67,
                        height: 24.64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate("Don't receive the code?"),
                            style: TextStyle(
                              fontFamily: "Laila",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.41,
                              color: Color.fromRGBO(0, 0, 0, 0.76),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Implement functionality for "Resend"
                        },
                        child: Container(
                          width: 50,
                          height: 24.64,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate("Resend"),
                              style: TextStyle(
                                fontFamily: "Laila",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.41,
                                color: Color.fromRGBO(4, 135, 177, 1),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}