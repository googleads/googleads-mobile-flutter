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

part of 'ad_containers.dart';

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

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// The buffer size for the preloader.
  final int bufferSize;

  /// Creates a [PreloadConfiguration].
  const PreloadConfiguration({
    required this.adUnitId,
    this.request = const AdRequest(),
    this.bufferSize = 2,
  });
}

/// A class managing the preloading of fullscreen ads.
class AdPreloader {
  AdPreloader._();

  static final Map<String, AdWithoutView Function()> _preloadedAds =
      <String, AdWithoutView Function()>{};

  static AdWithoutView? _createAd<T extends AdWithoutView>(
    PreloadConfiguration config,
  ) {
    if (T == InterstitialAd) {
      return InterstitialAd._(
        adUnitId: config.adUnitId,
        request: config.request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (_) {},
          onAdFailedToLoad: (_) {},
        ),
      );
    } else if (T == AdManagerInterstitialAd) {
      return AdManagerInterstitialAd._(
        adUnitId: config.adUnitId,
        request: config.request as AdManagerAdRequest,
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
          onAdLoaded: (_) {},
          onAdFailedToLoad: (_) {},
        ),
      );
    } else if (T == RewardedAd) {
      return RewardedAd._(
        adUnitId: config.adUnitId,
        request: config.request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (_) {},
          onAdFailedToLoad: (_) {},
        ),
      );
    } else if (T == RewardedInterstitialAd) {
      return RewardedInterstitialAd._(
        adUnitId: config.adUnitId,
        request: config.request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (_) {},
          onAdFailedToLoad: (_) {},
        ),
      );
    } else if (T == AppOpenAd) {
      return AppOpenAd._(
        adUnitId: config.adUnitId,
        request: config.request,
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (_) {},
          onAdFailedToLoad: (_) {},
        ),
      );
    }
    return null;
  }

  /// Starts preloading ads for the given [preloadId] and [preloadConfiguration].
  static Future<void> start<T extends AdWithoutView>({
    required String preloadId,
    required PreloadConfiguration preloadConfiguration,
    required PreloadCallback callback,
  }) async {
    _preloadedAds[preloadId] = () => _createAd<T>(preloadConfiguration)!;
    instanceManager.registerPreloadCallback(preloadId, callback);
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#startPreloading',
      <String, dynamic>{
        'preloadId': preloadId,
        'adUnitId': preloadConfiguration.adUnitId,
        'bufferSize': preloadConfiguration.bufferSize,
        'request': preloadConfiguration.request,
        'className': T.toString(),
      },
    );
  }

  /// Polls a preloaded ad for the given [preloadId].
  static Future<T?> pollAd<T extends AdWithoutView>(String preloadId) async {
    final int adId = instanceManager.nextAdId();
    final Map<dynamic, dynamic>? res =
        await instanceManager.channel.invokeMethod<Map<dynamic, dynamic>>(
      'MobileAds#pollAd',
      <String, dynamic>{
        'preloadId': preloadId,
        'className': T.toString(),
        'adId': adId,
      },
    );

    if (res != null) {
      final String adUnitId = res['adUnitId'] as String? ?? '';
      final T? ad = _preloadedAds[preloadId]?.call() as T? ??
          _createAd<T>(PreloadConfiguration(adUnitId: adUnitId)) as T?;
      if (ad != null) {
        instanceManager.trackAd(ad, adId);
        return ad;
      }
    }
    return null;
  }

  /// Destroys the preloader for the given [preloadId].
  static Future<void> destroy<T extends AdWithoutView>(String preloadId) async {
    _preloadedAds.remove(preloadId);
    instanceManager.unregisterPreloadCallback(preloadId);
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#destroyPreloader',
      <String, dynamic>{
        'preloadId': preloadId,
        'className': T.toString(),
      },
    );
  }

  /// Destroys all preloaders for the given class type [T].
  static Future<void> destroyAll<T extends AdWithoutView>() async {
    _preloadedAds.removeWhere((String key, AdWithoutView Function() factory) => factory() is T);
    instanceManager.clearAllPreloadCallbacks();
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#destroyAllPreloaders',
      <String, dynamic>{
        'className': T.toString(),
      },
    );
  }

  /// Checks if an ad is available for the given [preloadId].
  static Future<bool> isAdAvailable<T extends AdWithoutView>(String preloadId) async {
    final bool? available = await instanceManager.channel.invokeMethod<bool>(
      'MobileAds#isPreloadedAdAvailable',
      <String, dynamic>{
        'preloadId': preloadId,
        'className': T.toString(),
      },
    );
    return available ?? false;
  }
}
