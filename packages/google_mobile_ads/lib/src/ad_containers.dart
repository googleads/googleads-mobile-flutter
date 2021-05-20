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

// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:reference/annotations.dart';
import 'package:reference/reference.dart';

import 'ad_containers_channel.dart';
import 'ad_containers.g.dart';

/// Error information about why an ad load operation failed.
@Reference('google_mobile_ads.LoadAdError')
class LoadAdError with $LoadAdError {
  /// Default constructor for [LoadAdError].
  LoadAdError(this.code, this.domain, this.message);

  /// Unique code to identify the error.
  ///
  /// See links below for possible error codes:
  /// Android:
  ///   https://developers.google.com/android/reference/com/google/android/gms/ads/AdRequest#constant-summary
  /// Ios:
  ///   https://developers.google.com/admob/ios/api/reference/Enums/GADErrorCode
  @override
  final int code;

  /// The domain from which the error came.
  @override
  final String domain;

  /// A message detailing the error.
  ///
  /// For example "Account not approved yet". See
  /// https://support.google.com/admob/answer/9905175 for explanations of
  /// common errors.
  @override
  final String message;

  @ReferenceMethod(ignore: true)
  @override
  String toString() {
    return '$runtimeType(code: $code, domain: $domain, message: $message)';
  }
}

/// Targeting info per the AdMob API.
///
/// This class's properties mirror the native AdRequest API. See for example:
/// [AdRequest.Builder for Android](https://developers.google.com/android/reference/com/google/android/gms/ads/AdRequest.Builder).
@Reference('google_mobile_ads.AdRequest')
class AdRequest with $AdRequest {
  /// Default constructor for [AdRequest].
  AdRequest() {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $AdRequestChannel get _channel =>
      ChannelRegistrar.instance.implementations.adRequestChannel;

  /// Words or phrases describing the current user activity.
  @override
  Future<void> addKeyword(String keyword) {
    return _channel.$invokeAddKeyword(this, keyword);
  }

  /// URL string for a webpage whose content matches the app’s primary content.
  ///
  /// This webpage content is used for targeting and brand safety purposes.
  @override
  Future<void> setContentUrl(String url) {
    return _channel.$invokeSetContentUrl(this, url);
  }

  /// Non-personalized ads are ads that are not based on a user’s past behavior.
  ///
  /// For more information:
  /// https://support.google.com/admob/answer/7676680?hl=en
  @override
  Future<void> setNonPersonalizedAds(bool nonPersonalizedAds) {
    return _channel.$invokeSetNonPersonalizedAds(this, nonPersonalizedAds);
  }
}

/// Targeting info per the Ad Manager API.
@Reference('google_mobile_ads.PublisherAdRequest')
class PublisherAdRequest extends AdRequest with $PublisherAdRequest {
  /// Default constructor for [PublisherAdRequest].
  PublisherAdRequest() {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $PublisherAdRequestChannel get _channel =>
      ChannelRegistrar.instance.implementations.publisherAdRequestChannel;

  /// Key-value pairs used for custom targeting.
  @override
  Future<void> addCustomTargeting(String key, String value) {
    return _channel.$invokeAddCustomTargeting(this, key, value);
  }

  /// Key-value pairs used for custom targeting.
  @override
  Future<void> addCustomTargetingList(String key, List<String> values) {
    return _channel.$invokeAddCustomTargetingList(this, key, values);
  }
}

/// [AdSize] represents the size of a banner ad.
///
/// There are six sizes available, which are the same for both iOS and Android.
/// See the guides for banners on [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
@Reference('google_mobile_ads.AdSize')
class AdSize with $AdSize {
  /// Default constructor for [AdSize].
  AdSize({
    required this.width,
    required this.height,
    this.constant,
    @ignoreParam bool creator = true,
  }) {
    if (creator) _channel.createNewInstancePair(this, owner: true);
  }

  static $AdSizeChannel get _channel =>
      ChannelRegistrar.instance.implementations.adSizeChannel;

  /// The standard banner (320x50) size.
  static final AdSize banner = AdSize(
    width: 320,
    height: 50,
    constant: 'banner',
  );

  /// The vertical span of an ad.
  @override
  final int height;

  /// The horizontal span of an ad.
  @override
  final int width;

  @override
  final String? constant;

  /// The large banner (320x100) size.
  static final AdSize largeBanner = AdSize(
    width: 320,
    height: 100,
    constant: 'largeBanner',
  );

