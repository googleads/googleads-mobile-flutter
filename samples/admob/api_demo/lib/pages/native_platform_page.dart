import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// An example page that loads a platform-rendered native ad (Android XML / iOS XIB).
class NativePlatformPage extends StatefulWidget {
  const NativePlatformPage({super.key});

  @override
  State<NativePlatformPage> createState() => _NativePlatformPageState();
}

class _NativePlatformPageState extends State<NativePlatformPage> {
  final _consentManager = ConsentManager.instance;
  final double _nativeAdHeight = Platform.isAndroid ? 320 : 300;
  var _isPrivacyOptionsRequired = false;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Platform Ad'),
        actions: _appBarActions(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              const Text(
                'Platform-Rendered Native Ad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Rendered using native layouts: Android XML layout and iOS XIB layout registered via NativeAdFactory.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: _nativeAdHeight,
                      width: MediaQuery.of(context).size.width,
                      child: !_nativeAdIsLoaded
                          ? const Center(child: CircularProgressIndicator())
                          : null,
                    ),
                    if (_nativeAdIsLoaded && _nativeAd != null)
                      SizedBox(
                        height: _nativeAdHeight,
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _nativeAd!),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAd,
                child: const Text('Refresh Ad'),
              ),
              const SizedBox(height: 12),
              FutureBuilder<String>(
                future: MobileAds.instance.getVersionString(),
                builder: (context, snapshot) {
                  var versionString = snapshot.data ?? '';
                  return Text(
                    'GMA SDK: $versionString',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ],
          ),
        ),
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

  /// Loads a native ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    setState(() {
      _nativeAdIsLoaded = false;
    });
    _nativeAd?.dispose();
    _nativeAd = null;

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAd loaded.');
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failedToLoad: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = false;
            });
          }
        },
        onAdClicked: (ad) => debugPrint('NativeAd clicked.'),
        onAdImpression: (ad) => debugPrint('NativeAd recorded impression.'),
        onAdClosed: (ad) => debugPrint('NativeAd closed.'),
        onAdOpened: (ad) => debugPrint('NativeAd opened.'),
        onAdWillDismissScreen: (ad) => debugPrint('NativeAd will dismiss.'),
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
    )..load();
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
    _nativeAd?.dispose();
    super.dispose();
  }
}
