// ignore_for_file: avoid_print

import 'dart:io';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hive/hive.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/blocs/settings_bloc.dart';
import 'package:todoapp/config/config.dart';
import 'package:todoapp/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class AppService {
  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      internet = false;
    }
    return internet;
  }

  Future openLink(context, String url) async {
    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    } else {
      openToast1(context, "Can't launch the url");
    }
  }

  Future openEmailSupport() async {
    await urlLauncher.launch(
        'mailto:${Config.supportEmail}?subject=About ${Config.appName} App&body=');
  }

  Future openLinkWithCustomTab(BuildContext context, String url) async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: url,
        customTabsOptions: const CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.dark,
          addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: const SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
    } catch (e) {
      openToast1(context, 'Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future launchAppReview(context) async {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    LaunchReview.launch(
        androidAppId: sb.packageName,
        iOSAppId: Config.iOSAppID,
        writeReview: false);
    if (Platform.isIOS) {
      if (Config.iOSAppID == '000000') {
        openToast1(
            context, 'The iOS version is not available on the AppStore yet');
      }
    }
  }

  static getNormalText(String text) {
    return HtmlUnescape().convert(parse(text).documentElement!.text);
  }
}
