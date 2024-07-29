// import 'AppLocalizations.dart';

// import 'user_model.dart';
// import 'package:flutter/material.dart';

// import 'Navigation.dart';
// import 'profileicon.dart';
// import 'models/Patient.dart';
// import 'BlockchainHelperr.dart';
// class AvailableLabsListScreen extends StatefulWidget {
//   final Patient user;

//   AvailableLabsListScreen({required this.user});

//   @override
//   _AvailableLabsListScreenState createState() => _AvailableLabsListScreenState();
// }

// class _AvailableLabsListScreenState extends State<AvailableLabsListScreen> {
//   TextEditingController _searchController = TextEditingController();
//   List<String>? labs;
//   List<String> filteredLabs = [];

//   @override
//   void initState() {
//     //filteredLabs.addAll(labs);
//     super.initState();
//     _fetchLabs();
//   }
//   Future<void> _fetchLabs() async {
//     labs = await DatabaseHelper.instance.getAllLaboratoryNames();
//     setState(() {
//       filteredLabs.addAll(labs!);
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void filterLabs(String query) {
//     filteredLabs.clear();
//     if (query.isNotEmpty) {
//       labs?.forEach((lab) {
//         if (lab.toLowerCase().contains(query.toLowerCase())) {
//           filteredLabs.add(lab);
//         }
//       });
//     } else {
//       filteredLabs.addAll(labs as Iterable<String>);
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         extendBody: true,
//         extendBodyBehindAppBar: false,
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           backgroundColor: Colors.cyan[50],
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           actions: [
//             ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
//           ],
//         ),
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.cyan[50],
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.25),
//                 spreadRadius: 2,
//                 blurRadius: 2,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 30),
//                 child: Text(
//                   AppLocalizations.of(context)!.translate("Available Laboratories"),
//                   style: TextStyle(
//                     fontSize: 21,
//                     color: Color.fromRGBO(174, 98, 137, 1),
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15),
//                         offset: Offset(0, 4),
//                         blurRadius: 4,
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//                SizedBox(height: 5),
//               _buildSearchField(),
//               SizedBox(height: 16),
//               _buildLabList(),
//             ],
//           ),
//         ),

//       );

//   }

//   Widget _buildSearchField() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 12),
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 2,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: AppLocalizations.of(context)!.translate("Search laboratories"),
//                 border: InputBorder.none,
//                 icon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 filterLabs(value);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLabList() {
//     return Expanded(
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: filteredLabs.length,
//         itemBuilder: (context, index) {
//           return _buildLabCard(filteredLabs[index]);
//         },
//       ),
//     );
//   }

//   Widget _buildLabCard(String labName) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               labName,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               AppLocalizations.of(context)!.translate( "Lab Details"),
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }
import 'models/Patient.dart';

import '/AppLocalizations.dart';

import 'user_model.dart';
import 'package:flutter/material.dart';

import 'Navigation.dart';
import 'profileicon.dart';

class AvailableLabsListScreen extends StatefulWidget {
  final Patient user;

  AvailableLabsListScreen({required this.user});

  @override
  _AvailableLabsListScreenState createState() => _AvailableLabsListScreenState();
}

class _AvailableLabsListScreenState extends State<AvailableLabsListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> labs = [
    "al mokhtabar",
    "Nile",
    "Radar",
    "Delta",
    "Alpha",
  ];
  List<String> filteredLabs = [];

  @override
  void initState() {
    filteredLabs.addAll(labs);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterLabs(String query) {
    filteredLabs.clear();
    if (query.isNotEmpty) {
      labs.forEach((lab) {
        if (lab.toLowerCase().contains(query.toLowerCase())) {
          filteredLabs.add(lab);
        }
      });
    } else {
      filteredLabs.addAll(labs);
    }
    setState(() {});
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
          actions: [
            ProfileIcon(user: widget.user), // This adds the ProfileIcon widget to the AppBar
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  AppLocalizations.of(context)!.translate("Available Laboratories"),
                  style: TextStyle(
                    fontSize: 21,
                    color: Color.fromRGBO(174, 98, 137, 1),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 5),
              _buildSearchField(),
              SizedBox(height: 16),
              _buildLabList(),
            ],
          ),
        ),

      );

  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.translate("Search laboratories"),
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterLabs(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredLabs.length,
        itemBuilder: (context, index) {
          return _buildLabCard(filteredLabs[index]);
        },
      ),
    );
  }

  Widget _buildLabCard(String labName) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Text(
            //   AppLocalizations.of(context)!.translate( "Lab Details"),
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey[600],
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: AvailableLabsListScreen(),
//   ));
// }

// // void main() {
// //   runApp(MaterialApp(
// //     home: AvailableLabsListScreen(),
// //   ));
// // }
