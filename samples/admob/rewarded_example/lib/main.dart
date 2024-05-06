import 'countdown_timer.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'consent_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: RewardedExample(),
  ));
}

/// A simple app that loads a rewarded ad.
class RewardedExample extends StatefulWidget {
  const RewardedExample({super.key});

  @override
  RewardedExampleState createState() => RewardedExampleState();
}

class RewardedExampleState extends State<RewardedExample> {
  static const privacySettingsText = 'Privacy Settings';

  final _consentManager = ConsentManager();
  final CountdownTimer _countdownTimer = CountdownTimer();
  var _showWatchVideoButton = false;
  var _gamePaused = false;
  var _gameOver = false;
  var _isMobileAdsInitializeCalled = false;
  var _coins = 0;
  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint(
            "${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      // Kick off the first play of the "game".
      _startNewGame();

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();

    // Show the "Watch video" button when the timer reaches zero.
    _countdownTimer.addListener(() => setState(() {
          if (_countdownTimer.isComplete) {
            _gameOver = true;
            _showWatchVideoButton = true;
            _coins += 1;
          } else {
            _showWatchVideoButton = false;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rewarded Example',
      home: Scaffold(
          appBar: AppBar(
              title: const Text('Rewarded Example'),
              actions: _isMobileAdsInitializeCalled
                  ? _privacySettingsAppBarAction()
                  : null),
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
                      ),
                      Visibility(
                          visible: _showWatchVideoButton,
                          child: TextButton(
                            onPressed: () {
                              setState(() => _showWatchVideoButton = false);

                              _rewardedAd?.show(onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {
                                // ignore: avoid_print
                                print('Reward amount: ${rewardItem.amount}');
                                setState(
                                    () => _coins += rewardItem.amount.toInt());
                              });
                            },
                            child: const Text(
                                'Watch video for additional 10 coins'),
                          ))
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

  List<Widget> _privacySettingsAppBarAction() {
    return <Widget>[
      // Regenerate the options menu to include a privacy setting.
      FutureBuilder(
          future: _consentManager.isPrivacyOptionsRequired(),
          builder: (context, snapshot) {
            final bool visibility = snapshot.data ?? false;
            return Visibility(
                visible: visibility,
                child: PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == privacySettingsText) {
                      _pauseGame();
                      _consentManager.showPrivacyOptionsForm((formError) {
                        if (formError != null) {
                          debugPrint(
                              "${formError.errorCode}: ${formError.message}");
                        }
                        _resumeGame();
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        value: privacySettingsText,
                        child: Text(privacySettingsText))
                  ],
                ));
          })
    ];
  }

  /// Loads a rewarded ad.
  void _loadAd() async {
    // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // the app's configured messages.
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
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
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    var canRequestAds = await _consentManager.canRequestAds();
    if (canRequestAds) {
      setState(() {
        _isMobileAdsInitializeCalled = true;
      });

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();
      // Load an ad.
      _loadAd();
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _countdownTimer.dispose();
    super.dispose();
  }
}
