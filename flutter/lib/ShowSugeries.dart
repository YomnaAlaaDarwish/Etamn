import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'BlockchainHelper.dart';
import 'BlockchainHelperr.dart';
import 'models/Patient.dart';
import 'models/Surgery.dart';
import 'profileicon.dart';

class ShowSurgeries extends StatefulWidget {
  final Patient user;

  ShowSurgeries({required this.user});

  @override
  _ShowSurgeriesState createState() => _ShowSurgeriesState();
}

class _ShowSurgeriesState extends State<ShowSurgeries> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Surgery> _surgeries = [];
  final BlockchainHelper blockchainHelper = BlockchainHelper();
  @override
  void initState() {
    super.initState();
    blockchainHelper.getSurgery(nationalId: widget.user.nationalId);
    _fetchSurgeries();
  }

  Future<void> _fetchSurgeries() async {
    List<Surgery> surgeries = await _databaseHelper.getSurgeryByNationalId(widget.user.nationalId);
    setState(() {
      _surgeries = surgeries;
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
      body: _surgeries.isEmpty
          ? Center(
              child: Text('No surgeries found'),
            )
          : ListView.builder(
              itemCount: _surgeries.length,
              itemBuilder: (context, index) {
                Surgery surgery = _surgeries[index];
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
                                'Surgery ${surgery.id}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // Check if imageUrl is not empty before showing the IconButton
                        surgery.imageUrl!.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () => _showFullImage(surgery.imageUrl.toString()),
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
