// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:todoapp/screens/todo_list_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OnSchedule : Not Just another TodoApp',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AnimatedSplashScreen(
        duration: 4000,
        splash: 'images/logo.png',
        nextScreen: TodoListScreen(),
        splashTransition: SplashTransition.sizeTransition,
        backgroundColor: HexColor("E91E63"),
        //pageTransitionType: PageTransitionType.scale,
      ),
    );
  }
}
