// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
//
// class AppLocalizations {
//   final Locale locale;
//   static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
//
//   AppLocalizations(this.locale);
//
//   static AppLocalizations of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
//   }
//
//   static Map<String, String> _localizedStrings = {};
//
//   Future<bool> load() async {
//     String jsonString;
//     try {
//       jsonString = await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');
//       Map<String, dynamic> jsonMap = json.decode(jsonString);
//       _localizedStrings = jsonMap.map((key, value) {
//         return MapEntry(key, value.toString());
//       });
//       return true;
//     } catch (e) {
//       print("Error loading localization file: $e");
//       return false;
//     }
//   }
//
//   String translate(String key) {
//     return _localizedStrings[key] ?? key;
//   }
// }
//
// class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'ar'].contains(locale.languageCode);
//   }
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     AppLocalizations localizations = AppLocalizations(locale);
//     await localizations.load();
//     return localizations;
//   }
//
//   @override
//   bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
//     return false;
//   }
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       localizationsDelegates: [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: [
//         Locale('en', ''),
//         Locale('ar', ''),
//       ],
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).translate('title')),
//       ),
//       body: Center(
//         child: Text(AppLocalizations.of(context).translate('hello_world')),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    String jsonString;
    try {
      jsonString = await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      return true;
    } catch (e) {
      print("Error loading localization file: $e");
      return false;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context).translate('hello_world')),
      ),
    );
  }
}
