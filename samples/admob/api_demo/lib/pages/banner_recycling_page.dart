import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// An example page that demonstrates recycling inline adaptive banner ads in a
/// scrollable list view to optimize memory and performance.
class BannerRecyclingPage extends StatefulWidget {
  const BannerRecyclingPage({super.key});

  @override
  State<BannerRecyclingPage> createState() => _BannerRecyclingPageState();
}

class _BannerRecyclingPageState extends State<BannerRecyclingPage> {
  final _consentManager = ConsentManager.instance;
  var _isPrivacyOptionsRequired = false;

  // Maximum number of banner ads retained in memory.
  static const int _cacheSize = 8;

  // Cache of loaded banner ad instances.
  final List<BannerAd> _banners = [];

  // Maps each BannerAd instance to its currently assigned list item position.
  final Map<BannerAd, int> _bannerPositions = {};

  // Stores the resolved platform size for each loaded banner ad.
  final Map<BannerAd, AdSize> _bannerSizes = {};

  // Tracks banner ads that encountered a load error.
  final Set<BannerAd> _failedBanners = {};

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();
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

  /// Creates and loads a new [BannerAd] with inline adaptive sizing.
  BannerAd _createBannerAd(BuildContext context) {
    final int width = MediaQuery.sizeOf(context).width.truncate();
    final AdSize adSize =
        AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(width);

    late final BannerAd bannerAd;
    bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          final BannerAd loadedBanner = ad as BannerAd;
          _failedBanners.remove(loadedBanner);
          final AdSize? platformSize = await loadedBanner.getPlatformAdSize();
          if (mounted) {
            setState(() {
              _bannerSizes[loadedBanner] = platformSize ?? adSize;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner failed to load: $error');
          if (mounted) {
            setState(() {
              _failedBanners.add(ad as BannerAd);
            });
          }
        },
      ),
    );

    bannerAd.load();
    return bannerAd;
  }

  /// Retrieves a reusable banner ad from the cache, recycling an off-screen
  /// unmounted ad if the cache limit has been reached.
  BannerAd _getRecycledBannerAd(BuildContext context, int bannerPosition) {
    // 1. If an ad is already mapped to this exact position, return it.
    BannerAd? existingBanner;
    for (final banner in _banners) {
      if (_bannerPositions[banner] == bannerPosition) {
        existingBanner = banner;
        break;
      }
    }
    if (existingBanner != null) {
      if (_failedBanners.contains(existingBanner)) {
        existingBanner.load();
        _failedBanners.remove(existingBanner);
      }
      return existingBanner;
    }

    // 2. If the cache is not yet full, allocate a new ad instance.
    if (_banners.length < _cacheSize) {
      final BannerAd newBanner = _createBannerAd(context);
      _banners.add(newBanner);
      _bannerPositions[newBanner] = bannerPosition;
      return newBanner;
    }

    // 3. The cache is full; select an existing banner to recycle using modulo.
    final BannerAd targetBanner = _banners[bannerPosition % _cacheSize];

    // Check if the target banner is currently mounted on screen.
    if (targetBanner.isMounted) {
      // If the target banner is still actively visible (e.g. during fast scroll),
      // create a temporary new banner to avoid view collision crashes.
      return _createBannerAd(context);
    } else {
      // Safely reassign the unmounted banner to the new position.
      _bannerPositions[targetBanner] = bannerPosition;
      if (_failedBanners.contains(targetBanner)) {
        targetBanner.load();
        _failedBanners.remove(targetBanner);
      }
      return targetBanner;
    }
  }

  @override
  void dispose() {
    for (final BannerAd banner in _banners) {
      banner.dispose();
    }
    _banners.clear();
    _bannerPositions.clear();
    _bannerSizes.clear();
    _failedBanners.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Recycling'),
        actions: _appBarActions(),
      ),
      body: ListView.builder(
        itemCount: 200,
        itemBuilder: (BuildContext context, int index) {
          // Display an ad every 6 list items.
          if (index % 6 == 0) {
            final int bannerPosition = index ~/ 6;
            final BannerAd bannerAd = _getRecycledBannerAd(
              context,
              bannerPosition,
            );
            final AdSize? adSize = _bannerSizes[bannerAd];

            if (adSize == null || _failedBanners.contains(bannerAd)) {
              return Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.grey.shade200,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: adSize.width.toDouble(),
              height: adSize.height.toDouble(),
              child: AdWidget(ad: bannerAd),
            );
          }

          // Regular feed content card.
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text('${index + 1}'),
              ),
              title: Text('List Item #$index'),
              subtitle: const Text(
                'Scroll through to observe smooth ad view recycling in action.',
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _appBarActions() {
    final array = [AppBarItem(AppBarItem.adInpsectorText, 0)];

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
}
