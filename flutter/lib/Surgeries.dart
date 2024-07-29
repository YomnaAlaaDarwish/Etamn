import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'AppLocalizations.dart';

class Surgeries extends StatefulWidget {
  final Function(String, File?) onSubmit;

  const Surgeries({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<Surgeries> createState() => _SurgeriesState();
}

class _SurgeriesState extends State<Surgeries> {
  File? _image;
  TextEditingController surgeryInfoController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.translate('Photo Library')),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context)!.translate('Camera')),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 90),
              child: Text(
                AppLocalizations.of(context)!.translate('Enter Surgery Info:'),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(83, 101, 167, 1),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(255, 255, 255, 0.75),
                ),
                child: Center(
                  child: TextField(
                    controller: surgeryInfoController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 33, top: 16, right: 33),
              child: Text(
                AppLocalizations.of(context)!.translate('If There is An Image For Surgery Info, You Can Upload It Here'),
                style: TextStyle(
                  fontFamily: 'Laila',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 0, 0, 1),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _image == null
                      ? Image.asset('assets/upload.png', width: 40, height: 40)
                      : Image.file(_image!, width: 40, height: 40),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(surgeryInfoController.text, _image);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(159, 44),
                    backgroundColor: Color.fromRGBO(83, 101, 167, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 159,
                    height: 44,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.translate('Submit'),
                      style: TextStyle(
                        fontFamily: 'Laila',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showPicker(context),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(169, 47),
                    backgroundColor: Color.fromRGBO(83, 101, 167, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 169,
                    height: 47,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.translate('Add Surgery'),
                      style: TextStyle(
                        fontFamily: 'Laila',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
