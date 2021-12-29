// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/blocs/ads_bloc.dart';
import 'package:todoapp/splash.dart';

import 'blocs/settings_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'services/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MyApp());
}

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
final FirebaseAnalyticsObserver firebaseObserver =
    FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => NotificationService()),
              ChangeNotifierProvider<SettingsBloc>(
                  create: (context) => SettingsBloc()),
              ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorObservers: [firebaseObserver],
              home: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
