import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_dialog.dart';
import 'app_bar_item.dart';
import 'countdown_timer.dart';
import 'consent_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: RewardedInterstitialExample(),
  ));
}

/// An example app that loads a rewarded interstitial ad.
class RewardedInterstitialExample extends StatefulWidget {
  const RewardedInterstitialExample({super.key});

  @override
  RewardedInterstitialExampleState createState() =>
      RewardedInterstitialExampleState();
}

class RewardedInterstitialExampleState
    extends State<RewardedInterstitialExample> {
  final _consentManager = ConsentManager();
  final CountdownTimer _countdownTimer = CountdownTimer(5);
  var _coins = 0;
  var _gamePaused = false;
  var _gameOver = false;
  var _isMobileAdsInitializeCalled = false;
  var _isPrivacyOptionsRequired = false;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-3940256099942544/6978759866';

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint(
            "${consentGatheringError.errorCode}: ${consentGatheringError
                .message}");
      }

      // Kick off the first play of the "game".
      _startNewGame();

      // Check if a privacy options entry point is required.
      _getIsPrivacyOptionsRequired();

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();

    // Show an alert dialog when the timer reaches zero.
    _countdownTimer.addListener(() =>
        setState(() {
          if (_countdownTimer.isComplete) {
            showDialog(
                context: context,
                builder: (context) =>
                    AdDialog(showAd: () {
                      _gameOver = true;
                      _showAdCallback();
                    }));
            _coins += 1;
          }
        }));
  }

  void _startNewGame() {
    _countdownTimer.start();
    _gameOver = false;
    _gamePaused = false;
  }

  void _pauseGame() {
    if (_gameOver || _gamePaused) {
      return;
    }
    _countdownTimer.pause();
    _gamePaused = true;
  }

  void _resumeGame() {
    if (_gameOver || !_gamePaused) {
      return;
    }
    _countdownTimer.resume();
    _gamePaused = false;
  }

  void _showAdCallback() {
    _rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView view, RewardItem rewardItem) {
          // ignore: avoid_print
          print('Reward amount: ${rewardItem.amount}');
          setState(() => _coins += rewardItem.amount.toInt());
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rewarded Interstitial Example',
      home: Scaffold(
          appBar: AppBar(
              title: const Text('Rewarded Interstitial Example'),
              actions: _appBarActions()),
          body: Stack(
            children: [
              const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'The Impossible Game',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_countdownTimer.isComplete
                          ? 'Game over!'
                          : '${_countdownTimer.timeLeft} seconds left!'),
                      Visibility(
                        visible: _countdownTimer.isComplete,
                        child: TextButton(
                          onPressed: () {
                            _startNewGame();
                            _loadAd();
                          },
                          child: const Text('Play Again'),
                        ),
                      )
                    ],
                  )),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text('Coins: $_coins')),
              ),
            ],
          )),
    );
  }

  List<Widget> _appBarActions() {
    var array = [AppBarItem(AppBarItem.adInpsectorText, 0)];

    if (_isPrivacyOptionsRequired) {
      array.add(AppBarItem(AppBarItem.privacySettingsText, 1));
    }

    return <Widget>[
      PopupMenuButton<AppBarItem>(
          itemBuilder: (context) =>
              array
                  .map((item) =>
                  PopupMenuItem<AppBarItem>(
                    value: item,
                    child: Text(
                      item.label,
                    ),
                  ))
                  .toList(),
          onSelected: (item) {
            _pauseGame();
            switch (item.value) {
              case 0:
                MobileAds.instance.openAdInspector((error) {
                  // Error will be non-null if ad inspector closed due to an error.
                  _resumeGame();
                });
              case 1:
                _consentManager.showPrivacyOptionsForm((formError) {
                  if (formError != null) {
                    debugPrint("${formError.errorCode}: ${formError.message}");
                  }
                  _resumeGame();
                });
            }
          })
    ];
  }

  /// Loads a rewarded interstitial ad.
  void _loadAd() async {
    // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // the app's configured messages.
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    RewardedInterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback:
        RewardedInterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          _rewardedInterstitialAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedInterstitialAd failed to load: $error');
        }));
  }

  /// Redraw the app bar actions if a privacy options entry point is required.
  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      setState(() {
        _isPrivacyOptionsRequired = true;
      });
    }
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await _consentManager.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();

      // Load an ad.
      _loadAd();
    }
  }

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    _countdownTimer.dispose();
    super.dispose();
  }
}
