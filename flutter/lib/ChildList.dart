import 'package:flutter/material.dart';
import 'AddNewChild.dart';
import 'AppLocalizations.dart';
import 'BlockchainHelperr.dart';
import 'MenuOptions.dart';
import 'Navigation.dart';
import 'profileicon.dart';
import 'models/Patient.dart';

class ChildList extends StatefulWidget {
  final Patient patient;

  const ChildList({Key? key, required this.patient}) : super(key: key);

  @override
  State<ChildList> createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  List<Patient> _children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final children = await DatabaseHelper.instance.getChildrenByParentId(widget.patient.nationalId);

    setState(() {
      _children = children;
    });
  }

  void _onChildAdded(Patient newChild) {
    setState(() {
      _children.add(newChild);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   ProfileIcon(patient: widget.patient),
        // ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.cyan[50],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _children.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        buildChildButton(_children[index]),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewChild(
                        onChildAdded: _onChildAdded,
                        patient: widget.patient,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromRGBO(83, 101, 167, 1),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('Add New Child'),
                      style: TextStyle(
                        fontFamily: 'Laila',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(user: widget.patient),
    );
  }

  Widget buildChildButton(Patient child) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuOptions(user: widget.patient),
          ),
        );
      },
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(83, 101, 167, 1),
        ),
        child: Center(
          child: Text(
            child.name,
            style: TextStyle(
              fontFamily: 'Laila',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}