import 'dart:io';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This example demonstrates inline adaptive ads in a list view, where banners
/// are recycle to improve performance.
class MultiInlineAdaptiveWithRecycleExample extends StatefulWidget {
  @override
  _MultiInlineAdaptiveWithRecycleExampleState createState() =>
      _MultiInlineAdaptiveWithRecycleExampleState();
}

class _MultiInlineAdaptiveWithRecycleExampleState
    extends State<MultiInlineAdaptiveWithRecycleExample> {
  // A list of all the banners created.
  final List<BannerAd> _banners = [];
  // Keep track of sizes of the banners (since they can be different sizes).
  final Map<BannerAd, AdSize> _bannerSizes = {};
  // A set of all failed banners to retry.
  final Set<BannerAd> _failedBanners = {};

  // The maximum number of banners to create.
  static const int _cacheSize = 10;
  // Show a banner every 3 rows (i.e. row index 0, 3, 6, 9 etc will be banner rows.
  static const int _adInterval = 3;
  // Keep track of the positions of banners.
  final Map<BannerAd, int> _bannerPositions = {};

  BannerAd _createBannerAd() {
    final String bannerId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    AdSize adSize = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(360);
    final BannerAd bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          BannerAd bannerAd = (ad as BannerAd);
          if (_failedBanners.contains(bannerAd)) {
            _failedBanners.remove(bannerAd);
          }
          final AdSize? adSize = await bannerAd.getPlatformAdSize();
          // When the banner size is updated, rebuild by calling setState.
          if (adSize != null && adSize != _bannerSizes[bannerAd]) {
            setState(() {
              _bannerSizes[bannerAd] = adSize;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _failedBanners.add(ad as BannerAd);
        },
        onAdImpression: (Ad ad) {
          print('Banner ad impression occurred.');
        },
      ),
    );
    bannerAd.load();
    return bannerAd;
  }

  BannerAd _getRecycledBannerAd(int bannerPosition) {
    // If already created a banner for current position, just reuse it.
    BannerAd? currentBannerAd = _bannerPositions.entries
        .firstWhereOrNull((entry) => entry.value == bannerPosition)
        ?.key;
    if (currentBannerAd != null) {
      return currentBannerAd;
    }

    if (_banners.length < _cacheSize) {
      // If the cache is not full, create a new banner
      BannerAd bannerAd = _createBannerAd();
      _banners.add(bannerAd);
      _bannerPositions[bannerAd] = bannerPosition;
      return bannerAd;
    }
    // If cache is full, recycle the banner (if possible).
    BannerAd bannerAd = _banners[bannerPosition % _cacheSize];
    if (_failedBanners.contains(bannerAd)) {
      // if it's failed previously, reload it.
      bannerAd.load();
      _failedBanners.remove(bannerAd);
    }
    if (bannerAd.isMounted) {
      // Create a new banner if it's not possible to recycle the banner
      // e.g. show 15 banners on screen, but _cacheSize is only 10.
      // This should be a corner case indicating _cacheSize should be increased.
      bannerAd = _createBannerAd();
    }
    _bannerPositions[bannerAd] = bannerPosition;
    return bannerAd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adaptive Size, Recycle')),
      body: ListView.builder(
          // Arbitrary example of 100 items in the list.
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            if (index % _adInterval == 0) {
              int bannerPosition = index ~/ _adInterval;
              BannerAd bannerAd = _getRecycledBannerAd(bannerPosition);
              final AdSize? adSize = _bannerSizes[bannerAd];
              if (adSize == null) {
                // Null adSize means the banner's content is not fetched yet.
                return SizedBox.shrink();
              }
              // Now this banner is loaded with ad content and corresponding ad size.
              return SizedBox(
                  width: adSize.width.toDouble(),
                  height: adSize.height.toDouble(),
                  child: AdWidget(ad: bannerAd));
            }

            // Show your regular non-ad content.
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: SizedBox(
                  height: 100, child: ColoredBox(color: Colors.yellow)),
            );
          }),
    );
  }

  @override
  void dispose() {
    for (final banner in _banners) {
      banner.dispose();
    }
    super.dispose();
  }
}
