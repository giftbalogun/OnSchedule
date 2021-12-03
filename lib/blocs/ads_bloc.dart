// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

class AdsBloc extends ChangeNotifier {
  int _clickCounter = 0;
  int get clickCounter => _clickCounter;

  bool _isAdLoaded = false;
  bool get isAdLoaded => _isAdLoaded;

  InterstitialAd? _interstitialAd;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdConfig().getInterstitialAdUnitId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _isAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            _isAdLoaded = false;
            notifyListeners();
            createInterstitialAd();
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          _interstitialAd = null;
          _isAdLoaded = false;
          notifyListeners();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          _interstitialAd = null;
          _isAdLoaded = false;
          notifyListeners();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      notifyListeners();
    }
  }

  //enable only one
  void _showAd() {
    if (_isAdLoaded) {
      if (_clickCounter % AdConfig().userClicksAmountsToShowEachAd == 0) {
        showInterstitialAd();
      }
    }
  }

  //enable only one
  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  //enable only one
  initiateAds() {
    createInterstitialAd();
  }

  void _increaseClickCounter() {
    _clickCounter++;
    debugPrint('Clicks : $_clickCounter');
    notifyListeners();
  }

  showLoadedAds() {
    _increaseClickCounter();
    _showAd();
  }
}
