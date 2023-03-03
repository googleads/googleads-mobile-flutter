import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: NativeExample(),
  ));
}

/// A simple app that loads a native ad.
class NativeExample extends StatefulWidget {
  const NativeExample({super.key});

  @override
  NativeExampleState createState() => NativeExampleState();
}

class NativeExampleState extends State<NativeExample> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  String? _versionString;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();

    _loadAd();
    _loadVersionString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Native Example',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Native Example'),
            ),
            body: Center(
              child: Column(
                children: [
              Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width),
                    if (_nativeAdIsLoaded && _nativeAd != null)
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _nativeAd!))]),
                  TextButton(
                      onPressed: _loadAd, child: const Text("Refresh Ad")),
                  if (_versionString != null) Text(_versionString!)],
              ),
            )
            ));
  }

  /// Loads a native ad.
  void _loadAd() {
    setState(() {
      _nativeAdIsLoaded = false;
    });

    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        factoryId: 'adFactoryExample',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ignore: avoid_print
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
    )..load();
  }

  void _loadVersionString() {
    MobileAds.instance.getVersionString().then((value) {
      setState(() {
        _versionString = value;
      });
    });
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
