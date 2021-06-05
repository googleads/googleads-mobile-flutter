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

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:reference/annotations.dart';
import 'package:reference/reference.dart';

import 'ad_containers.g.dart';
import 'ad_containers_channels.dart';

/// Error information about why an ad operation failed.
@Reference('google_mobile_ads.AdError')
class AdError implements $AdError {
  /// Creates an [AdError] with the given [code], [domain] and [message].
  AdError(this.code, this.domain, this.message);

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

  @ReferenceMethod(ignore: true)
  @override
  String toString() {
    return '$runtimeType(code: $code, domain: $domain, message: $message)';
  }
}

/// Contains information about the loaded ad or ad request.
///
/// For debugging and logging purposes. See
/// https://developers.google.com/admob/android/response-info for more
/// information on how this can be used.
@Reference('google_mobile_ads.ResponseInfo')
class ResponseInfo implements $ResponseInfo {
  /// Constructs a [ResponseInfo] with the [responseId] and [mediationAdapterClassName].
  const ResponseInfo({
    this.responseId,
    this.mediationAdapterClassName,
    this.adapterResponses,
  });

  /// An identifier for the loaded ad.
  final String? responseId;

  /// The mediation adapter class name of the ad network that loaded the ad.
  final String? mediationAdapterClassName;

  /// The [AdapterResponseInfo]s containing metadata for each adapter included
  /// in the ad response.
  ///
  /// Can be used to debug the mediation waterfall execution.
  final List<AdapterResponseInfo>? adapterResponses;

  @ReferenceMethod(ignore: true)
  @override
  String toString() {
    return '$runtimeType(responseId: $responseId, '
        'mediationAdapterClassName: $mediationAdapterClassName, '
        'adapterResponses: $adapterResponses)';
  }
}

/// Response information for an individual ad network in an ad response.
@Reference('google_mobile_ads.AdapterResponseInfo')
class AdapterResponseInfo implements $AdapterResponseInfo {
  /// Constructs an [AdapterResponseInfo].
  AdapterResponseInfo({
    required this.adapterClassName,
    required this.latencyMillis,
    required this.description,
    required this.credentials,
    this.adError,
  });

  /// A class name that identifies the ad network adapter.
  final String adapterClassName;

  /// The amount of time the ad network adapter spent loading an ad.
  ///
  /// 0 if the adapter was not attempted.
  final int latencyMillis;

  /// A log friendly string version of this object.
  final String description;

  /// A string description of adapter credentials specified in the AdMob or Ad Manager UI.
  final String credentials;

  /// The error that occurred while rendering the ad.
  final AdError? adError;

  @ReferenceMethod(ignore: true)
  @override
  String toString() {
    return '$runtimeType(adapterClassName: $adapterClassName, '
        'latencyMillis: $latencyMillis), '
        'description: $description, '
        'credentials: $credentials, '
        'adError: $adError)';
  }
}

/// Represents errors that occur when loading an ad.
@Reference('google_mobile_ads.LoadAdError')
class LoadAdError extends AdError implements $LoadAdError {
  /// Default constructor for [LoadAdError].
  LoadAdError(int code, String domain, String message, this.responseInfo)
      : super(code, domain, message);

  /// The [ResponseInfo] for the error.
  final ResponseInfo? responseInfo;

  @ReferenceMethod(ignore: true)
  @override
  String toString() {
    return '$runtimeType(code: $code, domain: $domain, message: $message'
        ', responseInfo: $responseInfo)';
  }
}

/// Targeting info per the AdMob API.
///
/// This class's properties mirror the native AdRequest API. See for example:
/// [AdRequest.Builder for Android](https://developers.google.com/android/reference/com/google/android/gms/ads/AdRequest.Builder).
@Reference('google_mobile_ads.AdRequest')
class AdRequest implements $AdRequest {
  static $AdRequestChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelAdRequest;

  /// Words or phrases describing the current user activity.
  Future<void> addKeyword(String keyword) {
    return _channel.$addKeyword(this, keyword);
  }

  /// URL string for a webpage whose content matches the app’s primary content.
  ///
  /// This webpage content is used for targeting and brand safety purposes.
  Future<void> setContentUrl(String url) {
    return _channel.$setContentUrl(this, url);
  }

