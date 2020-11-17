// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
// ignore_for_file: deprecated_member_use_from_same_package
// TODO(gonzchristian): Document all public members

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import 'ad_instance_manager.dart';

/// The user's gender for the sake of ad targeting using [AdRequest].
// Warning: the index values of the enums must match the values of the corresponding
// AdMob constants. For example MobileAdGender.female.index == kGADGenderFemale.
// TODO(bparrishMines): Unit tests should be added to the iOS and Android platform code to verify the above warning.
@Deprecated('This functionality is deprecated in AdMob without replacement.')
enum MobileAdGender {
  unknown,
  male,
  female,
}

/// Error information about why an ad load operation failed.
class LoadAdError {
  /// Default constructor for [LoadAdError].
  LoadAdError(this.code, this.domain, this.message)
      : assert(code != null),
        assert(domain != null),
        assert(message != null);

  /// Unique code to identify the error.
  ///
  /// See links below for possible error codes:
  /// Android:
  ///   https://developers.google.com/android/reference/com/google/android/gms/ads/AdRequest#constant-summary
  /// Ios:
  ///   https://developers.google.com/admob/ios/api/reference/Enums/GADErrorCode
  final int code;

  /// The domain from which the error came.
  final String domain;

  /// A message detailing the error.
  ///
  /// For example "Account not approved yet". See
  /// https://support.google.com/admob/answer/9905175 for explanations of
  /// common errors.
  final String message;

  @override
  String toString() {
    return '$runtimeType(code: $code, domain: $domain, message: $message)';
  }
}

/// Targeting info per the native AdMob API.
///
/// This class's properties mirror the native AdRequest API. See for example:
/// [AdRequest.Builder for Android](https://firebase.google.com/docs/reference/android/com/google/android/gms/ads/AdRequest.Builder).
class AdRequest {
  const AdRequest({
    this.keywords,
    this.contentUrl,
    @Deprecated('This functionality is deprecated in AdMob without replacement.')
        this.birthday,
    @Deprecated('This functionality is deprecated in AdMob without replacement.')
        this.gender,
    @Deprecated('Use `childDirected` instead.') this.designedForFamilies,
    this.childDirected,
    this.testDevices,
    this.nonPersonalizedAds,
  });

  final List<String> keywords;
  final String contentUrl;
  @Deprecated('This functionality is deprecated in AdMob without replacement.')
  final DateTime birthday;
  @Deprecated('This functionality is deprecated in AdMob without replacement.')
  final MobileAdGender gender;
  @Deprecated(
      'This functionality is deprecated in AdMob.  Use `childDirected` instead.')
  final bool designedForFamilies;
  final bool childDirected;
  final List<String> testDevices;
  final bool nonPersonalizedAds;

  @override
  bool operator ==(other) {
    return this.keywords.toString() == other.keywords.toString() &&
        this.contentUrl == other.contentUrl &&
        this.birthday == other.birthday &&
        this.gender == other.gender &&
        this.designedForFamilies == other.designedForFamilies &&
        this.testDevices.toString() == other.testDevices.toString() &&
        this.nonPersonalizedAds == other.nonPersonalizedAds;
  }
}

class PublisherAdRequest {
  const PublisherAdRequest({
    this.keywords,
    this.contentUrl,
    this.customTargeting,
    this.customTargetingLists,
  });

  final List<String> keywords;
  final String contentUrl;
  final Map<String, String> customTargeting;
  final Map<String, List<String>> customTargetingLists;

  @override
  bool operator ==(other) {
    return ListEquality().equals(keywords, other.keywords) &&
        contentUrl == other.contentUrl &&
        MapEquality().equals(customTargeting, other.customTargeting) &&
        DeepCollectionEquality()
            .equals(customTargetingLists, other.customTargetingLists);
  }
}

/// [AdSize] represents the size of a banner ad.
///
/// There are six sizes available, which are the same for both iOS and Android.
/// See the guides for banners on [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
class AdSize {
  const AdSize({
    @required this.width,
    @required this.height,
  })  : assert(width != null),
        assert(height != null);

  /// The vertical span of an ad.
  final int height;

  /// The horizontal span of an ad.
  final int width;

  /// The standard banner (320x50) size.
  static const AdSize banner = AdSize(width: 320, height: 50);

