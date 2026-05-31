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

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_instance_manager.dart';

/// Callback interface for ad preloading events.
class PreloadCallback {
  /// Callback when an ad has been successfully preloaded.
  final void Function(String preloadId, ResponseInfo responseInfo)? onAdPreloaded;

  /// Callback when preloaded ads have been exhausted.
  final void Function(String preloadId)? onAdsExhausted;

  /// Callback when preloading an ad has failed.
  final void Function(String preloadId, AdError error)? onAdFailedToPreload;

  /// Creates a [PreloadCallback].
  const PreloadCallback({
    this.onAdPreloaded,
    this.onAdsExhausted,
    this.onAdFailedToPreload,
  });
}

/// Configuration class for ad preloading.
class PreloadConfiguration {
  /// The ad unit ID to preload ads for.
  final String adUnitId;

  /// The buffer size for the preloader.
  final int? bufferSize;

  /// Creates a [PreloadConfiguration].
  const PreloadConfiguration({
    required this.adUnitId,
    this.bufferSize,
  });
}

/// A class managing the preloading of interstitial ads.
class InterstitialAdPreloader {
  InterstitialAdPreloader._();

  /// Starts preloading ads for the given [preloadId] and [preloadConfiguration].
  static Future<void> start({
    required String preloadId,
    required PreloadConfiguration preloadConfiguration,
    required PreloadCallback callback,
  }) async {
    instanceManager.registerPreloadCallback(preloadId, callback);
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#startPreloading',
      <String, dynamic>{
        'preloadId': preloadId,
        'adUnitId': preloadConfiguration.adUnitId,
        'bufferSize': preloadConfiguration.bufferSize,
      },
    );
  }

  /// Destroys the preloader for the given [preloadId].
  static Future<void> destroy(String preloadId) async {
    instanceManager.unregisterPreloadCallback(preloadId);
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#destroyPreloader',
      <String, dynamic>{'preloadId': preloadId},
    );
  }

  /// Destroys all preloaders.
  static Future<void> destroyAll() async {
    instanceManager.clearAllPreloadCallbacks();
    await instanceManager.channel.invokeMethod<void>('MobileAds#destroyAllPreloaders');
  }

  /// Checks if an ad is available for the given [preloadId].
  static Future<bool> isAdAvailable(String preloadId) async {
    final bool? available = await instanceManager.channel.invokeMethod<bool>(
      'MobileAds#isPreloadedAdAvailable',
      <String, dynamic>{'preloadId': preloadId},
    );
    return available ?? false;
  }
}
