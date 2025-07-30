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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dart snippets for the developer guide.
class _InterstitialAdSnippets {
  InterstitialAd? _interstitialAd;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  void _loadInterstitialAd() {
    // [START load_ad]
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
          // [START_EXCLUDE silent]
          _setFullScreenContentCallback(ad);
          // [END_EXCLUDE]
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $error');
        },
      ),
    );
    // [END load_ad]
  }

  void _setFullScreenContentCallback(InterstitialAd ad) {
    // [START ad_events]
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        // Called when the ad showed the full screen content.
        debugPrint('Ad showed full screen content.');
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        // Called when the ad failed to show full screen content.
        debugPrint('Ad failed to show full screen content with error: $err');
        // Dispose the ad here to free resources.
        ad.dispose();
      },
      onAdDismissedFullScreenContent: (ad) {
        // Called when the ad dismissed full screen content.
        debugPrint('Ad was dismissed.');
        // Dispose the ad here to free resources.
        ad.dispose();
      },
      onAdImpression: (ad) {
        // Called when an impression occurs on the ad.
        debugPrint('Ad recorded an impression.');
      },
      onAdClicked: (ad) {
        // Called when a click is recorded for an ad.
        debugPrint('Ad was clicked.');
      },
    );
    // [END ad_events]
  }
}
