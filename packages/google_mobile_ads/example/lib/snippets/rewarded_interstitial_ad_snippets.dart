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
class _RewardedInterstitialAdSnippets {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-3940256099942544/6978759866';
  final String _adManagerAdUnitId =
      '/21775744923/example/rewarded-interstitial';

  void _loadRewardedInterstitialAd() {
    // [START load_ad]
    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedInterstitialAd = ad;
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

  void _setFullScreenContentCallback(RewardedInterstitialAd ad) {
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

  void _validateServerSideVerification() {
    // [START validate_server_side_verification]
    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ServerSideVerificationOptions _options =
              ServerSideVerificationOptions(
                  customData: 'SAMPLE_CUSTOM_DATA_STRING');
          ad.setServerSideOptions(_options);
          _rewardedInterstitialAd = ad;
        },
        onAdFailedToLoad: (error) {},
      ),
    );
    // [END validate_server_side_verification]
  }

// ===================================================================
// Ad Manager snippets
// ===================================================================

  void _loadAdManagerRewardedInterstitialAd() {
    // [START load_ad_ad_manager]
    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdManagerAdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedInterstitialAd = ad;
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
    // [END load_ad_ad_manager]
  }

  void _validateAdManagerServerSideVerification() {
    // [START validate_server_side_verification_ad_manager]
    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: AdManagerAdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ServerSideVerificationOptions _options =
              ServerSideVerificationOptions(
                  customData: 'SAMPLE_CUSTOM_DATA_STRING');
          ad.setServerSideOptions(_options);
          _rewardedInterstitialAd = ad;
        },
        onAdFailedToLoad: (error) {},
      ),
    );
    // [END validate_server_side_verification_ad_manager]
  }
}
