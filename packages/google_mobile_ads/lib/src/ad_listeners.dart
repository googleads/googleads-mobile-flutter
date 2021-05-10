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

import 'ad_containers.dart';

/// The callback type to handle an event occurring for an [Ad].
typedef AdEventCallback = void Function(Ad ad);

typedef GenericAdEventCallback<Ad> = void Function(Ad ad);

typedef GenericAdLoadErrorCallback<Ad> = void Function(
    Ad ad, LoadAdError error);

typedef OnUserEarnedRewardCallback = void Function(
    RewardedAd ad, RewardItem reward);

/// The callback type to handle an error loading an [Ad].
typedef AdLoadErrorCallback = void Function(Ad ad, LoadAdError error);

/// Base class for all ad listeners.
///
/// Contains callbacks for successful and failed load events.
abstract class BaseAdListener {
  /// Default constructor for [BaseAdListener], meant to be used by subclasses.
  BaseAdListener(this.onAdLoaded, this.onAdFailedToLoad);

  /// Called when an ad is successfully received.
  AdEventCallback? onAdLoaded;

  /// Called when an ad request failed.
  AdLoadErrorCallback? onAdFailedToLoad;
}

/// Listener for app events.
class AppEventListener {
  /// Called when an app event is received.
  void Function(Ad ad, String name, String data)? onAppEvent;
}

/// Shared event callbacks used in Native and Banner ads.
class AdWithViewListener {
  /// Called when an ad is successfully received.
  AdEventCallback? onAdLoaded;

  /// Called when an ad request failed.
  AdLoadErrorCallback? onAdFailedToLoad;

  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  AdEventCallback? onAdOpened;

  /// For iOS only. Called before dismissing a full screen view.
  AdEventCallback? onAdWillDismissScreen;

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  AdEventCallback? onAdClosed;

  /// Called when an impression occurs on the ad.
  AdEventCallback? onAdImpression;
}

/// Listener for Banner Ads.
class BannerAdListener extends BaseAdListener implements AdWithViewListener {
  /// Constructs a [BannerAdListener] that notifies for the provided event callbacks.
  ///
  /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
  /// ```dart
  /// BannerAdListener(
  ///   onAdLoaded: (ad) {
  ///     // Ad successfully loaded - display an AdWidget with the banner ad.
  ///   },
  ///   onAdFailedToLoad: (ad, error) {
  ///     // Ad failed to load - log the error and dispose the ad.
  ///   },
  ///   ...
  /// )
  /// ```
  BannerAdListener({
    AdEventCallback? onAdLoaded,
    AdLoadErrorCallback? onAdFailedToLoad,
    this.onAdOpened,
    this.onAdWillDismissScreen,
    this.onAdClosed,
    this.onAdImpression,
  }) : super(onAdLoaded, onAdFailedToLoad);

  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  @override
  AdEventCallback? onAdOpened;

  /// For iOS only. Called before dismissing a full screen view.
  @override
  AdEventCallback? onAdWillDismissScreen;

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  @override
  AdEventCallback? onAdClosed;

  /// Called when an impression occurs on the ad.
  @override
  AdEventCallback? onAdImpression;
}

/// Listener for Ad Manager Banner Ads.
class AdManagerBannerAdListener extends BannerAdListener
    implements AppEventListener, AdWithViewListener {
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
  AdManagerBannerAdListener(
      {AdEventCallback? onAdLoaded,
      Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
      AdEventCallback? onAdOpened,
      AdEventCallback? onAdWillDismissScreen,
      AdEventCallback? onAdClosed,
      AdEventCallback? onAdImpression,
      this.onAppEvent})
      : super(
            onAdLoaded: onAdLoaded,
            onAdFailedToLoad: onAdFailedToLoad,
            onAdOpened: onAdOpened,
            onAdWillDismissScreen: onAdWillDismissScreen,
            onAdClosed: onAdClosed,
            onAdImpression: onAdImpression);

  /// Called when an app event is received.
  @override
  void Function(Ad ad, String name, String data)? onAppEvent;
}

