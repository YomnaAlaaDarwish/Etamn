import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'BlockchainHelper.dart';
import 'user_model.dart';
import 'profileicon.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelperr.dart'; // Make sure this is set up correctly
import 'models/XRay.dart';
import 'models/Patient.dart';

// Make sure the Surgery model is defined correctly

class UploadImage extends StatefulWidget {
  final Patient user;
  UploadImage({required this.user});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  bool _isUploaded = false;
  String _message = '';

  final ImagePicker imagePicker = ImagePicker();
  final BlockchainHelper blockchainHelper = BlockchainHelper();
  Future<void> getImage({bool isCamera = true}) async {
    final image = await imagePicker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _isUploaded = true;
        _message = AppLocalizations.of(context)
            .translate('Image uploaded successfully.');
        blockchainHelper.insertXRay(
            nationalId: widget.user.nationalId,
            imageUrl: _image!.path,
            date: DateTime.now().toLocal().toIso8601String().split('T').first);
        _insertXRayData();
      });
    }
  }

  Future<int> _insertXRayData() async {
    if (_image != null) {
      XRay xray =
      XRay(nationalId: widget.user.nationalId, imageUrl: _image?.path);
      return await DatabaseHelper.instance.insertXRay(xray);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        //: [
        //  ProfileIcon(user: user),
        //],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text(
                AppLocalizations.of(context).translate("No Image"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Laila'),
              )
                  : Image.file(_image!),
              SizedBox(height: 20),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Laila',
                  color: _isUploaded ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt_outlined),
        label: Text(AppLocalizations.of(context).translate("Capture Image")),
        onPressed: () => getImage(isCamera: true),
        backgroundColor: Colors.indigo[200],
      ),
    );
  }
}