  /// The large banner (320x100) size.
  static const AdSize largeBanner = AdSize(width: 320, height: 100);

  /// The medium rectangle (300x250) size.
  static const AdSize mediumRectangle = AdSize(width: 300, height: 250);

  /// The full banner (468x60) size.
  static const AdSize fullBanner = AdSize(width: 468, height: 60);

  /// The leaderboard (728x90) size.
  static const AdSize leaderboard = AdSize(width: 728, height: 90);

  /// Ad units that render screen-width banner ads on any screen size across different devices in either [Orientation].
  static AdSize getSmartBanner(Orientation orientation) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return smartBanner;
    } else if (defaultTargetPlatform == TargetPlatform.iOS &&
        orientation == Orientation.portrait) {
      return smartBannerPortrait;
    } else if (defaultTargetPlatform == TargetPlatform.iOS &&
        orientation == Orientation.landscape) {
      return smartBannerLandscape;
    }

    throw AssertionError('Only supported on Android and iOS.');
  }

  /// Ad units that render screen-width banner ads on any screen size across different devices in either orientation on Android.
  // Android expects a width and height of -1 represents a smart banner.
  static AdSize get smartBanner {
    assert(defaultTargetPlatform == TargetPlatform.android);
    return AdSize(width: -1, height: -1);
  }

  /// Ad units that render screen-width banner ads on any screen size across different devices in portrait on iOS.
  // iOS expects a width of -1 and a height of -2 represents a portrait smart banner.
  static AdSize get smartBannerPortrait {
    assert(defaultTargetPlatform == TargetPlatform.iOS);
    return AdSize(width: -1, height: -2);
  }

  /// Ad units that render screen-width banner ads on any screen size across different devices in landscape on iOS.
  // iOS expects a width of -1 and a height of -2 represents a landscape smart banner.
  static AdSize get smartBannerLandscape {
    assert(defaultTargetPlatform == TargetPlatform.android);
    return AdSize(width: -1, height: -3);
  }

  @override
  bool operator ==(other) {
    return width == other.width && height == other.height;
  }
}

/// A listener for receiving notifications during the lifecycle of an ad.
class AdListener {
  const AdListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onNativeAdClicked,
    this.onNativeAdImpression,
    this.onAdOpened,
    this.onApplicationExit,
    this.onAdClosed,
    this.onRewardedAdUserEarnedReward,
    this.onAppEvent,
  });

  /// Called when an ad is successfully received.
  final void Function(Ad ad) onAdLoaded;

  /// Called when an ad request failed.
  final void Function(Ad ad, LoadAdError error) onAdFailedToLoad;

  /// Called when an app event is received.
  final void Function(Ad ad, String name, String data) onAppEvent;

  /// Called when a click is recorded for a [NativeAd].
  final void Function(NativeAd ad) onNativeAdClicked;

  /// Called when an impression is recorded for a [NativeAd].
  final void Function(NativeAd ad) onNativeAdImpression;

  /// Called when an ad opens an overlay that covers the screen.
  final void Function(Ad ad) onAdOpened;

  /// Called when an ad is in the process of leaving the application.
  final void Function(Ad ad) onApplicationExit;

  /// Called when an ad removes an overlay that covers the screen.
  final void Function(Ad ad) onAdClosed;

  /// Called when a [RewardedAd] triggers a reward.
  final void Function(
    RewardedAd ad,
    RewardItem reward,
  ) onRewardedAdUserEarnedReward;
}

/// A base ad for the [FirebaseAdMobPlugin].
///
/// A valid [adUnitId] is required.
abstract class Ad {
  /// Default constructor, used by subclasses.
  const Ad({@required this.adUnitId, @required this.listener})
      : assert(adUnitId != null),
        assert(listener != null);

  /// Receive callbacks from [Ad] lifecycle events.
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  final String adUnitId;

  /// Free the plugin resources associated with this ad.
  Future<void> dispose() {
    return instanceManager.disposeAd(this);
  }

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  Future<void> load();

  /// Whether this [Ad.load] has been called for this [Ad] and [AdListener.onAdLoaded] callback has been called.
  Future<bool> isLoaded() async {
    return instanceManager.adIdFor(this) != null &&
        instanceManager.onAdLoadedCalled(this);
  }
}