/// Listener for native ads.
class NativeAdListener extends BaseAdListener implements AdWithViewListener {
  /// Constructs a [NativeAdListener] with the provided event callbacks.
  ///
  /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
  /// ```dart
  /// NativeAdListener(
  ///   onAdLoaded: (ad) {
  ///     // Ad successfully loaded - display an AdWidget with the banner ad.
  ///   },
  ///   onAdFailedToLoad: (ad, error) {
  ///     // Ad failed to load - log the error and dispose the ad.
  ///   },
  ///   ...
  /// )
  /// ```
  NativeAdListener({
    AdEventCallback? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    this.onNativeAdClicked,
    this.onAdImpression,
    this.onAdOpened,
    this.onAdWillDismissScreen,
    this.onAdClosed,
  }) : super(onAdLoaded, onAdFailedToLoad);

  /// Called when a click is recorded for a [NativeAd].
  final void Function(NativeAd ad)? onNativeAdClicked;

  /// Called when an impression is recorded for a [NativeAd].
  @override
  AdEventCallback? onAdImpression;

  /// Called when presenting the user a full screen view in response to an
  /// ad action. Use this opportunity to stop animations, time sensitive
  /// interactions, etc.
  @override
  AdEventCallback? onAdOpened;

  /// For iOS only. Called before dismissing a full screen view.
  @override
  AdEventCallback? onAdWillDismissScreen;

  /// Called after dismissing a full screen view. Use this opportunity to
  /// restart anything you may have stopped as part of [onAdOpened].
  @override
  AdEventCallback? onAdClosed;
}

//////////// New Ad Listener classes

class FullScreenContentCallback<Ad> {
  /// Construct a new [FullScreenContentCallback]. TODO - fix comment.
  FullScreenContentCallback(
      {this.onAdShowedFullScreenContent,
      this.onAdImpression,
      this.onAdFailedToShowFullScreenContent,
      this.onAdWillDismissFullScreenContent,
      this.onAdDismissedFullScreenContent});

  /// Called when an ad shows full screen content.
  GenericAdEventCallback<Ad>? onAdShowedFullScreenContent;

  /// Called when an ad dismisses full screen content.
  GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent;

  /// For iOS only. Called before dismissing a full screen view.
  GenericAdEventCallback<Ad>? onAdWillDismissFullScreenContent;

  /// Called when an ad impression occurs.
  GenericAdEventCallback<Ad>? onAdImpression;

  /// Called when ad fails to show full screen content.
  void Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent;
}

abstract class AdLoadCallback<Ad> {
  const AdLoadCallback(
      {required this.onAdLoaded, required this.onAdFailedToLoad});

  final GenericAdEventCallback<Ad> onAdLoaded;

  final GenericAdLoadErrorCallback<Ad> onAdFailedToLoad;
}

/// This class holds callbacks for loading a [RewardedAd].
class RewardedAdLoadCallback extends AdLoadCallback<RewardedAd> {
  /// Construct a [RewardedAdLoadCallback].
  ///
  /// [TODO - example of what to do.]
  const RewardedAdLoadCallback(
      {required GenericAdEventCallback<RewardedAd> onAdLoaded,
      required GenericAdLoadErrorCallback<RewardedAd> onAdFailedToLoad})
      : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}

/// This class holds callbacks for loading an [InterstitialAd].
class InterstitialAdLoadCallback extends AdLoadCallback<InterstitialAd> {
  /// Construct a [InterstitialAdLoadCallback].
  ///
  /// [TODO - example of what to do.]
  const InterstitialAdLoadCallback(
      {required GenericAdEventCallback<InterstitialAd> onAdLoaded,
      required GenericAdLoadErrorCallback<InterstitialAd> onAdFailedToLoad})
      : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}

/// This class holds callbacks for loading an [InterstitialAd].
class AdManagerInterstitialAdLoadCallback
    extends AdLoadCallback<AdManagerInterstitialAd> {
  /// Construct a [AdManagerInterstitialAdLoadCallback].
  ///
  /// [TODO - example of what to do.]
  const AdManagerInterstitialAdLoadCallback(
      {required GenericAdEventCallback<AdManagerInterstitialAd> onAdLoaded,
      required GenericAdLoadErrorCallback<AdManagerInterstitialAd>
          onAdFailedToLoad})
      : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}
