import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// An example page that loads and displays an anchored adaptive banner ad.
class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  final _consentManager = ConsentManager.instance;
  var _isPrivacyOptionsRequired = false;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;
  Orientation? _currentOrientation;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Ad'),
        actions: _appBarActions(),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (_currentOrientation != orientation) {
            if (_currentOrientation != null) {
              _bannerAd?.dispose();
              _bannerAd = null;
              _bannerAdIsLoaded = false;
              _loadAd();
            } else {
              _loadAd();
            }
            _currentOrientation = orientation;
          }
          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Anchored Adaptive Banner',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Adapts size based on device width and orientation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _bannerAd?.dispose();
                          _bannerAd = null;
                          setState(() {
                            _bannerAdIsLoaded = false;
                          });
                          _loadAd();
                        },
                        child: const Text('Reload Banner Ad'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_bannerAdIsLoaded && _bannerAd != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
            ],
          );
        },
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
          switch (item.value) {
            case 0:
              MobileAds.instance.openAdInspector((error) {});
            case 1:
              _consentManager.showPrivacyOptionsForm((formError) {
                if (formError != null) {
                  debugPrint('${formError.errorCode}: ${formError.message}');
                }
              });
          }
        },
      ),
    ];
  }

  /// Loads an anchored adaptive banner ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    if (!mounted) {
      return;
    }

    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      return;
    }

    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Ad was loaded.');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _bannerAdIsLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Ad failed to load with error: $err');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('Ad was opened.'),
        onAdClosed: (Ad ad) => debugPrint('Ad was closed.'),
        onAdImpression: (Ad ad) => debugPrint('Ad recorded an impression.'),
        onAdClicked: (Ad ad) => debugPrint('Ad was clicked.'),
        onAdWillDismissScreen: (Ad ad) => debugPrint('Ad will be dismissed.'),
      ),
    ).load();
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
    _bannerAd?.dispose();
    super.dispose();
  }
}
