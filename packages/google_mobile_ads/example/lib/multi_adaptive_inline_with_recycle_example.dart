// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Demonstrates how to recycle inline adaptive banner ads in a scrollable list view.
///
/// ### Why Banner Recycling?
/// Each banner ad is backed by an underlying native platform view (such as
/// `WKWebView` on iOS or `WebView` on Android). In a long or infinite scrollable list,
/// creating a new ad instance for every position causes unbounded memory growth,
/// UI jank, and potential out-of-memory terminations.
///
/// By maintaining a finite cache pool of [BannerAd] instances and recycling off-screen
/// unmounted ads as the user scrolls, memory usage remains bounded and flat,
/// yielding significant CPU and memory efficiency improvements.
///
/// ### Safe View Recycling with `isMounted`
/// All mobile ad classes rendering platform views implement [AdWithView] and expose
/// the [AdWithView.isMounted] getter:
/// - `isMounted == true`: The ad's platform view is currently attached to an active [AdWidget].
/// - `isMounted == false`: The ad's platform view is detached and safe to reuse.
class MultiInlineAdaptiveWithRecycleExample extends StatefulWidget {
  const MultiInlineAdaptiveWithRecycleExample({super.key});

  @override
  _MultiInlineAdaptiveWithRecycleExampleState createState() =>
      _MultiInlineAdaptiveWithRecycleExampleState();
}

class _MultiInlineAdaptiveWithRecycleExampleState
    extends State<MultiInlineAdaptiveWithRecycleExample> {
  // 1. Cache & State Tracking
  // Maximum number of banner ad instances kept in the recycling pool.
  static const int _cacheSize = 8;

  // Spacing between banner ads (e.g. index 0, 6, 12, etc. will display ads).
  static const int _adInterval = 6;

  // The pool of allocated BannerAd instances.
  final List<BannerAd> _banners = [];

  // Maps each BannerAd instance to its currently assigned list item position.
  final Map<BannerAd, int> _bannerPositions = {};

  // Stores the platform-resolved size of each loaded banner ad.
  final Map<BannerAd, AdSize> _bannerSizes = {};

  // Tracks banner ads that encountered an error during loading.
  final Set<BannerAd> _failedBanners = {};

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// 2. Ad Factory
  /// Creates and loads a new [BannerAd] with inline adaptive sizing matching the screen width.
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

  /// 3. Safe Recycling Algorithm
  /// Retrieves a reusable banner ad from the cache or allocates a new one if below cache limit.
  BannerAd _getRecycledBannerAd(BuildContext context, int bannerPosition) {
    // Step 3a: If an ad is already mapped to this exact position, return it.
    final BannerAd? existingBanner = _bannerPositions.entries
        .firstWhereOrNull((entry) => entry.value == bannerPosition)
        ?.key;
    if (existingBanner != null) {
      if (_failedBanners.contains(existingBanner)) {
        existingBanner.load();
        _failedBanners.remove(existingBanner);
      }
      return existingBanner;
    }

    // Step 3b: If the cache pool is not yet full, allocate a new ad instance.
    if (_banners.length < _cacheSize) {
      final BannerAd newBanner = _createBannerAd(context);
      _banners.add(newBanner);
      _bannerPositions[newBanner] = bannerPosition;
      return newBanner;
    }

    // Step 3c: The cache is full. Select an existing ad to recycle using modulo arithmetic.
    final BannerAd targetBanner = _banners[bannerPosition % _cacheSize];

    // Step 3d: Check if the target ad is currently mounted on screen.
    // If the user scrolled very quickly, the target ad might still be rendering on-screen.
    if (targetBanner.isMounted) {
      // Create a temporary instance to avoid view collision crashes.
      return _createBannerAd(context);
    } else {
      // Safely reassign the off-screen unmounted banner to the new position.
      _bannerPositions[targetBanner] = bannerPosition;
      if (_failedBanners.contains(targetBanner)) {
        targetBanner.load();
        _failedBanners.remove(targetBanner);
      }
      return targetBanner;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Banner Recycling')),
      body: ListView.builder(
        itemCount: 200,
        itemBuilder: (BuildContext context, int index) {
          // 4. Render an ad every _adInterval items (index 0, 6, 12, etc.).
          if (index % _adInterval == 0) {
            final int bannerPosition = index ~/ _adInterval;
            final BannerAd bannerAd = _getRecycledBannerAd(
              context,
              bannerPosition,
            );
            final AdSize? adSize = _bannerSizes[bannerAd];

            // Render a placeholder while the ad content and dimensions resolve.
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

          // Regular feed content item.
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
}
