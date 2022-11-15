import 'countdownTimer.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
  final CountdownTimer _countdownTimer = CountdownTimer();
  var _showWatchVideoButton = false;
  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    _countdownTimer.addListener(() => setState(() {
          _showWatchVideoButton = _countdownTimer.isComplete();
        }));
    _startNewGame();

    super.initState();
  }

  void _startNewGame() {
    _loadAd();
    _countdownTimer.start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rewarded Example',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Rewarded Example'),
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
                      Text(_countdownTimer.isComplete()
                          ? 'Game over!'
                          : '${_countdownTimer.timeLeft} seconds left!'),
                      Visibility(
                        visible: _countdownTimer.isComplete(),
                        child: TextButton(
                          onPressed: () {
                            _startNewGame();
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
                                // Reward the user for watching an ad.
                              });
                            },
                            child: const Text(
                                'Watch video for additional 10 coins'),
                          ))
                    ],
                  )),
            ],
          )),
    );
  }

  /// Loads a rewarded ad.
  void _loadAd() {
    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _countdownTimer.removeListener(() {});
    super.dispose();
  }
}