  /// The medium rectangle (300x250) size.
  static final AdSize mediumRectangle = AdSize(
    width: 300,
    height: 250,
    constant: 'mediumRectangle',
  );

  /// The full banner (468x60) size.
  static final AdSize fullBanner = AdSize(
    width: 468,
    height: 60,
    constant: 'fullBanner',
  );

  /// The leaderboard (728x90) size.
  static final AdSize leaderboard = AdSize(
    width: 728,
    height: 90,
    constant: 'leaderboard',
  );

  /// Ad units that render screen-width banner ads on any screen size across different devices in either [Orientation].
  ///
  /// Width of the current device can be found using:
  /// `MediaQuery.of(context).size.width.truncate()`.
  ///
  /// Returns `null` if a proper height could not be found for the device or
  /// window.
  static Future<AdSize?> getPortraitAnchoredAdaptiveBannerAdSize(
    int width,
  ) async {
    return await _channel.$invokeGetPortraitAnchoredAdaptiveBannerAdSize(width)
        as AdSize?;
  }

  /// Ad units that render screen-width banner ads on any screen size across different devices in either [Orientation].
  ///
  /// Width of the current device can be found using:
  /// `MediaQuery.of(context).size.width.truncate()`.
  ///
  /// Returns `null` if a proper height could not be found for the device or
  /// window.
  static Future<AdSize?> getLandscapeAnchoredAdaptiveBannerAdSize(
    int width,
  ) async {
    return await _channel.$invokeGetLandscapeAnchoredAdaptiveBannerAdSize(width)
        as AdSize?;
  }
}

/// A listener for receiving notifications during the lifecycle of an ad.
@Reference('google_mobile_ads.AdListener')
abstract class AdListener with $AdListener {
  /// Default constructor for [AdListener].
  AdListener() {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $AdListenerChannel get _channel =>
      ChannelRegistrar.instance.implementations.adListenerChannel;

  /// Called when an ad is successfully received.
  @override
  void onAdLoaded();

  /// Called when an ad request failed.
  @override
  void onAdFailedToLoad(covariant LoadAdError error);

  /// Called when an app event is received.
  @override
  void onAppEvent(String name, String data);

  /// Called when a click is recorded for a [NativeAd].
  @override
  void onNativeAdClicked();

  /// Called when an impression is recorded for a [NativeAd].
  @override
  void onNativeAdImpression();

  /// Called when an ad opens an overlay that covers the screen.
  @override
  void onAdOpened();

  /// Called when an ad is in the process of leaving the application.
  @override
  void onApplicationExit();

  /// Called when an ad removes an overlay that covers the screen.
  @override
  void onAdClosed();

  /// Called when a [RewardedAd] triggers a reward.
  @override
  void onRewardedAdUserEarnedReward(covariant RewardItem reward);
}

/// Base mixin for mobile ad that has an in-line view.
mixin AdWithView {}

/// Displays an [Ad] as a Flutter widget.
///
/// This widget takes ads inheriting from [AdWithView]
/// (e.g. [BannerAd] and [NativeAd]) and allows them to be added to the Flutter
/// widget tree.
///
/// Must call `load()` first before showing the widget. Otherwise, a
/// [PlatformException] will be thrown.
class AdWidget extends StatefulWidget {
  /// Default constructor for [AdWidget].
  ///
  /// [ad] must be loaded before this is added to the widget tree.
  const AdWidget({Key? key, required this.ad}) : super(key: key);

  /// Ad to be displayed as a widget.
  final AdWithView ad;

  @override
  _AdWidgetState createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  static final Set<AdWithView> mountedAds = <AdWithView>{};
  static const String viewType = 'google_mobile_ads/ad_widget';

  late final _adIdAlreadyMounted;
  final TypeChannelMessenger messenger =
      ChannelRegistrar.instance.implementations.bannerAdChannel.messenger;

  @override
  void initState() {
    super.initState();
    _adIdAlreadyMounted = mountedAds.contains(widget.ad);
    mountedAds.add(widget.ad);
  }

  @override
  void dispose() {
    super.dispose();
    mountedAds.remove(widget.ad);
  }

  @override
  Widget build(BuildContext context) {
    if (_adIdAlreadyMounted) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('This AdWidget is already in the Widget tree'),
        ErrorHint(
            'If you placed this AdWidget in a list, make sure you create a new instance '
            'in the builder function with a unique ad object.'),
        ErrorHint(
            'Make sure you are not using the same ad object in more than one AdWidget.'),
      ]);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: messenger.getPairedPairedInstance(widget.ad),
            creationParamsCodec: ReferenceMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    }

