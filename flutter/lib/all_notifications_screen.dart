import 'package:flutter/material.dart';
import 'profileicon.dart';
import 'models/Patient.dart';
import 'local_notifications.dart';
import 'BlockchainHelperr.dart'; // Import your database helper
import 'AppLocalizations.dart'; // Replace with your AppLocalizations import

class NotificationsPage extends StatefulWidget {
  final int userId;

  NotificationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Patient? user;
  List<Map<String, dynamic>> get userNotifications =>
      LocalNotifications.userPeriodicNotifications[widget.userId.toString()] ?? [];

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      Patient? fetchedUser = await DatabaseHelper.instance.getPatientByNationalId(widget.userId);
      setState(() {
        user = fetchedUser;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: Text(AppLocalizations.of(context).translate('all_notifications_title')),
        actions: [
          if (user != null) ProfileIcon(user: user!),
        ],
      ),
      body: ListView.builder(
        itemCount: userNotifications.length,
        itemBuilder: (context, index) {
          var notification = userNotifications[index];
          return ListTile(
            title: Text(notification['title']),
            subtitle: Text(
              '${AppLocalizations.of(context).translate('notification_body_prefix')}${notification['body']}',
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await LocalNotifications.cancelSpecificNotification(
                  widget.userId.toString(),
                  notification['notificationId'],
                );
                setState(() {
                  // userNotifications.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
