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

// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:collection';

import 'package:google_mobile_ads/src/mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'request_configuration.dart';
import 'ad_containers.dart';

/// Loads and disposes [BannerAds] and [InterstitialAds].
AdInstanceManager instanceManager = AdInstanceManager(
  'plugins.flutter.io/google_mobile_ads',
);

/// Maintains access to loaded [Ad] instances.
class AdInstanceManager {
  AdInstanceManager(String channelName)
      : channel = MethodChannel(
          channelName,
          StandardMethodCodec(AdMessageCodec()),
        ) {
    channel.setMethodCallHandler((MethodCall call) async {
      assert(call.method == 'onAdEvent');

      final int adId = call.arguments['adId'];
      final String eventName = call.arguments['eventName'];

      final Ad? ad = adFor(adId);
      if (ad != null) {
        _onAdEvent(ad, eventName, call.arguments);
      } else {
        debugPrint('$Ad with id `$adId` is not available for $eventName.');
      }
    });
  }

  int _nextAdId = 0;
  final _BiMap<int, Ad> _loadedAds = _BiMap<int, Ad>();
  final Set<Ad> _onAdLoadedAds = <Ad>{};

  bool onAdLoadedCalled(Ad ad) => _onAdLoadedAds.contains(ad);

  /// Invokes load and dispose calls.
  final MethodChannel channel;

  void _onAdEvent(Ad ad, String eventName, Map<dynamic, dynamic> arguments) {
    switch (eventName) {
      case 'onAdLoaded':
        _onAdLoadedAds.add(ad);
        ad.listener.onAdLoaded?.call(ad);
        break;
      case 'onAdFailedToLoad':
        ad.listener.onAdFailedToLoad?.call(ad, arguments['loadAdError']);
        break;
      case 'onNativeAdClicked':
        ad.listener.onNativeAdClicked?.call(ad as NativeAd);
        break;
      case 'onNativeAdImpression':
        ad.listener.onNativeAdImpression?.call(ad as NativeAd);
        break;
      case 'onAdOpened':
        ad.listener.onAdOpened?.call(ad);
        break;
      case 'onApplicationExit':
        ad.listener.onApplicationExit?.call(ad);
        break;
      case 'onAdClosed':
        ad.listener.onAdClosed?.call(ad);
        break;
      case 'onAppEvent':
        ad.listener.onAppEvent?.call(ad, arguments['name'], arguments['data']);
        break;
      case 'onRewardedAdUserEarnedReward':
        assert(arguments['rewardItem'] != null);
        ad.listener.onRewardedAdUserEarnedReward
            ?.call(ad as RewardedAd, arguments['rewardItem']);
        break;
      default:
        debugPrint('invalid ad event name: $eventName');
    }
  }

  /// Returns null if an invalid [adId] was passed in.
  Ad? adFor(int adId) => _loadedAds[adId];

  /// Returns null if an invalid [Ad] was passed in.
  int? adIdFor(Ad ad) => _loadedAds.inverse[ad];

  final Set<int> _mountedWidgetAdIds = <int>{};

  /// Returns true if the [adId] is already mounted in a [WidgetAd].
  bool isWidgetAdIdMounted(int adId) => _mountedWidgetAdIds.contains(adId);

  /// Indicates that [adId] is mounted in widget tree.
  void mountWidgetAdId(int adId) => _mountedWidgetAdIds.add(adId);

