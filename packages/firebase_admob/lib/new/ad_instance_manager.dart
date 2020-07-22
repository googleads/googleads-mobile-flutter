import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quiver/collection.dart';

import 'firebase_admob.dart';

/// An [AdInstanceManager] for the [FirebaseAdMobPlugin].
///
/// Loads and disposes [BannerAds] and [InterstitialAds].
class AdInstanceManager {
  /// Default constructor, used by subclasses.
  AdInstanceManager(String channelName)
      : channel = MethodChannel(
          channelName,
          StandardMethodCodec(AdMessageCodec()),
        ) {
    assert(channel != null);

    channel.setMethodCallHandler((MethodCall call) async {
      assert(call.method == 'onAdEvent');

      final int adId = call.arguments['adId'];
      final String eventName = call.arguments['eventName'];

      final Ad ad = adFor(adId);
      if (ad != null) {
        _onAdEvent(ad, eventName);
      } else {
        debugPrint('$Ad with id `$adId` is not available for $eventName.');
      }
    });
  }

  void _onAdEvent(Ad ad, String eventName) {
    assert(ad != null);
    switch (eventName) {
      case 'onAdLoaded':
        ad.listener.onAdLoaded(ad);
        break;
      case 'onAdFailedToLoad':
        ad.listener.onAdFailedToLoad(ad);
        break;
      case 'onNativeAdClicked':
        ad.listener.onNativeAdClicked(ad);
        break;
      case 'onNativeAdImpression':
        ad.listener.onNativeAdImpression(ad);
        break;
      case 'onAdOpened':
        ad.listener.onAdOpened(ad);
        break;
      case 'onApplicationExit':
        ad.listener.onApplicationExit(ad);
        break;
      case 'onAdClosed':
        ad.listener.onAdClosed(ad);
        break;
      default:
        debugPrint('invalid ad event name: $eventName');
    }
  }

  static int _nextAdId = 0;
  final BiMap<int, Ad> _loadedAds = BiMap<int, Ad>();

  /// Invokes load and dispose calls.
  final MethodChannel channel;

  /// Returns null if an invalid [adId] was passed in.
  Ad adFor(int adId) => _loadedAds[adId];

  /// Returns null if an invalid [Ad] was passed in.
  int adIdFor(Ad ad) => _loadedAds.inverse[ad];

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadBannerAd(BannerAd ad) {
    if (adIdFor(ad) != null) {
      return null;
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    final Ad bannerAd = adFor(adId);
    return channel.invokeMethod<void>(
      'loadBannerAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': bannerAd.adUnitId,
        'request': ad.request,
        'size': ad.size,
      },
    );
  }

  /// TODO(cg021): Add documentation
  Future<void> loadInterstitialAd(InterstitialAd ad) {
    if (adIdFor(ad) != null) {
      return null;
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    final Ad interstitialAd = adFor(adId);
    return channel.invokeMethod<void>(
      'loadInterstitialAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': interstitialAd.adUnitId,
        'request': interstitialAd.request,
      },
    );
  }

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadNativeAd(NativeAd ad) {
    if (adIdFor(ad) != null) {
      return null;
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    final Ad nativeAd = adFor(adId);
    return channel.invokeMethod<void>(
      'loadNativeAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': nativeAd.adUnitId,
        'request': ad.request,
        'factoryId': ad.factoryId,
        'customOptions': ad.customOptions,
      },
    );
  }

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadRewardedAd(RewardedAd ad) {
    if (adIdFor(ad) != null) {
      return null;
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    final Ad rewardedAd = adFor(adId);
    return channel.invokeMethod<void>(
      'loadRewardedAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': rewardedAd.adUnitId,
        'request': rewardedAd.request,
      },
    );
  }

  /// Free the plugin resources associated with this ad.
  ///
  /// Disposing a banner ad that's been shown removes it from the screen.
  /// Interstitial ads can't be programmatically removed from view.
  Future<void> disposeAd(Ad ad) {
    final int adId = adIdFor(ad);
    final Ad disposedAd = _loadedAds.remove(adId);
    if (disposedAd == null) {
      return null;
    }
    return channel.invokeMethod<void>(
      'disposeAd',
      <dynamic, dynamic>{
        'adId': adId,
      },
    );
  }
}
