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
  final void Function(String preloadId, ResponseInfo responseInfo)?
  onAdPreloaded;

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

/// An internal class managing the preloading of fullscreen ads.
abstract class _AdPreloader {
  static final Map<String, PreloadableAd Function()> _preloadedAds =
      <String, PreloadableAd Function()>{};

  static PreloadableAd? _createAd<T extends PreloadableAd>(
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
    } else if (T == RewardedAd) {
      return RewardedAd._(
        adUnitId: config.adUnitId,
        request: config.request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
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
  static Future<void> start<T extends PreloadableAd>({
    required String preloadId,
    required PreloadConfiguration preloadConfiguration,
    required PreloadCallback callback,
  }) async {
    _preloadedAds[preloadId] = () => _createAd<T>(preloadConfiguration)!;
    instanceManager.registerPreloadCallback(preloadId, callback);
    await instanceManager.channel
        .invokeMethod<void>('MobileAds#startPreloading', <String, dynamic>{
          'preloadId': preloadId,
          'adUnitId': preloadConfiguration.adUnitId,
          'bufferSize': preloadConfiguration.bufferSize,
          'request': preloadConfiguration.request,
          'className': T.toString(),
        });
  }

  /// Polls a preloaded ad for the given [preloadId].
  static Future<T?> pollAd<T extends PreloadableAd>(String preloadId) async {
    final int adId = instanceManager.nextAdId();
    final Map<dynamic, dynamic>? res = await instanceManager.channel
        .invokeMethod<Map<dynamic, dynamic>>(
          'MobileAds#pollAd',
          <String, dynamic>{
            'preloadId': preloadId,
            'className': T.toString(),
            'adId': adId,
          },
        );

    if (res != null) {
      final String adUnitId = res['adUnitId'] as String? ?? '';
      final T? ad =
          _preloadedAds[preloadId]?.call() as T? ??
          _createAd<T>(PreloadConfiguration(adUnitId: adUnitId)) as T?;
      if (ad != null) {
        instanceManager.trackAd(ad, adId);
        return ad;
      }
    }
    return null;
  }

  /// Destroys the preloader for the given [preloadId].
  static Future<void> destroy<T extends PreloadableAd>(String preloadId) async {
    _preloadedAds.remove(preloadId);
    instanceManager.unregisterPreloadCallback(preloadId);
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#destroyPreloader',
      <String, dynamic>{'preloadId': preloadId, 'className': T.toString()},
    );
  }

  /// Destroys all preloaders for the given class type [T].
  static Future<void> destroyAll<T extends PreloadableAd>() async {
    _preloadedAds.removeWhere(
      (String key, PreloadableAd Function() factory) => factory() is T,
    );
    instanceManager.clearAllPreloadCallbacks();
    await instanceManager.channel.invokeMethod<void>(
      'MobileAds#destroyAllPreloaders',
      <String, dynamic>{'className': T.toString()},
    );
  }

  /// Checks if an ad is available for the given [preloadId].
  static Future<bool> isAdAvailable<T extends PreloadableAd>(
    String preloadId,
  ) async {
    final bool? available = await instanceManager.channel.invokeMethod<bool>(
      'MobileAds#isPreloadedAdAvailable',
      <String, dynamic>{'preloadId': preloadId, 'className': T.toString()},
    );
    return available ?? false;
  }

  /// Returns the number of preloaded ads available for the given [preloadId].
  static Future<int> getNumAdsAvailable<T extends PreloadableAd>(
    String preloadId,
  ) async {
    final int? count = await instanceManager.channel.invokeMethod<int>(
      'MobileAds#getNumAdsAvailable',
      <String, dynamic>{'preloadId': preloadId, 'className': T.toString()},
    );
    return count ?? 0;
  }

  /// Returns the configuration for the given [preloadId].
  static Future<PreloadConfiguration?>
  getConfiguration<T extends PreloadableAd>(String preloadId) async {
    final Map<dynamic, dynamic>? map = await instanceManager.channel
        .invokeMethod<Map<dynamic, dynamic>>(
          'MobileAds#getPreloadConfiguration',
          <String, dynamic>{'preloadId': preloadId, 'className': T.toString()},
        );
    if (map == null) {
      return null;
    }
    return PreloadConfiguration(
      adUnitId: map['adUnitId'] as String,
      bufferSize: map['bufferSize'] as int,
      request: const AdRequest(),
    );
  }

  /// Returns all active configurations.
  static Future<Map<String, PreloadConfiguration>>
  getConfigurations<T extends PreloadableAd>() async {
    final Map<dynamic, dynamic>? map = await instanceManager.channel
        .invokeMethod<Map<dynamic, dynamic>>(
          'MobileAds#getPreloadConfigurations',
          <String, dynamic>{'className': T.toString()},
        );
    if (map == null) {
      return <String, PreloadConfiguration>{};
    }
    final Map<String, PreloadConfiguration> result =
        <String, PreloadConfiguration>{};
    for (final MapEntry<dynamic, dynamic> entry in map.entries) {
      final String key = entry.key as String;
      final Map<dynamic, dynamic> configMap =
          entry.value as Map<dynamic, dynamic>;
      result[key] = PreloadConfiguration(
        adUnitId: configMap['adUnitId'] as String,
        bufferSize: configMap['bufferSize'] as int,
        request: const AdRequest(),
      );
    }
    return result;
  }
}

/// A preloader for [InterstitialAd]s.
abstract class InterstitialAdPreloader extends _AdPreloader {
  /// Starts preloading ads for the given [preloadId] and [preloadConfiguration].
  static Future<void> start({
    required String preloadId,
    required PreloadConfiguration preloadConfiguration,
    required PreloadCallback callback,
  }) {
    return _AdPreloader.start<InterstitialAd>(
      preloadId: preloadId,
      preloadConfiguration: preloadConfiguration,
      callback: callback,
    );
  }

