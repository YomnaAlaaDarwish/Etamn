import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'BlockchainHelper.dart';
import 'BlockchainHelperr.dart';
import 'models/Patient.dart';
import 'BlockchainHelperr.dart';
import 'models/XRay.dart';
import 'profileicon.dart';

class ShowXrays extends StatefulWidget {
  final Patient user;

  ShowXrays({required this.user});

  @override
  _ShowXraysState createState() => _ShowXraysState();
}

class _ShowXraysState extends State<ShowXrays> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<XRay> _xrays = [];
  final BlockchainHelper blockchainHelper = BlockchainHelper();
  @override
  void initState() {
    super.initState();
    blockchainHelper.getXRay(nationalId: widget.user.nationalId);
    _fetchXrays();
  }

  Future<void> _fetchXrays() async {
    List<XRay> xrays = await _databaseHelper.getXRayByNationalId(widget.user.nationalId);
    setState(() {
      _xrays = xrays;
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
      body: _xrays.isEmpty
          ? Center(
              child: Text('No X-rays found'),
            )
          : ListView.builder(
              itemCount: _xrays.length,
              itemBuilder: (context, index) {
                XRay xray = _xrays[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'X-ray ${xray.id}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // Check if imageUrl is not empty before showing the IconButton
                        xray.imageUrl!.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () => _showFullImage(xray.imageUrl.toString()),
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