/// A mobile [Ad] for the [FirebaseAdMobPlugin] that can be loaded or disposed.
///
/// A valid [adUnitId] and [size] are required.
abstract class AdWithView extends Ad {
  /// Default constructor, used by subclasses.
  const AdWithView({@required String adUnitId, @required AdListener listener})
      : super(adUnitId: adUnitId, listener: listener);
}

/// An [Ad] that is overlaid on top of the UI.
abstract class AdWithoutView extends Ad {
  /// Default constructor used by subclasses.
  const AdWithoutView(
      {@required String adUnitId, @required AdListener listener})
      : super(adUnitId: adUnitId, listener: listener);

  /// Display this on top of the application.
  Future<void> show() {
    return instanceManager.showAdWithoutView(this);
  }
}

/// Displays an [Ad] as a Flutter widget.
///
/// This widget takes ads inheriting from [AdWithView]
/// (e.g. [BannerAd] and [NativeAd]) and allows them to be added to the Flutter
/// widget tree.
///
/// Must call `load()` first before showing the widget. Otherwise, a
/// [PlatformException] will be thrown.
class AdWidget extends StatelessWidget {
  const AdWidget({Key key, @required this.ad})
      : assert(ad != null),
        super(key: key);

  /// Ad to be displayed as a widget.
  final AdWithView ad;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: '${instanceManager.channel.name}/ad_widget',
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: '${instanceManager.channel.name}/ad_widget',
            layoutDirection: TextDirection.ltr,
            creationParams: instanceManager.adIdFor(ad),
            creationParamsCodec: StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    }

    return UiKitView(
      viewType: '${instanceManager.channel.name}/ad_widget',
      creationParams: instanceManager.adIdFor(ad),
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}

/// A banner ad for the [FirebaseAdMobPlugin].
///
/// This ad can either be overlaid on top of all flutter widgets as a static
/// view or displayed as a typical Flutter widget. To display as a widget,
/// instantiate an [AdWidget] with this as a parameter.
class BannerAd extends AdWithView {
  /// Creates a [BannerAd].
  ///
  /// A valid [adUnitId], nonnull [listener], and nonnull request is required.
  BannerAd({
    @required this.size,
    @required String adUnitId,
    @required AdListener listener,
    @required this.request,
  })  : assert(size != null),
        assert(request != null),
        super(adUnitId: adUnitId, listener: listener);

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// Represents the size of a banner ad.
  ///
  /// There are six sizes available, which are the same for both iOS and Android.
  /// See the guides for banners on Android](https://developers.google.com/admob/android/banner#banner_sizes)
  /// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for additional details.
  final AdSize size;

  /// {@template firebase_admob.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  Future<void> load() async {
    await instanceManager.loadBannerAd(this);
  }
}

/// A banner ad displayed with DoubleClick for Publishers (DFP).
///
/// This ad can either be overlaid on top of all flutter widgets by passing this
/// to an [AdWidget] after calling [load].
class PublisherBannerAd extends AdWithView {
  PublisherBannerAd({
    @required this.sizes,
    @required String adUnitId,
    @required AdListener listener,
    @required this.request,
  })  : assert(sizes != null),
        assert(sizes.isNotEmpty),
        assert(request != null),
        super(adUnitId: adUnitId, listener: listener);

  /// Targeting information used to fetch an [Ad].
  final PublisherAdRequest request;

  /// Ad sizes supported by this [PublisherBannerAd].
  ///
  /// In most cases, only one ad size will be specified. Multiple ad sizes can
  /// be specified if your application can appropriately handle multiple ad
  /// sizes. If multiple ad sizes are specified, the [PublisherBannerAd] will
  /// assume the size of the first ad size until an ad is loaded.
  final List<AdSize> sizes;

  @override
  Future<void> load() async {
    await instanceManager.loadPublisherBannerAd(this);
  }
}

