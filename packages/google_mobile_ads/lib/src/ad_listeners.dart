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

import 'package:reference/annotations.dart';

import 'ad_containers.dart';

// /// The callback type to handle an event occurring for an [Ad].
// typedef AdEventCallback = void Function(Ad ad);
//
// /// Generic callback type for an event occurring on an Ad.
// typedef GenericAdEventCallback<Ad> = void Function(Ad ad);
//
// /// A callback type for when an error occurs loading a full screen ad.
// typedef FullScreenAdLoadErrorCallback = void Function(LoadAdError error);
//
// /// The callback type for when a user earns a reward from a [RewardedAd].
// typedef OnUserEarnedRewardCallback = void Function(
//     RewardedAd ad, RewardItem reward);

// /// The callback type to handle an error loading an [Ad].
// typedef AdLoadErrorCallback = void Function(Ad ad, LoadAdError error);

// /// The callback type to handle an error loading an [Ad].
// abstract class AdLoadErrorCallback {
//   /// Called when an add experiences an error when calling `load`.
//   void onLoadAdError(LoadAdError error);
//

@Reference('')

/// Listen for when a user earns a reward from a [RewardedAd].
abstract class OnUserEarnedRewardListener {
  /// When a user earns a reward from a [RewardedAd].
  void onUserEarnedRewardCallback(RewardItem reward);
}

/// Listener for app events.
@Reference('google_mobile_ads.AppEventListener')
abstract class AppEventListener {
  /// Called when an app event is received.
  void onAppEvent(String name, String data);
}

/// Shared event callbacks used in Native and Banner ads.
@Reference('google_mobile_ads.AdWithViewListener')
abstract class AdWithViewListener {
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
  void onAdLoaded();

  /// Called when an ad request failed.
  void onAdFailedToLoad(LoadAdError error);

  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  void onAdOpened();

  /// For iOS only. Called before dismissing a full screen view.
  void onAdWillDismissScreen();

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  void onAdClosed();

  /// Called when an impression occurs on the ad.
  void onAdImpression();
}

/// A listener for receiving notifications for the lifecycle of a [BannerAd].
@Reference('google_mobile_ads.BannerAdListener')
abstract class BannerAdListener implements AdWithViewListener {
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
abstract class AdManagerBannerAdListener
    implements BannerAdListener, AppEventListener {
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
abstract class NativeAdListener implements AdWithViewListener {
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
  void onAdClicked();
}

/// Callback events for for full screen ads, such as Rewarded and Interstitial.
@Reference('google_mobile_ads.FullScreenContentCallback')
abstract class FullScreenContentCallback {
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
  void onAdShowedFullScreenContent();

  /// Called when an ad dismisses full screen content.
  void onAdDismissedFullScreenContent();

  /// For iOS only. Called before dismissing a full screen view.
  void onAdWillDismissFullScreenContent();

  /// Called when an ad impression occurs.
  void onAdImpression();

  /// Called when ad fails to show full screen content.
  void onAdFailedToShowFullScreenContent();
}

/// Generic parent class for ad load callbacks.
@Reference('google_mobile_ads.FullScreenAdLoadCallback')
abstract class FullScreenAdLoadCallback {
  // /// Default constructor for [FullScreenAdLoadCallback[, used by subclasses.
  // const FullScreenAdLoadCallback({
  //   required this.onAdLoaded,
  //   required this.onAdFailedToLoad,
  // });

  /// Called when the ad successfully loads.
  void onAdLoaded();

  /// Called when an error occurs loading the ad.
  void onAdFailedToLoad(LoadAdError error);
}

/// This class holds callbacks for loading a [RewardedAd].
@Reference('google_mobile_ads.RewardedAdLoadCallback')
abstract class RewardedAdLoadCallback implements FullScreenAdLoadCallback {
  // /// Construct a [RewardedAdLoadCallback].
  // ///
  // /// [Ad.dispose] should be invoked from [onAdFailedToLoad].
  // const RewardedAdLoadCallback({
  //   required GenericAdEventCallback<RewardedAd> onAdLoaded,
  //   required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  // }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}

/// This class holds callbacks for loading an [InterstitialAd].
@Reference('google_mobile_ads.InterstitialAdLoadCallback')
abstract class InterstitialAdLoadCallback implements FullScreenAdLoadCallback {
  // /// Construct a [InterstitialAdLoadCallback].
  // ///
  // /// [Ad.dispose] should be invoked from [onAdFailedToLoad].
  // const InterstitialAdLoadCallback({
  //   required GenericAdEventCallback<InterstitialAd> onAdLoaded,
  //   required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  // }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}

/// This class holds callbacks for loading an [AdManagerInterstitialAd].
@Reference('google_mobile_ads.AdManagerInterstitialAdLoadCallback')
abstract class AdManagerInterstitialAdLoadCallback
    implements FullScreenAdLoadCallback {
  // /// Construct a [AdManagerInterstitialAdLoadCallback].
  // ///
  // /// [Ad.dispose] should be invoked from [onAdFailedToLoad].
  // const AdManagerInterstitialAdLoadCallback({
  //   required GenericAdEventCallback<AdManagerInterstitialAd> onAdLoaded,
  //   required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  // }) : super(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
}