  /// Non-personalized ads are ads that are not based on a user’s past behavior.
  ///
  /// For more information:
  /// https://support.google.com/admob/answer/7676680?hl=en
  Future<void> setNonPersonalizedAds(bool nonPersonalizedAds) {
    return _channel.$setNonPersonalizedAds(this, nonPersonalizedAds);
  }
}

/// Targeting info per the Ad Manager API.
@Reference('google_mobile_ads.AdRequest')
class AdManagerAdRequest extends AdRequest implements $AdManagerAdRequest {
  static $AdManagerAdRequestChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelAdManagerAdRequest;

  /// Key-value pairs used for custom targeting.
  Future<void> addCustomTargeting(String key, String value) {
    return _channel.$addCustomTargeting(this, key, value);
  }

  /// Key-value pairs used for custom targeting.
  Future<void> addCustomTargetingList(String key, List<String> values) {
    return _channel.$addCustomTargetingList(this, key, values);
  }
}

/// [AdSize] represents the size of a banner ad.
///
/// There are six sizes available, which are the same for both iOS and Android.
/// See the guides for banners on [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
@Reference('google_mobile_ads.AdSize')
class AdSize implements $AdSize {
  /// Default constructor for [AdSize].
  AdSize({
    required this.width,
    required this.height,
    String? constant,
    @ignoreParam bool creator = true,
  }) {
    if (creator) {
      _channel.$$create(
        this,
        $owner: true,
        width: width,
        height: height,
        constant: constant,
      );
    }
  }

  static $AdSizeChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelAdSize;

  /// The standard banner (320x50) size.
  static final AdSize banner = AdSize(
    width: 320,
    height: 50,
    constant: 'banner',
  );

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

  /// Ad units that render screen-width banner ads on any screen size across different devices in portrait on iOS.
  @Deprecated('Please use getPortraitAnchoredAdaptiveBannerAdSize.')
  static final AdSize smartBannerPortrait = AdSize(
    width: -1,
    height: -1,
    constant: 'smartBannerPortrait',
  );

  /// Ad units that render screen-width banner ads on any screen size across different devices in landscape on iOS.
  @Deprecated('Please use getLandscapeAnchoredAdaptiveBannerAdSize.')
  static final AdSize smartBannerLandscape = AdSize(
    width: -1,
    height: -1,
    constant: 'smartBannerLandscape',
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
    return await _channel.$getPortraitAnchoredAdaptiveBannerAdSize(width)
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
    return await _channel.$getLandscapeAnchoredAdaptiveBannerAdSize(width)
        as AdSize?;
  }

  /// The horizontal span of an ad.
  final int width;

  /// The vertical span of an ad.
  final int height;
}

// /// The base class for all ads.
// ///
// /// A valid [adUnitId] is required.
// ///
// abstract class Ad {
//   /// Default constructor, used by subclasses.
//   Ad({required this.adUnitId, this.responseInfo});
//
//   /// Identifies the source of [Ad]s for your application.
//   ///
//   /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
//   final String adUnitId;
//
//   /// Frees the plugin resources associated with this ad.
//   Future<void> dispose() {
//     return instanceManager.disposeAd(this);
//   }
//
//   /// Contains information about the loaded request.
//   ///
//   /// Only present if the ad has been successfully loaded.
//   ResponseInfo? responseInfo;
// }

// /// Base class for mobile [Ad] that has an in-line view.
// ///
// /// A valid [adUnitId] and [size] are required.
// abstract class AdWithView extends Ad {
//   /// Default constructor, used by subclasses.
//   AdWithView({required String adUnitId, required this.listener})
//       : super(adUnitId: adUnitId);
//
//   /// The [AdWithViewListener] for the ad.
//   final AdWithViewListener listener;
//
//   /// Starts loading this ad.
//   ///
//   /// Loading callbacks are sent to this [Ad]'s [listener].
//   Future<void> load();
// }
/// Mixin for a mobile ad that has an in-line view.
mixin AdWithView {
  bool get _adLoaded;
}