  /// Polls a preloaded ad for the given [preloadId].
  static Future<InterstitialAd?> pollAd(String preloadId) {
    return _AdPreloader.pollAd<InterstitialAd>(preloadId);
  }

  /// Destroys the preloader for the given [preloadId].
  static Future<void> destroy(String preloadId) {
    return _AdPreloader.destroy<InterstitialAd>(preloadId);
  }

  /// Destroys all preloaders of this format.
  static Future<void> destroyAll() {
    return _AdPreloader.destroyAll<InterstitialAd>();
  }

  /// Checks if an ad is available for the given [preloadId].
  static Future<bool> isAdAvailable(String preloadId) {
    return _AdPreloader.isAdAvailable<InterstitialAd>(preloadId);
  }

  /// Returns the number of preloaded ads available for the given [preloadId].
  static Future<int> getNumAdsAvailable(String preloadId) {
    return _AdPreloader.getNumAdsAvailable<InterstitialAd>(preloadId);
  }

  /// Returns the configuration for the given [preloadId].
  static Future<PreloadConfiguration?> getConfiguration(String preloadId) {
    return _AdPreloader.getConfiguration<InterstitialAd>(preloadId);
  }

  /// Returns all active configurations.
  static Future<Map<String, PreloadConfiguration>> getConfigurations() {
    return _AdPreloader.getConfigurations<InterstitialAd>();
  }
}

/// A preloader for [RewardedAd]s.
abstract class RewardedAdPreloader extends _AdPreloader {
  /// Starts preloading ads for the given [preloadId] and [preloadConfiguration].
  static Future<void> start({
    required String preloadId,
    required PreloadConfiguration preloadConfiguration,
    required PreloadCallback callback,
  }) {
    return _AdPreloader.start<RewardedAd>(
      preloadId: preloadId,
      preloadConfiguration: preloadConfiguration,
      callback: callback,
    );
  }

  /// Polls a preloaded ad for the given [preloadId].
  static Future<RewardedAd?> pollAd(String preloadId) {
    return _AdPreloader.pollAd<RewardedAd>(preloadId);
  }

  /// Destroys the preloader for the given [preloadId].
  static Future<void> destroy(String preloadId) {
    return _AdPreloader.destroy<RewardedAd>(preloadId);
  }

  /// Destroys all preloaders of this format.
  static Future<void> destroyAll() {
    return _AdPreloader.destroyAll<RewardedAd>();
  }

  /// Checks if an ad is available for the given [preloadId].
  static Future<bool> isAdAvailable(String preloadId) {
    return _AdPreloader.isAdAvailable<RewardedAd>(preloadId);
  }

  /// Returns the number of preloaded ads available for the given [preloadId].
  static Future<int> getNumAdsAvailable(String preloadId) {
    return _AdPreloader.getNumAdsAvailable<RewardedAd>(preloadId);
  }

  /// Returns the configuration for the given [preloadId].
  static Future<PreloadConfiguration?> getConfiguration(String preloadId) {
    return _AdPreloader.getConfiguration<RewardedAd>(preloadId);
  }

  /// Returns all active configurations.
  static Future<Map<String, PreloadConfiguration>> getConfigurations() {
    return _AdPreloader.getConfigurations<RewardedAd>();
  }
}

/// A preloader for [AppOpenAd]s.
abstract class AppOpenAdPreloader extends _AdPreloader {
  /// Starts preloading ads for the given [preloadId] and [preloadConfiguration].
  static Future<void> start({
    required String preloadId,
    required PreloadConfiguration preloadConfiguration,
    required PreloadCallback callback,
  }) {
    return _AdPreloader.start<AppOpenAd>(
      preloadId: preloadId,
      preloadConfiguration: preloadConfiguration,
      callback: callback,
    );
  }

  /// Polls a preloaded ad for the given [preloadId].
  static Future<AppOpenAd?> pollAd(String preloadId) {
    return _AdPreloader.pollAd<AppOpenAd>(preloadId);
  }

  /// Destroys the preloader for the given [preloadId].
  static Future<void> destroy(String preloadId) {
    return _AdPreloader.destroy<AppOpenAd>(preloadId);
  }

  /// Destroys all preloaders of this format.
  static Future<void> destroyAll() {
    return _AdPreloader.destroyAll<AppOpenAd>();
  }

  /// Checks if an ad is available for the given [preloadId].
  static Future<bool> isAdAvailable(String preloadId) {
    return _AdPreloader.isAdAvailable<AppOpenAd>(preloadId);
  }

  /// Returns the number of preloaded ads available for the given [preloadId].
  static Future<int> getNumAdsAvailable(String preloadId) {
    return _AdPreloader.getNumAdsAvailable<AppOpenAd>(preloadId);
  }

  /// Returns the configuration for the given [preloadId].
  static Future<PreloadConfiguration?> getConfiguration(String preloadId) {
    return _AdPreloader.getConfiguration<AppOpenAd>(preloadId);
  }

  /// Returns all active configurations.
  static Future<Map<String, PreloadConfiguration>> getConfigurations() {
    return _AdPreloader.getConfigurations<AppOpenAd>();
  }
}
