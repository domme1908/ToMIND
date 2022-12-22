import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart' as UMP;

import 'package:varese_transport/screens/home/components/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    setLanguageFromMemory().then((value) => runApp(new MyApp(lang: value)));
  });
}

class MyApp extends StatefulWidget {
  final Locale lang;
  const MyApp({
    Key? key,
    required this.lang,
  }) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.changeLanguage(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState(locale: lang);
}

Future<Locale> setLanguageFromMemory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("lang")) return Locale(prefs.getString("lang")!);
  return Future<Locale>.value(Locale("it"));
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  _MyAppState({required this.locale});
  @override
  void initState() {
    super.initState();
    updateConsent();
  }

  void updateConsent() async {
    //Android devices
    if (Platform.isAndroid) {
      // Make sure to continue with the latest consent info.
      var info =
          await UMP.UserMessagingPlatform.instance.requestConsentInfoUpdate();

      // Show the consent form if consent is required.
      if (info.consentStatus == UMP.ConsentStatus.required) {
        // `showConsentForm` returns the latest consent info, after the consent from has been closed.
        info = await UMP.UserMessagingPlatform.instance.showConsentForm();
      }
    }
    //IOS Devices
    else {
      Future.delayed(const Duration(milliseconds: 750), () async {
        // If the system can show an authorization request dialog
        if (await AppTrackingTransparency.trackingAuthorizationStatus ==
            TrackingStatus.notDetermined) {
          // Request system's tracking authorization dialog
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      });
    }
  }

  changeLanguage(Locale locale) {
    setState(() {
      this.locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      //Some basic settings
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'DaQui',
      //Start the home screen
      home: HomeScreen(),
    );
  }
}
