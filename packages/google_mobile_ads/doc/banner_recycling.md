# Inline Banner Ad Recycling Guide

## Overview

When rendering inline banner ads within scrollable feeds (e.g. `ListView.builder`), creating a new ad instance for every position in the list can cause severe performance and memory regressions. 

Each banner ad is backed by an underlying native platform view (such as `WKWebView` on iOS and `WebView` on Android). Instantiating new ad instances indefinitely as the user scrolls leads to:
1. **Unbounded Memory Spikes**: Dozens or hundreds of web views retained in memory.
2. **WebKit / Process Terminations**: iOS aggressively kills apps that exceed native WebKit resource allocations.
3. **Dropped Frames & UI Stutter**: Allocation and teardown of heavy platform views on the main thread during scrolling.

To avoid these problems, developers should maintain a finite **Ad Pool / Cache** and **recycle** off-screen banner ads.

---

## The `isMounted` API

To safely reuse an ad view in Flutter, the framework must ensure that the ad's native platform view is not currently attached to the widget tree. Attempting to render an already-mounted ad widget in a second location causes a runtime view collision.

All mobile ads that render an inline platform view (`BannerAd`, `AdManagerBannerAd`, and `NativeAd`) implement the `AdWithView` interface and expose the `isMounted` getter:

```dart
bool get isMounted;
```

* `isMounted == true`: The ad's platform view is currently attached and rendering in an active `AdWidget` on screen.
* `isMounted == false`: The ad's platform view is detached from the widget tree and safe to recycle.

---

## Implementation Guide

### 1. State & Cache Structure

Maintain a fixed-size cache list of ad instances alongside tracking maps for list positions and resolved sizes:

```dart
class _FeedWithAdsState extends State<FeedWithAds> {
  // Maximum number of ads kept in the recycling pool.
  static const int _cacheSize = 8;

  // The pool of loaded ad instances.
  final List<BannerAd> _banners = [];

  // Maps each ad instance to its current position in the list.
  final Map<BannerAd, int> _bannerPositions = {};

  // Stores the platform-resolved size of each banner.
  final Map<BannerAd, AdSize> _bannerSizes = {};

  // Tracks banners that failed to load.
  final Set<BannerAd> _failedBanners = {};
```

### 2. Ad Factory

Instantiate inline adaptive banner ads matching the device width:

```dart
  BannerAd _createBannerAd(BuildContext context) {
    final int width = MediaQuery.sizeOf(context).width.truncate();
    final AdSize adSize =
        AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(width);

    late final BannerAd bannerAd;
    bannerAd = BannerAd(
      adUnitId: '<YOUR_AD_UNIT_ID>',
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
```

### 3. Safe Recycling Logic

When the `ListView` requests an ad for a given `bannerPosition`:

```dart
  BannerAd _getRecycledBannerAd(BuildContext context, int bannerPosition) {
    // 1. If an ad is already assigned to this position, return it.
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

    // 3. The cache is full: select an ad to recycle using modulo math.
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
```

### 4. Rendering in `ListView.builder`

Render the ad inside the `ListView.builder`, showing a banner ad every 6 rows (`index % 6 == 0`) and providing a placeholder while the ad size resolves:

```dart
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (BuildContext context, int index) {
        if (index % 6 == 0) {
          final int bannerPosition = index ~/ 6;
          final BannerAd bannerAd =
              _getRecycledBannerAd(context, bannerPosition);
          final AdSize? adSize = _bannerSizes[bannerAd];

          if (adSize == null || _failedBanners.contains(bannerAd)) {
            return const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SizedBox(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          );
        }

        return MyContentTile(index: index);
      },
    );
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
```

---

## Performance Benchmark

In profiling benchmarks, reusing off-screen banner ad views results in an approximate **23.6% CPU usage improvement** while keeping memory consumption flat and bounded regardless of feed scroll depth.

---

## Sample Applications

* **AdMob API Demo**: `samples/admob/api_demo/lib/pages/banner_recycling_page.dart`
* **Google Mobile Ads Package Example**: `packages/google_mobile_ads/example/lib/multi_adaptive_inline_with_recycle_example.dart`
