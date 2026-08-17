import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// An example page that loads and displays an interstitial ad.
class InterstitialPage extends StatefulWidget {
  const InterstitialPage({super.key});

  @override
  State<InterstitialPage> createState() => _InterstitialPageState();
}

class _InterstitialPageState extends State<InterstitialPage> {
  InterstitialAd? _interstitialAd;
  final _consentManager = ConsentManager.instance;
  final _gameLength = 5;
  var _gamePaused = false;
  var _gameOver = false;
  var _isPrivacyOptionsRequired = false;
  late var _counter = _gameLength;
  Timer? _timer;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();
    _startNewGame();
    _loadAd();
  }

  void _startNewGame() {
    _timer?.cancel();
    setState(() {
      _counter = _gameLength;
      _gameOver = false;
      _gamePaused = false;
    });
    _startTimer();
  }

  void _pauseGame() {
    if (_gameOver || _gamePaused) {
      return;
    }
    _timer?.cancel();
    _gamePaused = true;
  }

  void _resumeGame() {
    if (_gameOver || !_gamePaused) {
      return;
    }
    _startTimer();
    _gamePaused = false;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _counter--);

      if (_counter == 0) {
        _gameOver = true;
        timer.cancel();
        _showAlert(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interstitial Ad'),
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
                    'Survive the countdown to see an interstitial ad!',
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
                  _counter > 0 ? '$_counter seconds left!' : 'Game Over!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (_counter == 0)
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

  /// Loads an interstitial ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('InterstitialAd loaded.');
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) =>
                debugPrint('InterstitialAd showed full screen content.'),
            onAdFailedToShowFullScreenContent: (ad, err) {
              debugPrint('InterstitialAd failed to show with error: $err');
              ad.dispose();
              _interstitialAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('InterstitialAd was dismissed.');
              ad.dispose();
              _interstitialAd = null;
            },
            onAdImpression: (ad) =>
                debugPrint('InterstitialAd recorded an impression.'),
            onAdClicked: (ad) => debugPrint('InterstitialAd was clicked.'),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load with error: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('You lasted $_gameLength seconds!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_interstitialAd != null) {
                _interstitialAd?.show();
              } else {
                debugPrint('Interstitial ad was not ready yet.');
              }
            },
            child: const Text('OK'),
          ),
        ],
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
    _timer?.cancel();
    _interstitialAd?.dispose();
    super.dispose();
  }
}
