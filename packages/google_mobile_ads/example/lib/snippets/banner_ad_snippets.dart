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

// ignore_for_file: public_member_api_docs, unused_field, unused_element

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dart snippets for the developer guide.
class _BannerAdWidget extends StatefulWidget {
  const _BannerAdWidget();

  @override
  State<_BannerAdWidget> createState() => _BannerAdSnippets();
}

class _BannerAdSnippets extends State<_BannerAdWidget> {
  BannerAd? _bannerAd;
  final _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';
  final String _adManagerAdUnitId = '/21775744923/example/adaptive-banner';

  // [START load_ad]
  void _loadAd() async {
    // [START get_ad_size]
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );
    // [END get_ad_size]

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    unawaited(
      BannerAd(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            // Called when an ad is successfully received.
            debugPrint('Ad was loaded.');
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            // Called when an ad request failed.
            debugPrint('Ad failed to load with error: $err');
            ad.dispose();
          },
          // [START_EXCLUDE silent]
          // [START ad_events]
          onAdOpened: (Ad ad) {
            // Called when an ad opens an overlay that covers the screen.
            debugPrint('Ad was opened.');
          },
          onAdClosed: (Ad ad) {
            // Called when an ad removes an overlay that covers the screen.
            debugPrint('Ad was closed.');
          },
          onAdImpression: (Ad ad) {
            // Called when an impression occurs on the ad.
            debugPrint('Ad recorded an impression.');
          },
          onAdClicked: (Ad ad) {
            // Called when a click event occurs on the ad.
            debugPrint('Ad was clicked.');
          },
          onAdWillDismissScreen: (Ad ad) {
            // iOS only. Called before dismissing a full screen view.
            debugPrint('Ad will be dismissed.');
          },
          // [END ad_events]
          // [END_EXCLUDE]
        ),
      ).load(),
    );
  }
  // [END load_ad]

  // ===================================================================
  // Ad Manager snippets
  // ===================================================================

  // [START load_ad_ad_manager]
  void _loadAdManagerBannerAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    unawaited(
      BannerAd(
        adUnitId: _adUnitId,
        request: const AdManagerAdRequest(),
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            // Called when an ad is successfully received.
            debugPrint('Ad was loaded.');
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            // Called when an ad request failed.
            debugPrint('Ad failed to load with error: $err');
            ad.dispose();
          },
        ),
      ).load(),
    );
  }
  // [END load_ad_ad_manager]

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // [START display_ad]
        if (_bannerAd != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          ),
        // [END display_ad]
      ],
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
