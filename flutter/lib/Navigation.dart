import 'all_notifications_screen.dart';
import 'user_model.dart';
import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'MenuOptions.dart';
import 'UploadingPage.dart';
// import 'available_labslist_screen.dart';
import 'models/Patient.dart';

class CustomNavigationBar extends StatefulWidget {
  final Patient user;

  CustomNavigationBar({required this.user});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuOptions(user:widget.user)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadingPage(user: widget.user)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationsPage(userId: widget.user.nationalId)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded, color: Colors.pinkAccent, size: 40),
          label: AppLocalizations.of(context)!.translate("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outlined, color: Colors.pinkAccent, size: 40),
          label: AppLocalizations.of(context)!.translate("Upload"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, color: Colors.pinkAccent, size: 40),
          label: AppLocalizations.of(context)!.translate("Notifications"),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(color: Colors.black),
      unselectedLabelStyle: TextStyle(color: Colors.black),
      onTap: _onItemTapped,
      mouseCursor: SystemMouseCursors.click,
      type: BottomNavigationBarType.fixed,
    );
  }
}
