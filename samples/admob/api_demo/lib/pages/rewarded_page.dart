import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';
import '../common/countdown_timer.dart';

/// An example page that loads and displays a rewarded ad.
class RewardedPage extends StatefulWidget {
  const RewardedPage({super.key});

  @override
  State<RewardedPage> createState() => _RewardedPageState();
}

class _RewardedPageState extends State<RewardedPage> {
  final _consentManager = ConsentManager.instance;
  final CountdownTimer _countdownTimer = CountdownTimer();
  var _showWatchVideoButton = false;
  var _gamePaused = false;
  var _gameOver = false;
  var _isPrivacyOptionsRequired = false;
  var _coins = 0;
  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();

    _countdownTimer.addListener(() {
      if (!mounted) return;
      setState(() {
        if (_countdownTimer.isComplete) {
          _gameOver = true;
          _showWatchVideoButton = true;
          _coins += 1;
        } else {
          _showWatchVideoButton = false;
        }
      });
    });

    _startNewGame();
    _loadAd();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewarded Ad'),
        actions: _appBarActions(),
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'The Impossible Game',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Survive the timer to earn a coin, then watch a rewarded ad for bonus coins!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _countdownTimer.isComplete
                      ? 'Game Over!'
                      : '${_countdownTimer.timeLeft} seconds left!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (_countdownTimer.isComplete)
                  OutlinedButton(
                    onPressed: () {
                      _startNewGame();
                      _loadAd();
                    },
                    child: const Text('Play Again'),
                  ),
                const SizedBox(height: 12),
                if (_showWatchVideoButton)
                  FilledButton(
                    onPressed: () {
                      setState(() => _showWatchVideoButton = false);
                      if (_rewardedAd != null) {
                        _rewardedAd?.show(
                          onUserEarnedReward:
                              (AdWithoutView ad, RewardItem rewardItem) {
                            debugPrint('Reward amount: ${rewardItem.amount}');
                            if (mounted) {
                              setState(() {
                                _coins += rewardItem.amount.toInt();
                              });
                            }
                          },
                        );
                      } else {
                        debugPrint('Rewarded ad was not ready.');
                      }
                    },
                    child: const Text('Watch video for additional 10 coins'),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Coins: $_coins',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActions() {
    var array = [AppBarItem(AppBarItem.adInpsectorText, 0)];

    if (_isPrivacyOptionsRequired) {
      array.add(AppBarItem(AppBarItem.privacySettingsText, 1));
    }

    return <Widget>[
      PopupMenuButton<AppBarItem>(
        itemBuilder: (context) => array
            .map(
              (item) => PopupMenuItem<AppBarItem>(
                value: item,
                child: Text(item.label),
              ),
            )
            .toList(),
        onSelected: (item) {
          _pauseGame();
          switch (item.value) {
            case 0:
              MobileAds.instance.openAdInspector((error) {
                _resumeGame();
              });
            case 1:
              _consentManager.showPrivacyOptionsForm((formError) {
                if (formError != null) {
                  debugPrint('${formError.errorCode}: ${formError.message}');
                }
                _resumeGame();
              });
          }
        },
      ),
    ];
  }

  /// Loads a rewarded ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('RewardedAd loaded.');
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) =>
                debugPrint('RewardedAd showed full screen content.'),
            onAdImpression: (ad) =>
                debugPrint('RewardedAd recorded an impression.'),
            onAdFailedToShowFullScreenContent: (ad, err) {
              debugPrint('RewardedAd failed to show: $err');
              ad.dispose();
              _rewardedAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('RewardedAd was dismissed.');
              ad.dispose();
              _rewardedAd = null;
            },
            onAdClicked: (ad) => debugPrint('RewardedAd clicked.'),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      if (mounted) {
        setState(() {
          _isPrivacyOptionsRequired = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _countdownTimer.dispose();
    super.dispose();
  }
}
