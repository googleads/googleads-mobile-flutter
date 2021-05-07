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

/// The callback type to handle an error loading an [Ad].
typedef AdLoadErrorCallback = void Function(Ad ad, LoadAdError error);

/// Base class for all ad listeners.
///
/// Contains callbacks for successful and failed load events.
abstract class BaseAdListener {
  /// Default constructor for [BaseAdListener].
  const BaseAdListener(this.onAdLoaded, this.onAdFailedToLoad);

  /// Called when an ad is successfully received.
  final AdEventCallback? onAdLoaded;

  /// Called when an ad request failed.
  final AdLoadErrorCallback? onAdFailedToLoad;
}

/// Listener for app events.
class AppEventListener {
  /// Called when an app event is received.
  void Function(Ad ad, String name, String data)? onAppEvent;
}

/// Shared event callbacks used in Native and Banner ads.
class AdWithViewListener {
  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  AdEventCallback? onAdOpened;

  /// Called when the full screen view will be dismissed.
  ///
  /// Note this is only invoked on iOS.
  AdEventCallback? onAdWillDismissScreen;

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  AdEventCallback? onAdClosed;

  /// Called when an impression occurs on the ad.
  AdEventCallback? onAdImpression;
}

/// Listener for Banner Ads.
class BannerAdListener extends BaseAdListener implements AdWithViewListener {
  /// Default constructor for [BannerAdListener].
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

  /// Called when the full screen view will be dismissed.
  ///
  /// Note this is only invoked on iOS.
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
  /// Default constructor for [AdManagerBannerAdListener].
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

/// Base class for Full Screen Ads.
abstract class FullScreenAdListener extends BaseAdListener {
  /// Constructor for [FullScreenAdListener].
  const FullScreenAdListener({
    AdEventCallback? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    this.onAdShowedFullScreenContent,
    this.onAdDismissedFullScreenContent,
    this.onAdImpression,
    this.onAdFailedToShowFullScreenContent,
    this.onAdWillDismissFullScreenContent,
  }) : super(onAdLoaded, onAdFailedToLoad);

  /// Called when an ad shows full screen content.
  final AdEventCallback? onAdShowedFullScreenContent;

  /// Called when an ad dismisses full screen content.
  final AdEventCallback? onAdDismissedFullScreenContent;

  /// Called when the ad will dismiss full screen content.
  ///
  /// Note this is only invoked on iOS.
  final AdEventCallback? onAdWillDismissFullScreenContent;

  /// Called when an ad impression occurs.
  final AdEventCallback? onAdImpression;

  /// Called when ad fails to show full screen content.
  final void Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent;
}

/// Listener for Admob iOS interstitial ads.
class InterstitialAdListener extends FullScreenAdListener {
  /// Constructor for [InterstitialAdListener].
  const InterstitialAdListener({
    AdEventCallback? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    AdEventCallback? onAdShowedFullScreenContent,
    AdEventCallback? onAdDismissedFullScreenContent,
    AdEventCallback? onAdWillDismissFullScreenContent,
    AdEventCallback? onAdImpression,
    Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent,
  }) : super(
            onAdLoaded: onAdLoaded,
            onAdFailedToLoad: onAdFailedToLoad,
            onAdShowedFullScreenContent: onAdShowedFullScreenContent,
            onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
            onAdWillDismissFullScreenContent: onAdWillDismissFullScreenContent,
            onAdImpression: onAdImpression,
            onAdFailedToShowFullScreenContent:
                onAdFailedToShowFullScreenContent);
}

/// Listener for Ad Manager interstitial ads.
class AdManagerInterstitialAdListener extends FullScreenAdListener
    implements AppEventListener {
  /// Constructor for [AdManagerInterstitialAdListener].
  AdManagerInterstitialAdListener({
    AdEventCallback? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    AdEventCallback? onAdShowedFullScreenContent,
    AdEventCallback? onAdDismissedFullScreenContent,
    AdEventCallback? onAdWillDismissFullScreenContent,
    AdEventCallback? onAdImpression,
    Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent,
    this.onAppEvent,
  }) : super(
            onAdLoaded: onAdLoaded,
            onAdFailedToLoad: onAdFailedToLoad,
            onAdShowedFullScreenContent: onAdShowedFullScreenContent,
            onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
            onAdWillDismissFullScreenContent: onAdWillDismissFullScreenContent,
            onAdImpression: onAdImpression,
            onAdFailedToShowFullScreenContent:
                onAdFailedToShowFullScreenContent);

  /// Called when an app event is received.
  @override
  void Function(Ad ad, String name, String data)? onAppEvent;
}

/// Listener for rewarded ads.
class RewardedAdListener extends FullScreenAdListener {
  /// Constructor for [RewardedAdListener].
  const RewardedAdListener({
    AdEventCallback? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    AdEventCallback? onAdShowedFullScreenContent,
    AdEventCallback? onAdDismissedFullScreenContent,
    AdEventCallback? onAdWillDismissFullScreenContent,
    AdEventCallback? onAdImpression,
    Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent,
    this.onRewardedAdUserEarnedReward,
  }) : super(
            onAdLoaded: onAdLoaded,
            onAdFailedToLoad: onAdFailedToLoad,
            onAdShowedFullScreenContent: onAdShowedFullScreenContent,
            onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
            onAdWillDismissFullScreenContent: onAdWillDismissFullScreenContent,
            onAdImpression: onAdImpression,
            onAdFailedToShowFullScreenContent:
                onAdFailedToShowFullScreenContent);

  /// Called when a [RewardedAd] triggers a reward.
  final void Function(
    RewardedAd ad,
    RewardItem reward,
  )? onRewardedAdUserEarnedReward;
}

/// Listener for native ads.
class NativeAdListener extends BaseAdListener implements AdWithViewListener {
  /// Default constructor for [NativeAdListener].
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
