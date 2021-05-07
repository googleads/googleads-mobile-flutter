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

/// Base class for all ad listeners.
///
/// Contains callbacks for successful and failed load events.
abstract class BaseAdListener {
  /// Default constructor for [BaseAdListener].
  const BaseAdListener(this.onAdLoaded, this.onAdFailedToLoad);

  /// Called when an ad is successfully received.
  final void Function(Ad ad)? onAdLoaded;

  /// Called when an ad request failed.
  final void Function(Ad ad, LoadAdError error)? onAdFailedToLoad;
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
  void Function(Ad ad)? onAdOpened;

  /// Called when the full screen view will be dismissed.
  ///
  /// Note this is only invoked on iOS.
  void Function(Ad ad)? onAdWillDismissScreen;

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  void Function(Ad ad)? onAdClosed;

  /// Called when an impression occurs on the ad.
  void Function(Ad ad)? onAdImpression;
}

/// Listener for Banner Ads.
class BannerAdListener extends BaseAdListener implements AdWithViewListener {
  /// Default constructor for [BannerAdListener].
  BannerAdListener({
    Function(Ad ad)? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    this.onAdOpened,
    this.onAdWillDismissScreen,
    this.onAdClosed,
    this.onAdImpression,
  }) : super(onAdLoaded, onAdFailedToLoad);

  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  @override
  void Function(Ad ad)? onAdOpened;

  /// Called when the full screen view will be dismissed.
  ///
  /// Note this is only invoked on iOS.
  @override
  void Function(Ad ad)? onAdWillDismissScreen;

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  @override
  void Function(Ad ad)? onAdClosed;

  /// Called when an impression occurs on the ad.
  @override
  void Function(Ad ad)? onAdImpression;
}

/// Listener for Ad Manager Banner Ads.
class AdManagerBannerAdListener extends BannerAdListener
    implements AppEventListener, AdWithViewListener {
  /// Default constructor for [AdManagerBannerAdListener].
  AdManagerBannerAdListener(
      {Function(Ad ad)? onAdLoaded,
      Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
      Function(Ad ad)? onAdOpened,
      Function(Ad ad)? onAdWillDismissScreen,
      Function(Ad ad)? onAdClosed,
      Function(Ad ad)? onAdImpression,
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
    Function(Ad ad)? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    this.onAdShowedFullScreenContent,
    this.onAdDismissedFullScreenContent,
    this.onAdImpression,
    this.onAdFailedToShowFullScreenContent,
    this.onAdWillDismissFullScreenContent,
  }) : super(onAdLoaded, onAdFailedToLoad);

  /// Called when an ad shows full screen content.
  final void Function(Ad ad)? onAdShowedFullScreenContent;

  /// Called when an ad dismisses full screen content.
  final void Function(Ad ad)? onAdDismissedFullScreenContent;

  /// Called when the ad will dismiss full screen content.
  ///
  /// Note this is only invoked on iOS.
  final void Function(Ad ad)? onAdWillDismissFullScreenContent;

  /// Called when an ad impression occurs.
  final void Function(Ad ad)? onAdImpression;

  /// Called when ad fails to show full screen content.
  final void Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent;
}

/// Listener for Admob iOS interstitial ads.
class InterstitialAdListener extends FullScreenAdListener {
  /// Constructor for [InterstitialAdListener].
  const InterstitialAdListener({
    Function(Ad ad)? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    Function(Ad ad)? onAdShowedFullScreenContent,
    Function(Ad ad)? onAdDismissedFullScreenContent,
    Function(Ad ad)? onAdWillDismissFullScreenContent,
    Function(Ad ad)? onAdImpression,
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
    Function(Ad ad)? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    Function(Ad ad)? onAdShowedFullScreenContent,
    Function(Ad ad)? onAdDismissedFullScreenContent,
    Function(Ad ad)? onAdWillDismissFullScreenContent,
    Function(Ad ad)? onAdImpression,
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
    Function(Ad ad)? onAdLoaded,
    Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    Function(Ad ad)? onAdShowedFullScreenContent,
    Function(Ad ad)? onAdDismissedFullScreenContent,
    Function(Ad ad)? onAdWillDismissFullScreenContent,
    Function(Ad ad)? onAdImpression,
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
    Function(Ad ad)? onAdLoaded,
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
  void Function(Ad ad)? onAdImpression;

  /// Called when presenting the user a full screen view in response to an
  /// ad action. Use this opportunity to stop animations, time sensitive
  /// interactions, etc.
  @override
  void Function(Ad ad)? onAdOpened;

  /// For iOS only. Called before dismissing a full screen view.
  @override
  void Function(Ad ad)? onAdWillDismissScreen;

  /// Called after dismissing a full screen view. Use this opportunity to
  /// restart anything you may have stopped as part of [onAdOpened].
  @override
  void Function(Ad ad)? onAdClosed;
}
