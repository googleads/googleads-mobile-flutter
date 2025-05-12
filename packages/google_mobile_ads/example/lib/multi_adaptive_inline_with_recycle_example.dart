import 'dart:io';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MultiInlineAdaptiveWithRecycleExample extends StatefulWidget {
  const MultiInlineAdaptiveWithRecycleExample({super.key});

  @override
  State<StatefulWidget> createState() => _MultiInlineAdaptiveWithRecycleExampleState();
}

class _MultiInlineAdaptiveWithRecycleExampleState extends State<MultiInlineAdaptiveWithRecycleExample> {

  // A list of all the banners created.
  final List<BannerAd> _banners = [];
  // Keep track of sizes of the banners (since they can be different sizes).
  final Map<BannerAd, AdSize> _bannerSizes = {};

  // The maximum number of banners we create.
  static const _cacheSize = 10;
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
          final AdSize? adSize = await bannerAd.getPlatformAdSize();
          // When the banner size is updated, we want to rebuild.
          if (adSize != null && adSize != _bannerSizes[bannerAd]) {
            setState(() {
              _bannerSizes[bannerAd] = adSize;
            });
          }
        },
      ),
    );
    bannerAd.load();
    return bannerAd;
  }

  BannerAd _getRecycledBannerAd(int bannerPosition) {
    // If we already created a banner for this position, just reuse it.
    BannerAd? bannerAd = _banners.firstWhereOrNull((banner) => _bannerPositions[banner] == bannerPosition);
    if (bannerAd != null) {
      return bannerAd;
    }

    // If the cache is not full, create a new banner
    if (_banners.length < _cacheSize) {
      BannerAd bannerAd = _createBannerAd();
      _banners.add(bannerAd);
      _bannerPositions[bannerAd] = bannerPosition;
      return bannerAd;
    }

    // Now the cache is full, we should recycle the banner (if possible).
    BannerAd banner = _banners[bannerPosition % _cacheSize];
    if (banner.isMounted) {
      // Create a new banner if it's not possible to recycle the banner
      // e.g. show 15 banners on screen, but _cacheSize is only 10.
      return _createBannerAd();
    } else {
      // Found a recyclable banner, mark it as being used by current banner position.
      _bannerPositions[banner] = bannerPosition;
      return banner;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adaptive Size, Recycle')),
      body: ListView.builder(
        // Arbitrary example of 1000 items in the list.
        itemCount: 1000,
        itemBuilder: (BuildContext context, int index) {
          // We show a banner every 3 rows (i.e. row index 0, 3, 6, 9, 12, etc will be banner row)
          if (index % 3 == 0) {
            int bannerPosition = index ~/ 3;
            BannerAd bannerAd = _getRecycledBannerAd(bannerPosition);
            final AdSize? adSize = _bannerSizes[bannerAd];
            if (adSize == null) {
              // Null adSize means the banner's content is not fetched yet.
              return SizedBox(height: 50, child: Text("banner is loading"));
            } else {
              // Now this banner is loaded with ad content and corresponding ad size.
              return SizedBox(width: adSize.width.toDouble(), height: adSize.height.toDouble(), child: AdWidget(ad: bannerAd));
            }
          } else {
            // Show your regular non-ad content.
            return SizedBox(height: 200, child: ColoredBox(color: Colors.yellow));
          }
        }),
    );
  }
}