  /// Indicates that [adId] is unmounted from the widget tree.
  void unmountWidgetAdId(int adId) => _mountedWidgetAdIds.remove(adId);

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadBannerAd(BannerAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadBannerAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': ad.adUnitId,
        'request': ad.request,
        'size': ad.size,
      },
    );
  }

  Future<void> loadInterstitialAd(InterstitialAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadInterstitialAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': ad.adUnitId,
        'request': ad.request,
      },
    );
  }

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadNativeAd(NativeAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadNativeAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': ad.adUnitId,
        'request': ad.request,
        'publisherRequest': ad.publisherRequest,
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
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadRewardedAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': ad.adUnitId,
        'request': ad.request,
        'publisherRequest': ad.publisherRequest,
        'serverSideVerificationOptions': ad.serverSideVerificationOptions,
      },
    );
  }

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadPublisherBannerAd(PublisherBannerAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadPublisherBannerAd',
      <dynamic, dynamic>{
        'adId': adId,
        'sizes': ad.sizes,
        'adUnitId': ad.adUnitId,
        'request': ad.request,
      },
    );
  }

  /// Loads an ad if not currently loading or loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadPublisherInterstitialAd(PublisherInterstitialAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadPublisherInterstitialAd',
      <dynamic, dynamic>{
        'adId': adId,
        'adUnitId': ad.adUnitId,
        'request': ad.request,
      },
    );
  }

  /// Free the plugin resources associated with this ad.
  ///
  /// Disposing a banner ad that's been shown removes it from the screen.
  /// Interstitial ads can't be programmatically removed from view.
  Future<void> disposeAd(Ad ad) {
    _onAdLoadedAds.remove(ad);

    final int? adId = adIdFor(ad);
    final Ad? disposedAd = _loadedAds.remove(adId);
    if (disposedAd == null) {
      return Future<void>.value();
    }
    return channel.invokeMethod<void>(
      'disposeAd',
      <dynamic, dynamic>{
        'adId': adId,
      },
    );
  }

  /// Display an [AdWithoutView] that is overlaid on top of the application.
  Future<void> showAdWithoutView(AdWithoutView ad) {
    assert(
      adIdFor(ad) != null,
      '$Ad has not been loaded or has already been disposed.',
    );

    return channel.invokeMethod<void>(
      'showAdWithoutView',
      <dynamic, dynamic>{
        'adId': adIdFor(ad),
      },
    );
  }

  /// Set the [RequestConfiguration] to apply for future ad requests.
  Future<void> updateRequestConfiguration(
      RequestConfiguration requestConfiguration) {
    return channel.invokeMethod<void>(
      'MobileAds#updateRequestConfiguration',
      <dynamic, dynamic>{
        'maxAdContentRating': requestConfiguration.maxAdContentRating,
        'tagForChildDirectedTreatment':
            requestConfiguration.tagForChildDirectedTreatment,
        'testDeviceIds': requestConfiguration.testDeviceIds,
        'tagForUnderAgeOfConsent': requestConfiguration.tagForUnderAgeOfConsent,
      },
    );
  }
}

class AdMessageCodec extends StandardMessageCodec {
  const AdMessageCodec();