    return UiKitView(
      viewType: viewType,
      creationParams: messenger.getPairedPairedInstance(widget.ad),
      creationParamsCodec: ReferenceMessageCodec(),
    );
  }
}

/// A banner ad.
///
/// This ad can either be overlaid on top of all flutter widgets as a static
/// view or displayed as a typical Flutter widget. To display as a widget,
/// instantiate an [AdWidget] with this as a parameter.
@Reference('google_mobile_ads.BannerAd')
class BannerAd with $BannerAd {
  /// Creates a [BannerAd].
  ///
  /// A valid [adUnitId], nonnull [listener], and nonnull request is required.
  BannerAd({
    required this.size,
    required this.adUnitId,
    required this.listener,
    required this.request,
  }) {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $BannerAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.bannerAdChannel;

  /// {@template google_mobile_ads.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  /// Start loading this ad.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Receive callbacks from [Ad] lifecycle events.
  @override
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  @override
  final String adUnitId;

  /// Targeting information used to fetch an [Ad].
  @override
  final AdRequest request;

  /// Represents the size of a banner ad.
  ///
  /// There are six sizes available, which are the same for both iOS and Android.
  /// See the guides for banners on Android](https://developers.google.com/admob/android/banner#banner_sizes)
  /// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for additional details.
  @override
  final AdSize size;

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  @override
  Future<void> load() {
    return _channel.$invokeLoad(this);
  }
}

/// A banner ad displayed with DoubleClick for Publishers (DFP).
///
/// This ad can either be overlaid on top of all flutter widgets by passing this
/// to an [AdWidget] after calling [load].
@Reference('google_mobile_ads.PublisherBannerAd')
class PublisherBannerAd with AdWithView, $PublisherBannerAd {
  /// Default constructor for [PublisherBannerAd].
  ///
  /// [sizes], [adUnitId], [listener], and [request] are all required values.
  PublisherBannerAd({
    required this.sizes,
    required this.adUnitId,
    required this.listener,
    required this.request,
  }) : assert(sizes.isNotEmpty) {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $PublisherBannerAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.publisherBannerAdChannel;

  /// Receive callbacks from [Ad] lifecycle events.
  @override
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  @override
  final String adUnitId;

  /// Targeting information used to fetch an [Ad].
  @override
  final PublisherAdRequest request;

  /// Ad sizes supported by this [PublisherBannerAd].
  ///
  /// In most cases, only one ad size will be specified. Multiple ad sizes can
  /// be specified if your application can appropriately handle multiple ad
  /// sizes. If multiple ad sizes are specified, the [PublisherBannerAd] will
  /// assume the size of the first ad size until an ad is loaded.
  @override
  final List<AdSize> sizes;

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  @override
  Future<void> load() {
    return _channel.$invokeLoad(this);
  }
}

/// A NativeAd.
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
@Reference('google_mobile_ads.NativeAd')
class NativeAd with AdWithView, $NativeAd {
  /// Creates a [NativeAd].
  ///
  /// A valid [adUnitId], nonnull [listener], nonnull [request], and nonnull
  /// [factoryId] is required.
  NativeAd({
    required this.adUnitId,
    required this.factoryId,
    required this.listener,
    required this.request,
    this.customOptions = const <String, Object>{},
  });

  static $NativeAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.nativeAdChannel;

  /// {@template google_mobile_ads.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  /// Start loading this ad.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// An identifier for the factory that creates the Platform view.
  @override
  final String factoryId;

  /// Receive callbacks from [Ad] lifecycle events.
  @override
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  @override
  final String adUnitId;

  /// Optional options used to create the [NativeAd].
  ///
  /// These options are passed to the platform's `NativeAdFactory`.
  @override
  final Map<String, Object> customOptions;

