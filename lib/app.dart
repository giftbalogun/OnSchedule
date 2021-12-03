import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/theme.dart';
import 'package:todoapp/screens/todo_list_screen.dart';
import 'blocs/ads_bloc.dart';

import 'blocs/settings_bloc.dart';
import 'blocs/theme_bloc.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
final FirebaseAnalyticsObserver firebaseObserver =
    FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyAppNext extends StatelessWidget {
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
              theme: ThemeModel().lightTheme,
              darkTheme: ThemeModel().darkTheme,
              themeMode:
                  mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
              home: TodoListScreen(),
            ),
          );
        },
      ),
    );
  }
}