  // The type values below must be consistent for each platform.
  static const int _valueAdSize = 128;
  static const int _valueAdRequest = 129;
  static const int _valueRewardItem = 132;
  static const int _valueLoadAdError = 133;
  static const int _valuePublisherAdRequest = 134;
  static const int _valueInitializationState = 135;
  static const int _valueAdapterStatus = 136;
  static const int _valueInitializationStatus = 137;
  static const int _valueServerSideVerificationOptions = 138;
  static const int _valueAnchoredAdaptiveBannerAdSize = 139;
  static const int _valueSmartBannerAdSize = 140;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is AdSize) {
      writeAdSize(buffer, value);
    } else if (value is AdRequest) {
      buffer.putUint8(_valueAdRequest);
      writeValue(buffer, value.keywords);
      writeValue(buffer, value.contentUrl);
      writeValue(buffer, value.testDevices);
      writeValue(buffer, value.nonPersonalizedAds);
    } else if (value is RewardItem) {
      buffer.putUint8(_valueRewardItem);
      writeValue(buffer, value.amount);
      writeValue(buffer, value.type);
    } else if (value is LoadAdError) {
      buffer.putUint8(_valueLoadAdError);
      writeValue(buffer, value.code);
      writeValue(buffer, value.domain);
      writeValue(buffer, value.message);
    } else if (value is PublisherAdRequest) {
      buffer.putUint8(_valuePublisherAdRequest);
      writeValue(buffer, value.keywords);
      writeValue(buffer, value.contentUrl);
      writeValue(buffer, value.customTargeting);
      writeValue(buffer, value.customTargetingLists);
      writeValue(buffer, value.nonPersonalizedAds);
    } else if (value is AdapterInitializationState) {
      buffer.putUint8(_valueInitializationState);
      writeValue(buffer, describeEnum(value));
    } else if (value is AdapterStatus) {
      buffer.putUint8(_valueAdapterStatus);
      writeValue(buffer, value.state);
      writeValue(buffer, value.description);
      writeValue(buffer, value.latency);
    } else if (value is InitializationStatus) {
      buffer.putUint8(_valueInitializationStatus);
      writeValue(buffer, value.adapterStatuses);
    } else if (value is ServerSideVerificationOptions) {
      buffer.putUint8(_valueServerSideVerificationOptions);
      writeValue(buffer, value.userId);
      writeValue(buffer, value.customData);
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(dynamic type, ReadBuffer buffer) {
    switch (type) {
      case _valueAnchoredAdaptiveBannerAdSize:
        final String orientationStr =
            readValueOfType(buffer.getUint8(), buffer);
        final num width = readValueOfType(buffer.getUint8(), buffer);
        final num height = readValueOfType(buffer.getUint8(), buffer);
        return AnchoredAdaptiveBannerAdSize(
          Orientation.values.firstWhere(
            (Orientation orientation) =>
                describeEnum(orientation) == orientationStr,
          ),
          width: width.truncate(),
          height: height.truncate(),
        );
      case _valueSmartBannerAdSize:
        final String orientationStr =
            readValueOfType(buffer.getUint8(), buffer);
        return SmartBannerAdSize(
          Orientation.values.firstWhere(
            (Orientation orientation) =>
                describeEnum(orientation) == orientationStr,
          ),
        );
      case _valueAdSize:
        return AdSize(
          width: readValueOfType(buffer.getUint8(), buffer),
          height: readValueOfType(buffer.getUint8(), buffer),
        );
      case _valueAdRequest:
        return AdRequest(
          keywords: readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          contentUrl: readValueOfType(buffer.getUint8(), buffer),
          testDevices:
              readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          nonPersonalizedAds: readValueOfType(buffer.getUint8(), buffer),
        );
      case _valueRewardItem:
        return RewardItem(
          readValueOfType(buffer.getUint8(), buffer),
          readValueOfType(buffer.getUint8(), buffer),
        );
      case _valueLoadAdError:
        return LoadAdError(
          readValueOfType(buffer.getUint8(), buffer),
          readValueOfType(buffer.getUint8(), buffer),
          readValueOfType(buffer.getUint8(), buffer),
        );
      case _valuePublisherAdRequest:
        return PublisherAdRequest(
          keywords: readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          contentUrl: readValueOfType(buffer.getUint8(), buffer),
          customTargeting: readValueOfType(buffer.getUint8(), buffer)
              ?.cast<String, String>(),
          customTargetingLists: _tryDeepMapCast<String>(
            readValueOfType(buffer.getUint8(), buffer),
          ),
          nonPersonalizedAds: readValueOfType(buffer.getUint8(), buffer),
        );
      case _valueInitializationState:
        switch (readValueOfType(buffer.getUint8(), buffer)) {
          case 'notReady':
            return AdapterInitializationState.notReady;
          case 'ready':
            return AdapterInitializationState.ready;
        }
        throw ArgumentError();
      case _valueAdapterStatus:
        final AdapterInitializationState state =
            readValueOfType(buffer.getUint8(), buffer);
        final String description = readValueOfType(buffer.getUint8(), buffer);

        double latency = readValueOfType(buffer.getUint8(), buffer).toDouble();
        // Android provides this value as an int in milliseconds while iOS
        // provides this value as a double in seconds.
        if (defaultTargetPlatform == TargetPlatform.android) {
          latency /= 1000;
        }

        return AdapterStatus(state, description, latency);
      case _valueInitializationStatus:
        return InitializationStatus(
          readValueOfType(buffer.getUint8(), buffer)
              .cast<String, AdapterStatus>(),
        );
      case _valueServerSideVerificationOptions:
        return ServerSideVerificationOptions(
            userId: readValueOfType(buffer.getUint8(), buffer),
            customData: readValueOfType(buffer.getUint8(), buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  Map<String, List<T>>? _tryDeepMapCast<T>(Map<dynamic, dynamic>? map) {
    if (map == null) return null;
    return map.map<String, List<T>>(
      (dynamic key, dynamic value) => MapEntry<String, List<T>>(
        key,
        value?.cast<T>(),
      ),
    );
  }

  void writeAdSize(WriteBuffer buffer, AdSize value) {
    if (value is AnchoredAdaptiveBannerAdSize) {
      buffer.putUint8(_valueAnchoredAdaptiveBannerAdSize);
      writeValue(buffer, describeEnum(value.orientation));
      writeValue(buffer, value.width);
      writeValue(buffer, value.height);
    } else if (value is SmartBannerAdSize) {
      buffer.putUint8(_valueSmartBannerAdSize);
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        writeValue(buffer, describeEnum(value.orientation));
      }
    } else {
      buffer.putUint8(_valueAdSize);
      writeValue(buffer, value.width);
      writeValue(buffer, value.height);
    }
  }
}

class _BiMap<K extends Object, V extends Object> extends MapBase<K, V> {
  _BiMap() {
    _inverse = _BiMap<V, K>._inverse(this);
  }

  _BiMap._inverse(this._inverse);

  final Map<K, V> _map = <K, V>{};
  late _BiMap<V, K> _inverse;

  _BiMap<V, K> get inverse => _inverse;

  @override
  V? operator [](Object? key) => _map[key];

  @override
  void operator []=(K key, V value) {
    assert(!_map.containsKey(key));
    assert(!inverse.containsKey(value));
    _map[key] = value;
    inverse._map[value] = key;
  }

  @override
  void clear() {
    _map.clear();
    inverse._map.clear();
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) {
    if (key == null) return null;
    final V? value = _map[key];
    inverse._map.remove(value);
    return _map.remove(key);
  }
}
