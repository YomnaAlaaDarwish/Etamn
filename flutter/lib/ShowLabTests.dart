import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'models/Patient.dart';
import 'BlockchainHelperr.dart';
import 'LabTest_model.dart';
import 'profileicon.dart';

class ShowLabTests extends StatefulWidget {
  final Patient user;

  ShowLabTests({required this.user});

  @override
  _ShowLabTestsState createState() => _ShowLabTestsState();
}

class _ShowLabTestsState extends State<ShowLabTests> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<LabTest> _labTests = [];

  @override
  void initState() {
    super.initState();
    _fetchLabTests();
  }

  Future<void> _fetchLabTests() async {
    List<LabTest> labTests = await _databaseHelper.getUserLabTests(widget.user.nationalId);
    setState(() {
      _labTests = labTests.where((labTest) => labTest.status == 'accepted').toList();
    });
  }

  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: PhotoView(
            imageProvider: FileImage(File(imageUrl)),
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
        // ],
      ),
      body: _labTests.isEmpty
          ? Center(
              child: Text('No lab tests found'),
            )
          : ListView.builder(
              itemCount: _labTests.length,
              itemBuilder: (context, index) {
                LabTest labTest = _labTests[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Name: ${labTest.testName}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Status: ${labTest.status}'),
                        SizedBox(height: 8),
                        // Check if imageUrl is not empty before showing the IconButton
                        labTest.imageUrl.isNotEmpty
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.image),
                                  onPressed: () => _showFullImage(labTest.imageUrl),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.cyan[50],
    );
  }
}