  /// Targeting information used to fetch an [Ad].
  @override
  final AdRequest request;

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  @override
  Future<void> load() {
    return _channel.$invokeLoad(this);
  }
}

/// A full-screen interstitial ad for the Google Mobile Ads Plugin.
@Reference('google_mobile_ads.InterstitialAd')
class InterstitialAd with $InterstitialAd {
  /// Creates an [InterstitialAd].
  ///
  /// A valid [adUnitId] from the AdMob dashboard, a nonnull [listener], and a
  /// nonnull [request] is required.
  InterstitialAd({
    required this.adUnitId,
    required this.listener,
    required this.request,
  }) {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $InterstitialAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.interstitialAdChannel;

  /// Receive callbacks from [Ad] lifecycle events.
  @override
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  @override
  final String adUnitId;

  /// Targeting information used to fetch an [Ad].
  @override
  final AdRequest request;

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  @override
  Future<void> load() {
    return _channel.$invokeLoad(this);
  }

  /// Display this on top of the application.
  @override
  Future<void> show() {
    return _channel.$invokeShow(this);
  }
}

/// A full-screen interstitial ad for use with Ad Manager.
@Reference('google_mobile_ads.PublisherInterstitialAd')
class PublisherInterstitialAd with $PublisherInterstitialAd {
  /// Creates an [PublisherInterstitialAd].
  ///
  /// A valid [adUnitId] from the Ad Manager dashboard, a nonnull [listener],
  /// and nonnull [request] is required.
  PublisherInterstitialAd({
    required this.adUnitId,
    required this.listener,
    required this.request,
  }) {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $PublisherInterstitialAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.publisherInterstitialAdChannel;

  /// Receive callbacks from [Ad] lifecycle events.
  @override
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  @override
  final String adUnitId;

  /// Targeting information used to fetch an [Ad].
  @override
  final PublisherAdRequest request;

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  @override
  Future<void> load() {
    return _channel.$invokeLoad(this);
  }

  /// Display this on top of the application.
  @override
  Future<void> show() {
    return _channel.$invokeShow(this);
  }
}

/// An [Ad] where a user has the option of interacting with in exchange for in-app rewards.
///
/// Because the video assets are so large, it's a good idea to start loading an
/// ad well in advance of when it's likely to be needed.
@Reference('google_mobile_ads.RewardedAd')
class RewardedAd with $RewardedAd {
  /// Creates a [RewardedAd] with an [AdRequest].
  ///
  /// A valid [adUnitId], nonnull [listener], and nonnull request is required.
  RewardedAd({
    required this.adUnitId,
    required this.listener,
    required this.request,
    this.serverSideVerificationOptions,
  });

  static $RewardedAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.rewardedAdChannel;

  /// {@template google_mobile_ads.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  /// Identifies the source of [Ad]s for your application.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  /// Receive callbacks from [Ad] lifecycle events.
  @override
  final AdListener listener;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  @override
  final String adUnitId;

  /// Targeting information used to fetch an [Ad].
  @override
  final AdRequest request;

  /// Optional [ServerSideVerificationOptions].
  @override
  final ServerSideVerificationOptions? serverSideVerificationOptions;

  /// Start loading this ad.
  ///
  /// Loading callbacks are sent to this [Ad]'s [listener].
  @override
  Future<void> load() {
    return _channel.$invokeLoad(this);
  }

  /// Display this on top of the application.
  @override
  Future<void> show() {
    return _channel.$invokeShow(this);
  }
}

/// Credit information about a reward received from a [RewardedAd].
@Reference('google_mobile_ads.RewardItem')
class RewardItem with $RewardItem {
  /// Default constructor for [RewardItem].
  ///
  /// This is mostly used to return [RewardItem]s for a [RewardedAd] and
  /// shouldn't be needed to be used directly.
  RewardItem(this.amount, this.type);

  /// Credit amount rewarded from a [RewardedAd].
  @override
  final num amount;

  /// Type of credit rewarded.
  @override
  final String type;
}

/// Options for RewardedAd server-side verification callbacks.
///
/// See https://developers.google.com/admob/ios/rewarded-video-ssv and
/// https://developers.google.com/admob/android/rewarded-video-ssv for more
/// information.
@Reference('google_mobile_ads.ServerSideVerificationOptions')
class ServerSideVerificationOptions with $ServerSideVerificationOptions {
  /// Create [ServerSideVerificationOptions] with the userId or customData.
  ServerSideVerificationOptions() {
    _channel.createNewInstancePair(this, owner: true);
  }

  static $ServerSideVerificationOptionsChannel get _channel => ChannelRegistrar
      .instance.implementations.serverSideVerificationOptionsChannel;

  /// The user id to be used in server-to-server reward callbacks.
  @override
  Future<void> setUserId(String userId) {
    return _channel.$invokeSetUserId(this, userId);
  }

  /// The custom data to be used in server-to-server reward callbacks
  @override
  Future<void> setCustomData(String customData) {
    return _channel.$invokeSetCustomData(this, customData);
  }
}