/// A NativeAd for the [FirebaseAdMobPlugin].
///
/// Native ads are ad assets that are presented to users via UI components that
/// are native to the platform. (e.g. A
/// [View](https://developer.android.com/reference/android/view/View) on Android
/// or a
/// [UIView](https://developer.apple.com/documentation/uikit/uiview?language=objc)
/// on iOS). Using Flutter widgets to create native ads is NOT supported by
/// this.
///
/// Using platform specific UI components, these ads can be formatted to match
/// the visual design of the user experience in which they live. In coding
/// terms, this means that when a native ad loads, your app receives a NativeAd
/// object that contains its assets, and the app (rather than the Google Mobile
/// Ads SDK) is then responsible for displaying them.
///
/// See the README for more details on using Native Ads.
///
/// To display this ad, instantiate an [AdWidget] with this as a parameter after
/// calling [load].
class NativeAd extends AdWithView {
  /// Creates a [NativeAd].
  ///
  /// A valid [adUnitId], nonnull [listener], nonnull [request], and nonnull
  /// [factoryId] is required.
  NativeAd({
    @required String adUnitId,
    @required this.factoryId,
    @required AdListener listener,
    @required this.request,
    this.customOptions,
  })  : publisherRequest = null,
        assert(adUnitId != null),
        assert(listener != null),
        assert(factoryId != null),
        assert(request != null),
        super(adUnitId: adUnitId, listener: listener);

  /// Creates a [NativeAd] with Ad Manager.
  ///
  /// A valid [adUnitId], nonnull [listener], nonnull [publisherRequest], and
  /// nonnull [factoryId] is required.
  NativeAd.fromPublisherRequest({
    @required String adUnitId,
    @required this.factoryId,
    @required AdListener listener,
    @required this.publisherRequest,
    this.customOptions,
  })  : request = null,
        assert(factoryId != null),
        assert(adUnitId != null),
        assert(listener != null),
        assert(publisherRequest != null),
        super(adUnitId: adUnitId, listener: listener);

  /// An identifier for the factory that creates the Platform view.
  final String factoryId;

  /// Optional options used to create the [NativeAd].
  ///
  /// These options are passed to the platform's `NativeAdFactory`.
  Map<String, Object> customOptions;

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// Targeting information used to fetch an [Ad] with Ad Manager.
  final PublisherAdRequest publisherRequest;

  /// {@template firebase_admob.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  Future<void> load() async {
    await instanceManager.loadNativeAd(this);
  }
}

/// A full-screen interstitial ad for the Firebase AdMob Plugin.
class InterstitialAd extends AdWithoutView {
  /// Creates an [InterstitialAd].
  ///
  /// A valid [adUnitId] from the AdMob dashboard, a nonnull [listener], and a
  /// nonnull [request] is required.
  InterstitialAd({
    @required String adUnitId,
    @required AdListener listener,
    @required this.request,
  })  : assert(request != null),
        super(adUnitId: adUnitId, listener: listener);

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  @override
  Future<void> load() async {
    await instanceManager.loadInterstitialAd(this);
  }
}

/// A full-screen interstitial ad for use with Ad Manager.
class PublisherInterstitialAd extends AdWithoutView {
  /// Creates an [PublisherInterstitialAd].
  ///
  /// A valid [adUnitId] from the Ad Manager dashboard, a nonnull [listener],
  /// and nonnull [request] is required.
  PublisherInterstitialAd({
    @required String adUnitId,
    @required AdListener listener,
    @required this.request,
  })  : assert(request != null),
        super(adUnitId: adUnitId, listener: listener);

  /// Targeting information used to fetch an [Ad].
  final PublisherAdRequest request;

  @override
  Future<void> load() async {
    await instanceManager.loadPublisherInterstitialAd(this);
  }
}

/// An [Ad] where a user has the option of interacting with in exchange for in-app rewards.
///
/// Because the video assets are so large, it's a good idea to start loading an
/// ad well in advance of when it's likely to be needed.
class RewardedAd extends AdWithoutView {
  /// Creates a [RewardedAd].
  ///
  /// A valid [adUnitId], nonnull [listener], and nonnull request is required.
  RewardedAd({
    @required String adUnitId,
    @required AdListener listener,
    @required this.request,
  }) : super(adUnitId: adUnitId, listener: listener);

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// {@template firebase_admob.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  Future<void> load() async {
    await instanceManager.loadRewardedAd(this);
  }
}

/// Credit information about a reward received from a [RewardedAd].
class RewardItem {
  RewardItem(this.amount, this.type)
      : assert(amount != null),
        assert(type != null);

  /// Credit amount rewarded from a [RewardedAd].
  final num amount;

  /// Type of credit rewarded.
  final String type;
}