// /// An [Ad] that is overlaid on top of the UI.
// abstract class AdWithoutView extends Ad {
//   /// Default constructor used by subclasses.
//   AdWithoutView({required String adUnitId}) : super(adUnitId: adUnitId);
// }

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
  bool _adIdAlreadyMounted = false;
  bool _adLoadNotCalled = false;

  @override
  void initState() {
    super.initState();
    if (!widget.ad._adLoaded) {
      if (ChannelRegistrar.instance.isAdMounted(widget.ad)) {
        _adIdAlreadyMounted = true;
      }
      ChannelRegistrar.instance.mountAd(widget.ad);
    } else {
      _adLoadNotCalled = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    ChannelRegistrar.instance.unmountAd(widget.ad);
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
    if (_adLoadNotCalled) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
            'AdWidget requires Ad.load to be called before AdWidget is inserted into the tree'),
        ErrorHint(
            'Parameter ad is not loaded. Call Ad.load before AdWidget is inserted into the tree.'),
      ]);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidReferenceWidget(instance: widget.ad);
    }

    return UiKitReferenceWidget(instance: widget.ad);
  }
}

/// A banner ad.
///
/// This ad can either be overlaid on top of all flutter widgets as a static
/// view or displayed as a typical Flutter widget. To display as a widget,
/// instantiate an [AdWidget] with this as a parameter.
@Reference('google_mobile_ads.BannerAd')
class BannerAd implements AdWithView, $BannerAd {
  /// Creates a [BannerAd].
  ///
  /// A valid [adUnitId], nonnull [listener], and nonnull request is required.
  BannerAd({
    required this.size,
    required this.adUnitId,
    required this.listener,
    required this.request,
  }) {
    BannerAdListener._channel.$$create(listener, $owner: false);
    _channel.$$create(
      this,
      $owner: true,
      size: size,
      adUnitId: adUnitId,
      listener: listener,
      request: request,
    );
  }

  @override
  bool _adLoaded = false;

  static $BannerAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelBannerAd;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  final String adUnitId;

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// Represents the size of a banner ad.
  ///
  /// There are six sizes available, which are the same for both iOS and Android.
  /// See the guides for banners on Android](https://developers.google.com/admob/android/banner#banner_sizes)
  /// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for additional details.
  final AdSize size;

  // TODO: This should be passed outside of the constructor.
  /// A listener for receiving events in the ad lifecycle.
  final BannerAdListener listener;

  /// {@template google_mobile_ads.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Starts loading this ad.
  ///
  /// Loading callbacks are sent to this ad's [listener].
  Future<void> load() {
    _adLoaded = true;
    return _channel.$load(this);
  }
}

/// A banner ad displayed with Google Ad Manager.
///
/// This ad can either be overlaid on top of all flutter widgets by passing this
/// to an [AdWidget] after calling [load].
@Reference('google_mobile_ads.AdManagerBannerAd')
class AdManagerBannerAd implements AdWithView, $AdManagerBannerAd {
  /// Default constructor for [AdManagerBannerAd].
  ///
  /// [sizes], [adUnitId], [listener], and [request] are all required values.
  AdManagerBannerAd({
    required this.sizes,
    required this.adUnitId,
    required this.listener,
    required this.request,
  }) : assert(sizes.isNotEmpty) {
    AdManagerBannerAdListener._channel.$$create(listener, $owner: false);
    _channel.$$create(
      this,
      $owner: true,
      sizes: sizes,
      adUnitId: adUnitId,
      listener: listener,
      request: request,
    );
  }

  @override
  bool _adLoaded = false;

  static $AdManagerBannerAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelAdManagerBannerAd;

  /// Targeting information used to fetch an [Ad].
  final AdManagerAdRequest request;

  // TODO: fix link
  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  final String adUnitId;

  /// A listener for receiving events in the ad lifecycle.
  final AdManagerBannerAdListener listener;

  /// Ad sizes supported by this [AdManagerBannerAd].
  ///
  /// In most cases, only one ad size will be specified. Multiple ad sizes can
  /// be specified if your application can appropriately handle multiple ad
  /// sizes. If multiple ad sizes are specified, the [AdManagerBannerAd] will
  /// assume the size of the first ad size until an ad is loaded.
  final List<AdSize> sizes;

