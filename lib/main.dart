// ignore_for_file: use_key_in_widget_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/blocs/ads_bloc.dart';
import 'package:todoapp/config/config.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todoapp/screens/todo_list_screen.dart';

import 'blocs/settings_bloc.dart';
import 'blocs/theme_bloc.dart';

void main() {
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
              ChangeNotifierProvider<SettingsBloc>(
                  create: (context) => SettingsBloc()),
              ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorObservers: [firebaseObserver],
              color: Config.appThemeColors,
              home: AnimatedSplashScreen(
                duration: 4000,
                splash: const Image(
                  height: 240,
                  width: 380,
                  image: AssetImage(Config.appIconp),
                  fit: BoxFit.contain,
                ),
                nextScreen: TodoListScreen(),
                splashTransition: SplashTransition.sizeTransition,
                backgroundColor: Config.appThemeColors,
              ),
            ),
          );
        },
      ),
    );
  }
}
