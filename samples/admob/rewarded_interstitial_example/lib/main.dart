import 'countdown_timer.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rewarded_interstitial_example/ad_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: RewardedInterstitialExample(),
  ));
}

/// A simple app that loads a rewarded interstitial ad.
class RewardedInterstitialExample extends StatefulWidget {
  const RewardedInterstitialExample({super.key});

  @override
  RewardedInterstitialExampleState createState() =>
      RewardedInterstitialExampleState();
}

class RewardedInterstitialExampleState
    extends State<RewardedInterstitialExample> {
  final CountdownTimer _countdownTimer = CountdownTimer(10);
  var _coins = 0;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-3940256099942544/6978759866';

  @override
  void initState() {
    super.initState();

    _countdownTimer.addListener(() => setState(() {
          if (_countdownTimer.isComplete) {
            showDialog(
                context: context,
                builder: (context) => AdDialog(showAd: () {
                      _showAdCallback();
                    }));
            _coins += 1;
          }
        }));
    _startNewGame();
  }

  void _startNewGame() {
    _loadAd();
    _countdownTimer.start();
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
          ),
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

  /// Loads a rewarded interstitial ad.
  void _loadAd() {
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

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    _countdownTimer.dispose();
    super.dispose();
  }
}
