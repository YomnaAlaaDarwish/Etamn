import 'MenuOptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'AppLocalizations.dart';
import 'LoginScreen.dart'; // Replace with your LoginPageScreen widget
import 'PatientNotifier.dart';
import 'local_notifications.dart';
import 'package:provider/provider.dart';
import 'SignUPScreen.dart';
import 'SignUpDoctors.dart';
import '/SignUpLabs.dart';
import '/LoginDoctors.dart';

import 'models/Patient.dart';
final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleNotifier>(
          create: (_) => LocaleNotifier(),
        ),
        // ChangeNotifierProvider<PatientNotifier>(
        //   create: (_) => PatientNotifier(
        //     Patient(
        //       nationalId: 1234567890,
        //       name: 'John Doe',
        //       dateOfBirth: '01/01/1990',
        //       email: 'johndoe@example.com',
        //       password: 'password123',
        //       hasSurgeriesBefore: 'No',
        //     ),
        //   ),
        // ),
      ],
      child: Consumer<LocaleNotifier>(
    builder: (context, localeNotifier, _) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    navigatorKey: navigatorKey,
    locale: localeNotifier.locale,
    title: 'Localized App',
    theme: ThemeData(
    primarySwatch: Colors.blue,
    ),
    supportedLocales: [
    Locale('en', ''),
    Locale('ar', ''),
    ],
    localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    ],
    home: LoginPageScreen(), // Replace with your initial screen
    );
    },


      ),
    );
  }
}


class LocaleNotifier extends ChangeNotifier {
  Locale _locale = Locale('en', '');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
