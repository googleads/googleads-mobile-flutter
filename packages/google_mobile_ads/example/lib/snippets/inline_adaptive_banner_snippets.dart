// Copyright 2026 Google LLC
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

// ignore_for_file: public_member_api_docs, unused_field, unused_element

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dart snippets for the developer guide.
class _InlineAdaptiveBannerWidget extends StatefulWidget {
  const _InlineAdaptiveBannerWidget();

  @override
  State<_InlineAdaptiveBannerWidget> createState() =>
      _InlineAdaptiveBannerSnippets();
}

class _InlineAdaptiveBannerSnippets extends State<_InlineAdaptiveBannerWidget> {
  final _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  // [START track_positions]
  // Maximum number of banner ad instances kept in the cache.
  static const int _cacheSize = 8;

  // Spacing between banner ads. For example, index 0, 6, 12, and so on
  // display ads.
  static const int _adInterval = 6;

  // The cache of allocated BannerAd instances.
  final List<BannerAd> _banners = [];

  // Maps each BannerAd instance to its currently assigned list item position.
  final Map<BannerAd, int> _bannerPositions = {};

  // Stores the platform-resolved size of each loaded banner ad.
  final Map<BannerAd, AdSize> _bannerSizes = {};
  // [END track_positions]

  // [START recycle_banner_ad]
  BannerAd _getRecycledBannerAd(BuildContext context, int bannerPosition) {
    // 1. If an ad is already mapped to this position, reuse it.
    final BannerAd? existingBanner = _bannerPositions.entries
        .firstWhereOrNull((entry) => entry.value == bannerPosition)
        ?.key;
    if (existingBanner != null) {
      return existingBanner;
    }

    // 2. If the cache is not full, allocate a new ad instance.
    if (_banners.length < _cacheSize) {
      final BannerAd newBanner = _createBannerAd(context);
      _banners.add(newBanner);
      _bannerPositions[newBanner] = bannerPosition;
      return newBanner;
    }

    // 3. Select an existing ad from the cache using modulo arithmetic.
    final BannerAd targetBanner = _banners[bannerPosition % _cacheSize];

    // 4. Verify the ad is detached from the screen before recycling.
    if (targetBanner.isMounted) {
      // If still on screen during fast scrolls, allocate a temporary instance.
      return _createBannerAd(context);
    } else {
      // Safe to reuse: reassign to the new position.
      _bannerPositions[targetBanner] = bannerPosition;
      return targetBanner;
    }
  }
  // [END recycle_banner_ad]

  // [START create_banner_ad]
  BannerAd _createBannerAd(BuildContext context) {
    final int width = MediaQuery.sizeOf(context).width.truncate();
    final AdSize adSize =
        AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(width);

    final BannerAd bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          // Inline adaptive banner heights are only known after the ad loads,
          // so store the platform-resolved size and rebuild.
          final BannerAd loadedBanner = ad as BannerAd;
          final AdSize? platformSize = await loadedBanner.getPlatformAdSize();
          if (mounted) {
            setState(() {
              _bannerSizes[loadedBanner] = platformSize ?? adSize;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner failed to load: $error');
        },
      ),
    );

    bannerAd.load();
    return bannerAd;
  }
  // [END create_banner_ad]

  // [START display_ads_in_list]
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 200,
      itemBuilder: (BuildContext context, int index) {
        // Display an ad every _adInterval items.
        if (index % _adInterval == 0) {
          final int bannerPosition = index ~/ _adInterval;
          final BannerAd bannerAd = _getRecycledBannerAd(
            context,
            bannerPosition,
          );
          final AdSize? adSize = _bannerSizes[bannerAd];

          // The ad has not resolved its size yet.
          if (adSize == null) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          );
        }

        return ListTile(title: Text('List item #$index'));
      },
    );
  }
  // [END display_ads_in_list]

  // [START dispose_ads]
  @override
  void dispose() {
    for (final BannerAd banner in _banners) {
      banner.dispose();
    }
    _banners.clear();
    _bannerPositions.clear();
    _bannerSizes.clear();
    super.dispose();
  }
  // [END dispose_ads]
}
