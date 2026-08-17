import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';
import '../common/countdown_timer.dart';

/// A dialog that counts down before showing a rewarded interstitial ad.
class AdDialog extends StatefulWidget {
  final VoidCallback showAd;

  const AdDialog({super.key, required this.showAd});

  @override
  State<AdDialog> createState() => _AdDialogState();
}

class _AdDialogState extends State<AdDialog> {
  final CountdownTimer _countdownTimer = CountdownTimer(5);

  @override
  void initState() {
    super.initState();
    _countdownTimer.addListener(() {
      if (!mounted) return;
      setState(() {
        if (_countdownTimer.isComplete) {
          Navigator.pop(context);
          widget.showAd();
        }
      });
    });
    _countdownTimer.start();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Watch an ad for 10 more coins'),
      content: Text(
        'Video starting in ${_countdownTimer.timeLeft} seconds...',
        style: const TextStyle(color: Colors.grey),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No thanks', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _countdownTimer.dispose();
    super.dispose();
  }
}

/// An example page that loads and displays a rewarded interstitial ad.
class RewardedInterstitialPage extends StatefulWidget {
  const RewardedInterstitialPage({super.key});

  @override
  State<RewardedInterstitialPage> createState() =>
      _RewardedInterstitialPageState();
}

class _RewardedInterstitialPageState extends State<RewardedInterstitialPage> {
  final _consentManager = ConsentManager.instance;
  final CountdownTimer _countdownTimer = CountdownTimer(5);
  var _coins = 0;
  var _gamePaused = false;
  var _gameOver = false;
  var _isPrivacyOptionsRequired = false;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-3940256099942544/6978759866';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();

    _countdownTimer.addListener(() {
      if (!mounted) return;
      setState(() {
        if (_countdownTimer.isComplete) {
          _coins += 1;
          _gameOver = true;
          showDialog(
            context: context,
            builder: (context) => AdDialog(
              showAd: () {
                _showAdCallback();
              },
            ),
          );
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

  void _showAdCallback() {
    _rewardedInterstitialAd?.show(
      onUserEarnedReward: (AdWithoutView view, RewardItem rewardItem) {
        debugPrint('Reward amount: ${rewardItem.amount}');
        if (mounted) {
          setState(() => _coins += rewardItem.amount.toInt());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewarded Interstitial Ad'),
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
                    'Survive the timer to earn a coin and trigger a rewarded interstitial prompt!',
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
                  FilledButton(
                    onPressed: () {
                      _startNewGame();
                      _loadAd();
                    },
                    child: const Text('Play Again'),
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

  /// Loads a rewarded interstitial ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('RewardedInterstitialAd loaded.');
          _rewardedInterstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) =>
                debugPrint('RewardedInterstitialAd showed full screen.'),
            onAdImpression: (ad) =>
                debugPrint('RewardedInterstitialAd recorded impression.'),
            onAdFailedToShowFullScreenContent: (ad, err) {
              debugPrint('RewardedInterstitialAd failed to show: $err');
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('RewardedInterstitialAd dismissed.');
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
            onAdClicked: (ad) => debugPrint('RewardedInterstitialAd clicked.'),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedInterstitialAd failed to load: $error');
          _rewardedInterstitialAd = null;
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
    _rewardedInterstitialAd?.dispose();
    _countdownTimer.dispose();
    super.dispose();
  }
}
