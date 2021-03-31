import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants.dart';
import 'dart:io' show Platform;

/// This example demonstrates inline ads in a list view, where the ad objects
/// live for the lifetime of this widget. This differs from the example in
/// [main.dart], which creates a new ad object whenever an ad is to be displayed
/// in the ListView.
class ReusableInlineExample extends StatefulWidget {
  @override
  _ReusableInlineExampleState createState() => _ReusableInlineExampleState();
}

class _ReusableInlineExampleState extends State<ReusableInlineExample> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  PublisherBannerAd? _publisherBannerAd;
  bool _publisherBannerAdIsLoaded = false;

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Reusable Inline Ad Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              cacheExtent: 500,
              itemCount: 20,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 40,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final BannerAd? bannerAd = _bannerAd;
                if (index == 5 && _bannerAdIsLoaded && bannerAd != null) {
                  return Container(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd));
                }

                final PublisherBannerAd? publisherBannerAd = _publisherBannerAd;
                if (index == 10 &&
                    _publisherBannerAdIsLoaded &&
                    publisherBannerAd != null) {
                  return Container(
                      height: publisherBannerAd.sizes[0].height.toDouble(),
                      width: publisherBannerAd.sizes[0].width.toDouble(),
                      child: AdWidget(ad: _publisherBannerAd!));
                }

                final NativeAd? nativeAd = _nativeAd;
                if (index == 15 && _nativeAdIsLoaded && nativeAd != null) {
                  return Container(
                      width: 250, height: 350, child: AdWidget(ad: nativeAd));
                }

                return Text(
                  Constants.placeholderText,
                  style: TextStyle(fontSize: 24),
                );
              },
            ),
          ),
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
        listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
          onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
        ),
        request: AdRequest())
      ..load();

    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511',
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$NativeAd onApplicationExit.'),
      ),
    )..load();

    _publisherBannerAd = PublisherBannerAd(
      adUnitId: '/6499/example/banner',
      request: PublisherAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[AdSize.largeBanner],
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$PublisherBannerAd loaded.');
          setState(() {
            _publisherBannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$PublisherBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$PublisherBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$PublisherBannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) =>
            print('$PublisherBannerAd onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
    _publisherBannerAd?.dispose();
    _publisherBannerAd = null;
    _nativeAd?.dispose();
    _nativeAd = null;
  }
}
