import '/models/Patient.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'AppLocalizations.dart';
import 'user_model.dart';

class QRCodePage extends StatelessWidget {
  final Patient user;

  QRCodePage({required this.user});

  @override
  Widget build(BuildContext context) {
    String userId = user.nationalId.toString(); // Convert user.id to string
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: Text(AppLocalizations.of(context)!.translate('QR Code')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: userId,  // Pass the string representation of user.id
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.translate( 'Scan this QR Code'),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
