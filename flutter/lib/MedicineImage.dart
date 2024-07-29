import 'dart:async';
import 'dart:io'; // Import File from dart:io
import 'models/Patient.dart';
import 'user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import AppLocalizations
import'package:image_picker/image_picker.dart';
import 'AppLocalizations.dart';
import 'profileicon.dart';

class MedicineImage extends StatefulWidget {
  final Patient user;

  MedicineImage({required this.user});

  @override
  State<MedicineImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<MedicineImage> {
  File? _image; // Declare _image as File? to use dart:io File

  final imagePicker = ImagePicker();

  Future<void> getimage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path); // Use File constructor from dart:io
      });
      Navigator.pop(context, _image); // Pass the image file back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
        ],
      ),
      body: Center(
        child: _image == null
            ? Text(
          AppLocalizations.of(context).translate('no_image_text'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Laila',
          ),
        )
            : Image.file(_image!), // Use Image.file with dart:io File
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getimage,
        backgroundColor: Colors.indigo[200],
        child: Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
