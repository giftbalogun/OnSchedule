import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/blocs/ads_bloc.dart';
import 'package:todoapp/screens/todo_list_screen.dart';
import 'package:todoapp/utils/next_screen.dart';
import '../config/config.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _rightPaddingValue = 140;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future _afterSplash() async {
    Future.delayed(const Duration(milliseconds: 0))
        .then((value) => context.read<AdsBloc>().showLoadedAds());
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      setState(() {
        _rightPaddingValue = 10;
        _gotoHomePage();
      });
    });
  }

  void _gotoHomePage() {
    nextScreenReplace(context, TodoListScreen());
  }

  void _newme() {
    setState(() {
      nextScreenReplace(context, TodoListScreen());
    });
  }

  @override
  void initState() {
    //_afterSplash();
    //_gotoHomePage();
    _newme();
    super.initState();
    // _gotoHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          height: 240,
          width: 380,
          image: AssetImage(Config.appIconp),
          fit: BoxFit.contain,
          color: Config.appThemeColors,
        ),
      ),
    );
  }
}
