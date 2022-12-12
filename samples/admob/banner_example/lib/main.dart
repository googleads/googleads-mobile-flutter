import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: BannerExample(),
  ));
}

/// A simple app that loads a banner ad.
class BannerExample extends StatefulWidget {
  const BannerExample({super.key});

  @override
  BannerExampleState createState() => BannerExampleState();
}

class BannerExampleState extends State<BannerExample> {
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  late final BannerAd _bannerAd = BannerAd(
    adUnitId: _adUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: _listener,
  );

  final BannerAdListener _listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {},
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) {},
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) {},
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) {},
  ); // BannerAdListener

  @override
  void initState() {
    super.initState();
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banner Example',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Banner Example'),
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
