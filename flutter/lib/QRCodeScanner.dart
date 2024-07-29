import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'AppLocalizations.dart';
import 'ShowForDoctor.dart';
import 'showuploads.dart'; // Import the page to be navigated to
import 'user_model.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (scannedData != null)
                  ? ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowForDoctor(
                          scannedData: scannedData!,
                        ),
                      ),
                    );

                },
                child: Text(AppLocalizations.of(context)!.translate('Open Uploads')),
              )
                  : Text(AppLocalizations.of(context)!.translate('Scan a QR code')),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
        setState(() {
          scannedData = scanData.code;
        });

        // Navigate to ShowUploadsPage only after a valid scan

    });
  }
}
