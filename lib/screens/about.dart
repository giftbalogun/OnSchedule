// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/blocs/ads_bloc.dart';
import 'package:todoapp/config/ad_config.dart';
import 'package:todoapp/config/config.dart';
import 'package:todoapp/services/app_service.dart';
import 'package:todoapp/widget/banner_ad.dart';
import 'package:todoapp/widget/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  double _rightPaddingValue = 140;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => context.read<AdsBloc>().showLoadedAds());
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        _rightPaddingValue = 10;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn('4', Icons.call, 'Apps'),
        _buildButtonColumn('54', Icons.near_me, 'Webistes'),
        _buildButtonColumn('15', Icons.share, 'Assists'),
      ],
    );

    Widget socialmedia = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialmedia(Icons.mail, 'Mail', () {
          AppService().openEmailSupport();
        }),
        _socialmedia(FontAwesomeIcons.instagram, 'Instagram', () {
          instagram();
        }),
        _socialmedia(FontAwesomeIcons.whatsapp, 'Whatsapp', () {
          whatsapp();
        }),
        _socialmedia(FontAwesomeIcons.telegram, 'Whatsapp', () {
          telegram();
        }),
        _socialmedia(Icons.call, 'Call', () {
          phone();
        }),
      ],
    );

    AppBar _buildAppBar() {
      return AppBar(
        title: Text(
          'About Developer',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Image.asset(
              'images/logot.png',
              height: 50,
            ),
            onPressed: null,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Config.appThemeColors,
      drawer: NavDrawer(),
      body: ListView(children: [
        title,
        buttonSection,
        Divider(
          height: 30,
          thickness: 10,
          indent: 20,
          endIndent: 20,
          color: getColorFromHex('#000000'),
        ),
        socialmedia,
        Divider(
          height: 30,
          thickness: 10,
          indent: 20,
          endIndent: 20,
          color: getColorFromHex('#000000'),
        ),
        textSection,
        ads,
        //AdConfig.isAdsEnabled == true ? BannerAdWidget() : Container(),
        website,
      ]),
    );
  }

  Widget title = Container(
    padding: const EdgeInsets.all(15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 100, //we give the image a radius of 50
                backgroundImage: AssetImage('images/icon.ico'),
              ),
              Divider(
                height: 30,
                //thickness: 10,
                indent: 20,
                endIndent: 20,
                color: getColorFromHex('#CD9491'),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: const Text(
                  'Hey, am Balogun Gift',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Full Stack Web Developer/Full Stack Mobile App Developer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget textSection = const Padding(
    padding: EdgeInsets.all(25),
    child: Text(
      'I am a Full Stack Web Developer and Full Stack Mobile App Developer, and'
      ' I enjoys learning new languages and frameworks.'
      'I am a problem solver with a bit touch of Critical Thinking and also '
      'improve total organizational productivity through various proactive approaches.',
      softWrap: true,
    ),
  );

  Widget ads = Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: AdConfig.isAdsEnabled == true ? BannerAdWidget() : Container(),
      ));

  static getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Widget website = Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                textStyle: const TextStyle(fontSize: 20),
                primary: getColorFromHex('#000000'),
                elevation: 2 // foreground
                ),
            onPressed: () {
              //openurl();
              AdsBloc().showInterstitialAd();
            },
            child: const Text('Visit My Website'),
          ),
        ],
      ));

  Column _buildButtonColumn(String number, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(number),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: getColorFromHex('#000000'),
            ),
          ),
        ),
      ],
    );
  }

  _socialmedia(icon, label, onTap) {
    Color color = getColorFromHex('#000000');
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void openurl() {
    String url1 = Config.websiteUrl;
    launch(url1);
  }

  static void instagram() {
    String url1 = Config.instagram;
    launch(url1);
  }

  static void whatsapp() {
    String url1 = Config.whatsapp;
    launch(url1);
  }

  static void telegram() {
    String url1 = Config.instagram;
    launch(url1);
  }

  //static void mail() {
  //  String url1 = "mailto:balogunigift@gmail.com";
  //  launch(url1);
  //}

  static void phone() {
    String url1 = "tel:+2347061601790";
    launch(url1);
  }
}