  /// Starts loading this ad.
  ///
  /// Loading callbacks are sent to this ad's [listener].
  Future<void> load() {
    _adLoaded = true;
    return _channel.$load(this);
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
class NativeAd implements AdWithView, $NativeAd {
  /// Creates a [NativeAd].
  ///
  /// A valid [adUnitId], nonnull [listener], nonnull [request], and nonnull
  /// [factoryId] is required.
  NativeAd({
    required this.adUnitId,
    required this.factoryId,
    required this.listener,
    required this.request,
    this.customOptions,
  }) {
    NativeAdListener._channel.$$create(listener, $owner: false);
    _channel.$$create(
      this,
      $owner: true,
      adUnitId: adUnitId,
      factoryId: factoryId,
      listener: listener,
      request: request,
      customOptions: customOptions,
    );
  }

  static $NativeAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelNativeAd;

  @override
  bool _adLoaded = false;

  /// Identifies the source of [Ad]s for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  final String adUnitId;

  /// An identifier for the factory that creates the Platform view.
  final String factoryId;

  /// A listener for receiving events in the ad lifecycle.
  final NativeAdListener listener;

  /// Optional options used to create the [NativeAd].
  ///
  /// These options are passed to the platform's `NativeAdFactory`.
  Map<String, Object>? customOptions;

  /// Targeting information used to fetch an [Ad].
  final AdRequest request;

  /// {@template google_mobile_ads.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// Starts loading this ad.
  ///
  /// Loading callbacks are sent to this ad's [listener].
  Future<void> load() {
    _adLoaded = true;
    return _channel.$load(this);
  }
}

/// A full-screen interstitial ad for the Google Mobile Ads Plugin.
@Reference('google_mobile_ads.InterstitialAd')
class InterstitialAd implements $InterstitialAd {
  // /// Creates an [InterstitialAd].
  // ///
  // /// A valid [adUnitId] from the AdMob dashboard, a nonnull [listener], and a
  // /// nonnull [request] is required.
  // @visibleForTesting
  // InterstitialAd({
  //   required this.adUnitId,
  //   required this.request,
  //   this.fullScreenContentCallback,
  // });

  static $InterstitialAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelInterstitialAd;

  /// Loads an [InterstitialAd] with the given [adUnitId] and [request].
  static Future<void> load({
    required String adUnitId,
    required AdRequest request,
    required InterstitialAdLoadCallback adLoadCallback,
  }) {
    // InterstitialAd ad = InterstitialAd(
    //     adUnitId: adUnitId, adLoadCallback: adLoadCallback, request: request);
    InterstitialAdLoadCallback._channel.$$create(adLoadCallback, $owner: false);
    return _channel.$load(
      adUnitId,
      request,
      adLoadCallback,
    );
  }

  // /// Identifies the source of [Ad]s for your application.
  // ///
  // /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  // final String adUnitId;
  //
  // /// Targeting information used to fetch an [Ad].
  // final AdRequest request;

  // /// Callback to be invoked when the ad finishes loading.
  // final InterstitialAdLoadCallback adLoadCallback;

  // /// Callbacks to be invoked when ads show and dismiss full screen content.
  // FullScreenContentCallback<InterstitialAd>? fullScreenContentCallback;

  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  /// Displays this on top of the application.
  ///
  /// Set [fullScreenContentCallback] before calling this method to be
  /// notified of events that occur when showing the ad.
  Future<void> show(FullScreenContentCallback? fullScreenContentCallback) {
    if (fullScreenContentCallback != null) {
      FullScreenContentCallback._channel.$$create(
        fullScreenContentCallback,
        $owner: false,
      );
    }
    return _channel.$show(this, fullScreenContentCallback);
  }
}

/// A full-screen interstitial ad for use with Ad Manager.
@Reference('google_mobile_ads.AdManagerInterstitialAd')
class AdManagerInterstitialAd implements $AdManagerInterstitialAd {
  // /// Creates an [AdManagerInterstitialAd].
  // ///
  // /// A valid [adUnitId] from the Ad Manager dashboard, a nonnull [listener],
  // /// and nonnull [request] is required.
  // AdManagerInterstitialAd({
  //   required this.adUnitId,
  //   required this.request,
  //   this.fullScreenContentCallback,
  //   this.appEventListener,
  // });

  // /// Identifies the source of [Ad]s for your application.
  // ///
  // /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  // final String adUnitId;
  //
  // /// Targeting information used to fetch an [Ad].
  // final AdManagerAdRequest request;

  // /// Callbacks to be invoked when ads show and dismiss full screen content.
  // FullScreenContentCallback<AdManagerInterstitialAd>? fullScreenContentCallback;
  //
  // /// An optional listener for app events.
  // AppEventListener? appEventListener;

  static $AdManagerInterstitialAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelAdManagerInterstitialAd;

  /// Loads an [AdManagerInterstitialAd] with the given [adUnitId] and [request].
  static Future<void> load({
    required String adUnitId,
    required AdManagerAdRequest request,
    required AdManagerInterstitialAdLoadCallback adLoadCallback,
  }) {
    // AdManagerInterstitialAd ad = AdManagerInterstitialAd._(
    //     adUnitId: adUnitId, adLoadCallback: adLoadCallback, request: request);
    AdManagerInterstitialAdLoadCallback._channel.$$create(
      adLoadCallback,
      $owner: false,
    );
    return _channel.$load(adUnitId, request, adLoadCallback);
  }

  /// Displays this on top of the application.
  ///
  /// Set [fullScreenContentCallback] before calling this method to be
  /// notified of events that occur when showing the ad.
  Future<void> show({
    AppEventListener? appEventListener,
    FullScreenContentCallback? fullScreenContentCallback,
  }) {
    if (fullScreenContentCallback != null) {
      FullScreenContentCallback._channel.$$create(
        fullScreenContentCallback,
        $owner: false,
      );
    }
    if (appEventListener != null) {
      AppEventListener._channel.$$create(
        appEventListener,
        $owner: false,
      );
    }
    return _channel.$show(this, appEventListener, fullScreenContentCallback);
  }
}

/// An [Ad] where a user has the option of interacting with in exchange for in-app rewards.
///
/// Because the video assets are so large, it's a good idea to start loading an
/// ad well in advance of when it's likely to be needed.
@Reference('google_mobile_ads.RewardedAd')
class RewardedAd implements $RewardedAd {
  // /// Creates a [RewardedAd] with an [AdRequest].
  // ///
  // /// A valid [adUnitId], nonnull [listener], and nonnull request is required.
  // @visibleForTesting
  // RewardedAd({
  //   required this.adUnitId,
  //   required this.rewardedAdLoadCallback,
  //   required this.request,
  //   this.serverSideVerificationOptions,
  //   this.fullScreenContentCallback,
  //   this.onUserEarnedRewardCallback,
  // });

  // /// Identifies the source of [Ad]s for your application.
  // ///
  // /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  // final String adUnitId;
  //
  // /// Targeting information used to fetch an [Ad].
  // final AdRequest request;
  //
  // /// Callbacks for events that occur when attempting to load an ad.
  // final RewardedAdLoadCallback rewardedAdLoadCallback;

  static $RewardedAdChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelRewardedAd;

  /// {@template google_mobile_ads.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro google_mobile_ads.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  // /// Optional [ServerSideVerificationOptions].
  // ServerSideVerificationOptions? serverSideVerificationOptions;
  //
  // /// Callbacks to be invoked when ads show and dismiss full screen content.
  // FullScreenContentCallback<RewardedAd>? fullScreenContentCallback;
  //
  // /// Callback for when the user earns a reward.
  // OnUserEarnedRewardCallback? onUserEarnedRewardCallback;

  /// Loads a [RewardedAd] using an [AdRequest].
  static Future<void> load({
    required String adUnitId,
    required AdRequest request,
    required RewardedAdLoadCallback adLoadCallback,
  }) {
    // RewardedAd rewardedAd = RewardedAd._(
    //     adUnitId: adUnitId,
    //     request: request,
    //     rewardedAdLoadCallback: rewardedAdLoadCallback,
    //     serverSideVerificationOptions: serverSideVerificationOptions);
    RewardedAdLoadCallback._channel.$$create(
      adLoadCallback,
      $owner: false,
    );
    return _channel.$load(
      adUnitId,
      request,
      adLoadCallback,
    );
  }

  // /// Loads a [RewardedAd] using an [AdManagerAdRequest].
  // static Future<void> loadWithAdManagerAdRequest({
  //   required String adUnitId,
  //   required AdManagerAdRequest adManagerRequest,
  //   required RewardedAdLoadCallback rewardedAdLoadCallback,
  //   ServerSideVerificationOptions? serverSideVerificationOptions,
  // }) async {
  //   RewardedAd rewardedAd = RewardedAd._fromAdManagerRequest(
  //       adUnitId: adUnitId,
  //       adManagerRequest: adManagerRequest,
  //       rewardedAdLoadCallback: rewardedAdLoadCallback,
  //       serverSideVerificationOptions: serverSideVerificationOptions);
  //
  //   await instanceManager.loadRewardedAd(rewardedAd);
  // }

  /// Display this on top of the application.
  ///
  /// Set [fullScreenContentCallback] before calling this method to be
  /// notified of events that occur when showing the ad.
  /// [onUserEarnedReward] will be invoked when the user earns a reward.
  Future<void> show({
    required OnUserEarnedRewardListener onUserEarnedReward,
    ServerSideVerificationOptions? serverSideVerificationOptions,
    FullScreenContentCallback? fullScreenContentCallback,
  }) {
    if (fullScreenContentCallback != null) {
      FullScreenContentCallback._channel.$$create(
        fullScreenContentCallback,
        $owner: false,
      );
    }
    OnUserEarnedRewardListener._channel.$$create(
      onUserEarnedReward,
      $owner: false,
    );
    return _channel.$show(
      this,
      onUserEarnedReward,
      serverSideVerificationOptions,
      fullScreenContentCallback,
    );
  }
}

/// Credit information about a reward received from a [RewardedAd].
@Reference('google_mobile_ads.RewardItem')
class RewardItem implements $RewardItem {
  /// Default constructor for [RewardItem].
  ///
  /// This is mostly used to return [RewardItem]s for a [RewardedAd] and
  /// shouldn't be needed to be used directly.
  const RewardItem(this.amount, this.type);

  /// Credit amount rewarded from a [RewardedAd].
  final num amount;

  /// Type of credit rewarded.
  final String type;
}

/// Options for RewardedAd server-side verification callbacks.
///
/// See https://developers.google.com/admob/ios/rewarded-video-ssv and
/// https://developers.google.com/admob/android/rewarded-video-ssv for more
/// information.
@Reference('google_mobile_ads.ServerSideVerificationOptions')
class ServerSideVerificationOptions implements $ServerSideVerificationOptions {
  /// Create [ServerSideVerificationOptions] with the userId or customData.
  const ServerSideVerificationOptions({this.userId, this.customData});

  /// The user id to be used in server-to-server reward callbacks.
  final String? userId;

  /// The custom data to be used in server-to-server reward callbacks
  final String? customData;

  @ReferenceMethod(ignore: true)
  @override
  bool operator ==(other) {
    return other is ServerSideVerificationOptions &&
        userId == other.userId &&
        customData == other.customData;
  }
}

/// Listen for when a user earns a reward from a [RewardedAd].
@Reference('google_mobile_ads.OnUserEarnedRewardListener')
mixin OnUserEarnedRewardListener implements $OnUserEarnedRewardListener {
  static $OnUserEarnedRewardListenerChannel get _channel => ChannelRegistrar
      .instance.implementations.channelOnUserEarnedRewardListener;

  /// When a user earns a reward from a [RewardedAd].
  @override
  void onUserEarnedRewardCallback(covariant RewardItem reward);
}

/// Listener for app events.
@Reference('google_mobile_ads.AppEventListener')
mixin AppEventListener implements $AppEventListener {
  static $AppEventListenerChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelAppEventListener;

  /// Called when an app event is received.
  @override
  void onAppEvent(String name, String data);
}

/// Shared event callbacks used in Native and Banner ads.
@Reference('google_mobile_ads.AdWithViewListener')
mixin AdWithViewListener implements $AdWithViewListener {
  // /// Default constructor for [AdWithViewListener], meant to be used by subclasses.
  // @protected
  // const AdWithViewListener({
  //   this.onAdLoaded,
  //   this.onAdFailedToLoad,
  //   this.onAdOpened,
  //   this.onAdWillDismissScreen,
  //   this.onAdImpression,
  //   this.onAdClosed,
  // });
  /// Called when an ad is successfully received.
  @override
  void onAdLoaded();

  /// Called when an ad request failed.
  @override
  void onAdFailedToLoad(covariant LoadAdError error);

  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  @override
  void onAdOpened();

  /// For iOS only. Called before dismissing a full screen view.
  @override
  void onAdWillDismissScreen();

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  @override
  void onAdClosed();

  /// Called when an impression occurs on the ad.
  @override
  void onAdImpression();
}

/// A listener for receiving notifications for the lifecycle of a [BannerAd].
@Reference('google_mobile_ads.BannerAdListener')
mixin BannerAdListener implements AdWithViewListener, $BannerAdListener {
  static $BannerAdListenerChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelBannerAdListener;
//   /// Constructs a [BannerAdListener] that notifies for the provided event callbacks.
//   ///
//   /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
//   /// ```dart
//   /// BannerAdListener(
//   ///   onAdLoaded: (ad) {
//   ///     // Ad successfully loaded - display an AdWidget with the banner ad.
//   ///   },
//   ///   onAdFailedToLoad: (ad, error) {
//   ///     // Ad failed to load - log the error and dispose the ad.
//   ///   },
//   ///   ...
//   /// )
//   /// ```
//   const BannerAdListener({
//     AdEventCallback? onAdLoaded,
//     AdLoadErrorCallback? onAdFailedToLoad,
//     AdEventCallback? onAdOpened,
//     AdEventCallback? onAdClosed,
//     AdEventCallback? onAdWillDismissScreen,
//     AdEventCallback? onAdImpression,
//   }) : super(
//           onAdLoaded: onAdLoaded,
//           onAdFailedToLoad: onAdFailedToLoad,
//           onAdOpened: onAdOpened,
//           onAdClosed: onAdClosed,
//           onAdWillDismissScreen: onAdWillDismissScreen,
//           onAdImpression: onAdImpression,
//         );
}

/// A listener for receiving notifications for the lifecycle of an [AdManagerBannerAd].
@Reference('google_mobile_ads.AdManagerBannerAdListener')
mixin AdManagerBannerAdListener
    implements BannerAdListener, AppEventListener, $AdManagerBannerAdListener {
  static $AdManagerBannerAdListenerChannel get _channel => ChannelRegistrar
      .instance.implementations.channelAdManagerBannerAdListener;

  /// Constructs an [AdManagerBannerAdListener] with the provided event callbacks.
  ///
  /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
  /// ```dart
  /// AdManagerBannerAdListener(
  ///   onAdLoaded: (ad) {
  ///     // Ad successfully loaded - display an AdWidget with the banner ad.
  ///   },
  ///   onAdFailedToLoad: (ad, error) {
  ///     // Ad failed to load - log the error and dispose the ad.
  ///   },
  ///   ...
  /// )
  /// ```
  // AdManagerBannerAdListener({
  //   AdEventCallback? onAdLoaded,
  //   Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
  //   AdEventCallback? onAdOpened,
  //   AdEventCallback? onAdWillDismissScreen,
  //   AdEventCallback? onAdClosed,
  //   AdEventCallback? onAdImpression,
  //   this.onAppEvent,
  // }) : super(
  //           onAdLoaded: onAdLoaded,
  //           onAdFailedToLoad: onAdFailedToLoad,
  //           onAdOpened: onAdOpened,
  //           onAdWillDismissScreen: onAdWillDismissScreen,
  //           onAdClosed: onAdClosed,
  //           onAdImpression: onAdImpression);
  //
  // /// Called when an app event is received.
  // @override
  // void onAppEvent(String name, String data);
}

/// A listener for receiving notifications for the lifecycle of a [NativeAd].
@Reference('google_mobile_ads.NativeAdListener')
mixin NativeAdListener implements AdWithViewListener, $NativeAdListener {
  static $NativeAdListenerChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelNativeAdListener;
  // /// Constructs a [NativeAdListener] with the provided event callbacks.
  // ///
  // /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
  // /// ```dart
  // /// NativeAdListener(
  // ///   onAdLoaded: (ad) {
  // ///     // Ad successfully loaded - display an AdWidget with the native ad.
  // ///   },
  // ///   onAdFailedToLoad: (ad, error) {
  // ///     // Ad failed to load - log the error and dispose the ad.
  // ///   },
  // ///   ...
  // /// )
  // /// ```
  // NativeAdListener({
  //   AdEventCallback? onAdLoaded,
  //   Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
  //   AdEventCallback? onAdOpened,
  //   AdEventCallback? onAdWillDismissScreen,
  //   AdEventCallback? onAdClosed,
  //   AdEventCallback? onAdImpression,
  //   this.onNativeAdClicked,
  // }) : super(
  //           onAdLoaded: onAdLoaded,
  //           onAdFailedToLoad: onAdFailedToLoad,
  //           onAdOpened: onAdOpened,
  //           onAdWillDismissScreen: onAdWillDismissScreen,
  //           onAdClosed: onAdClosed,
  //           onAdImpression: onAdImpression);

  /// Called when a click is recorded for a [NativeAd].
  @override
  void onAdClicked();
}

/// Callback events for for full screen ads, such as Rewarded and Interstitial.
@Reference('google_mobile_ads.FullScreenContentCallback')
mixin FullScreenContentCallback implements $FullScreenContentCallback {
  static $FullScreenContentCallbackChannel get _channel => ChannelRegistrar
      .instance.implementations.channelFullScreenContentCallback;
  // /// Construct a new [FullScreenContentCallback].
  // ///
  // /// [Ad.dispose] should be called from [onAdFailedToShowFullScreenContent]
  // /// and [onAdDismissedFullScreenContent], in order to free up resources.
  // const FullScreenContentCallback({
  //   this.onAdShowedFullScreenContent,
  //   this.onAdImpression,
  //   this.onAdFailedToShowFullScreenContent,
  //   this.onAdWillDismissFullScreenContent,
  //   this.onAdDismissedFullScreenContent,
  // });

  /// Called when an ad shows full screen content.
  @override
  void onAdShowedFullScreenContent();

  /// Called when an ad dismisses full screen content.
  @override
  void onAdDismissedFullScreenContent();

  /// For iOS only. Called before dismissing a full screen view.
  @override
  void onAdWillDismissFullScreenContent();

  /// Called when an ad impression occurs.
  @override
  void onAdImpression();

  /// Called when ad fails to show full screen content.
  @override
  void onAdFailedToShowFullScreenContent();
}

/// Generic parent class for ad load callbacks.
mixin FullScreenAdLoadCallback<T> {
  // /// Default constructor for [FullScreenAdLoadCallback[, used by subclasses.
  // const FullScreenAdLoadCallback({
  //   required this.onAdLoaded,
  //   required this.onAdFailedToLoad,
  // });

  /// Called when the ad successfully loads.
  void onAdLoaded(T ad);

  /// Called when an error occurs loading the ad.
  void onAdFailedToLoad(covariant LoadAdError error);
}

/// This class holds callbacks for loading a [RewardedAd].
@Reference('google_mobile_ads.RewardedAdLoadCallback')
mixin RewardedAdLoadCallback
    implements FullScreenAdLoadCallback<RewardedAd>, $RewardedAdLoadCallback {
  static $RewardedAdLoadCallbackChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelRewardedAdLoadCallback;
  // /// Construct a [RewardedAdLoadCallback].
  // ///
  // /// [Ad.dispose] should be invoked from [onAdFailedToLoad].
  // const RewardedAdLoadCallback({
  //   required GenericAdEventCallback<RewardedAd> onAdLoaded,
  //   required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  // }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);

  @override
  void onAdLoaded(covariant RewardedAd ad);

  @override
  void onAdFailedToLoad(covariant LoadAdError error);
}

/// This class holds callbacks for loading an [InterstitialAd].
@Reference('google_mobile_ads.InterstitialAdLoadCallback')
mixin InterstitialAdLoadCallback
    implements
        FullScreenAdLoadCallback<InterstitialAd>,
        $InterstitialAdLoadCallback {
  static $InterstitialAdLoadCallbackChannel get _channel => ChannelRegistrar
      .instance.implementations.channelInterstitialAdLoadCallback;
  // /// Construct a [InterstitialAdLoadCallback].
  // ///
  // /// [Ad.dispose] should be invoked from [onAdFailedToLoad].
  // const InterstitialAdLoadCallback({
  //   required GenericAdEventCallback<InterstitialAd> onAdLoaded,
  //   required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  // }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);

  @override
  void onAdLoaded(covariant InterstitialAd ad);

  @override
  void onAdFailedToLoad(covariant LoadAdError error);
}

/// This class holds callbacks for loading an [AdManagerInterstitialAd].
@Reference('google_mobile_ads.AdManagerInterstitialAdLoadCallback')
mixin AdManagerInterstitialAdLoadCallback
    implements
        FullScreenAdLoadCallback<AdManagerInterstitialAd>,
        $AdManagerInterstitialAdLoadCallback {
  static $AdManagerInterstitialAdLoadCallbackChannel get _channel =>
      ChannelRegistrar
          .instance.implementations.channelAdManagerInterstitialAdLoadCallback;
  // /// Construct a [AdManagerInterstitialAdLoadCallback].
  // ///
  // /// [Ad.dispose] should be invoked from [onAdFailedToLoad].
  // const AdManagerInterstitialAdLoadCallback({
  //   required GenericAdEventCallback<AdManagerInterstitialAd> onAdLoaded,
  //   required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  // }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);

  @override
  void onAdLoaded(covariant AdManagerInterstitialAd ad);

  @override
  void onAdFailedToLoad(covariant LoadAdError error);
}
