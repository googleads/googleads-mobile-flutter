// Copyright 2025 Google LLC
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

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dart snippets for the developer guide.
class _BannerAdSnippets {
  BannerAd? _bannerAd;
  final _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';
  final _adManagerAdUnitId = '/21775744923/example/adaptive-banner';

// ===================================================================
// Ad Manager snippets
// ===================================================================

  // [START load_ad_ad_manager]
  void _loadAd(BuildContext context) async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    unawaited(BannerAd(
      adUnitId: _adUnitId,
      request: const AdManagerAdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          // setState(() {
          //   _bannerAd = ad as BannerAd;
          // });
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $err');
          ad.dispose();
        },
      ),
    ).load());
  }
  // [END load_ad_ad_manager]
}
