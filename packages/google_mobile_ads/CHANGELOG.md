## 0.13.3

* Adds support for NativeAdOptions. More documentation also available for [Android](https://developers.google.com/admob/android/native/options) and [iOS](https://developers.google.com/admob/ios/native/options)

## 0.13.2+1

* Fixes [Issue #130](https://github.com/googleads/googleads-mobile-flutter/issues/130)

## 0.13.2

* Fixes a crash where [PlatformView.getView() returns null](https://github.com/googleads/googleads-mobile-flutter/issues/46)
* Fixes memory leaks on Android.
* Fixes a [crash on iOS](https://github.com/googleads/googleads-mobile-flutter/issues/138).
* Marks smart banner sizes as deprecated. Instead you should use adaptive banners.

## 0.13.1

* Adds support for the paid event callback.

## 0.13.0

* Updates GMA Android and iOS dependencies to 20.1.0 and 8.5.0, respectively.
* Renames APIs that use the `Publisher` prefix to `AdManager`.
* Rewarded and Interstitial ads now provide static `load` methods and a new `FullScreenContentCallback` for full screen events.
* Native ads use [GADNativeAdView](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/api/reference/Classes/GADNativeAdView) for iOS 
and [NativeAdView](https://developers.google.com/android/reference/com/google/android/gms/ads/nativead/NativeAdView) on Android.
* Adds support for [ResponseInfo](https://developers.google.com/admob/android/response-info).
* Adds support for [same app key](https://developers.google.com/admob/ios/ios14#same_app_key) on iOS.
* Removes `testDevices` from `AdRequest`. Use `MobileAds.updateRequestConfiguration` to set test device ids.
* Removes `Ad.isLoaded()`. Instead you should use the `onAdLoaded` callback to track whether an ad is loaded.
* Removes need to call `Ad.dispose()` for Rewarded and Interstitial ads when they fail to load.

## 0.12.2+1

* Fix anchored adaptive banner message corruption error.
* Update example app with better practices and adaptive banner.

## 0.12.2

* Add support for anchored adaptive banners.

## 0.12.1+1

* Fixes a [crash with Swift based native ads](https://github.com/googleads/googleads-mobile-flutter/issues/121)

## 0.12.1

* Rewarded ads now take an optional `ServerSideVerification`, to support [custom data in rewarded ads](https://developers.google.com/admob/ios/rewarded-video-ssv#custom_data).

## 0.12.0

* Migrated to null safety. Minimum Dart SDK version is bumped to 2.12.0.

## 0.11.0+4

* Fixes a [bug](https://github.com/googleads/googleads-mobile-flutter/issues/47) where state is not properly cleaned up on hot restart.
* Update README and example app to appropriately dispose ads.

## 0.11.0+3

* Fixes an [Android crash](https://github.com/googleads/googleads-mobile-flutter/issues/46) when reusing Native and Banner Ad objects.
* Fixes [iOS memory leaks](https://github.com/googleads/googleads-mobile-flutter/issues/69).
* Adds a section on Ad Manager to the README.
* Updates iOS setup in the README to include SKAdNetwork.

## 0.11.0+2

* Set min Android version to `19`.
* Fixes bug that displayed "This AdWidget is already in the Widget tree".
* Update minimum gradle version.
* Add references to the [codelab](https://codelabs.developers.google.com/codelabs/admob-inline-ads-in-flutter#0) in the README.

## 0.11.0+1

* Improve AdRequest documentation and fix README heading.

## 0.11.0
Open beta release of the Google Mobile Ads Flutter plugin.
Please see the [README](https://github.com/googleads/googleads-mobile-flutter/blob/master/README.md) for updated integration steps.

* Package and file names have been renamed from `firebase_admob` to `google_mobile_ads`.

* Removes support for legacy plugin APIs.

* Removes Firebase dependencies.

* Adds support for `RequestConfiguration` targeting APIs.

* Adds support for Ad Manager key values, via the new `Publisher` ad containers.
See `PublisherBannerAd` and similar classes.

* Shows warning if an `Ad` object is reused without being disposed.

* Removes support for V1 embedding.

* Add version to request agent.

## 0.10.0

* Old Plugin API has been moved to `lib/firebase_admob_legacy.dart`. To keep using the old API change
`import 'package:firebase_admob/firebase_admob.dart';` to
`import 'package:firebase_admob/firebase_admob_legacy.dart';`.

* Updated `RewardedAd` to the latest API. Instantiating and displaying a `RewardedAd` is now similar
to`InterstitialAd`. See README for more info. A simple example is shown below.
```dart
final RewardedAd myRewardedAd = RewardedAd(
  adUnitId: RewardedAd.testAdUnitId,
  request: AdRequest(),
  listener: AdListener(
    onAdLoaded: (Ad ad) => (ad as RewardedAd).show(),
  ),
);
myRewardedAd.load();
```

* Replacement of `MobileAdEvent` callbacks with improved `AdListener`.
```dart
BannerAd(
 listener: (MobileAdEvent event) {
   print("BannerAd event $event");
 },
);
```

can be replaced by:

```dart
BannerAd(
  listener: AdListener(
    onAdLoaded: (Ad ad) => print('$BannerAd loaded.'),
    onAdFailedToLoad: (Ad ad) => print('$BannerAd failed to load.'),
  ),
);
```

* `MobileAdTargeting` has been renamed to `AdRequest` to keep consistent with SDK.
* `MobileAd` has been renamed to `Ad`.

* Fix smart banners on iOS.
  - `AdSize.smartBanner` is for Android only.
  - `AdSize.smartBannerPortrait` and `AdSize.smartBannerLandscape` are only for iOS.
  - Use `Adsize.getSmartBanner(Orientation)` to get the correct value depending on platform. The
  orientation can be retrieved using a `BuildContext`:
```dart
Orientation currentOrientation = MediaQuery.of(context).orientation;
```

* Removal of `show()` for `BannerAd` and `NativeAd` since they can now be displayed within a widget
tree.
* Showing of `InterstitialAd` and `RewardedAd` should now wait for `AdListener.onAdLoaded` callback
before calling `show()` as best practice:

```dart
InterstitialAd(
  adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event $event");
  },
)
  ..load()
  ..show();
```

can be replaced by:

```dart
final InterstatialAd interstitial = InterstatialAd(
  adUnitId: InterstatialAd.testAdUnitId,
  request: AdRequest(),
  listener: AdListener(
    onAdLoaded: (Ad ad) => (ad as InterstatialAd).show(),
  ),
)..load();
```

* `Ad.load()` no longer returns a boolean that only confirms the method was called successfully.

## 0.9.3+4

* Bump Dart version requirement.

## 0.9.3+3

* Provide a default `MobileAdTargetingInfo` for `RewardedVideoAd.load()`. `RewardedVideoAd.load()`
would inadvertently cause a crash if `MobileAdTargetingInfo` was excluded.

## 0.9.3+2

* Fixed bug related to simultaneous ad loading behavior on iOS.

## 0.9.3+1

* Modified README to reflect supporting Native Ads.

## 0.9.3

* Support Native Ads on iOS.

## 0.9.2+1

* Added note about required Google Service config files.

## 0.9.2

* Add basic Native Ads support for Android.

## 0.9.1+3

* Replace deprecated `getFlutterEngine` call on Android.

## 0.9.1+2

* Make the pedantic dev_dependency explicit.

## 0.9.1+1

* Enable custom parameters for rewarded video server-side verification callbacks.

## 0.9.1

* Support v2 embedding. This will remain compatible with the original embedding and won't require
  app migration.

## 0.9.0+10

* Remove the deprecated `author:` field from pubspec.yaml
* Migrate the plugin to the pubspec platforms manifest.
* Bump the minimum Flutter version to 1.10.0.

## 0.9.0+9

* Updated README instructions for contributing for consistency with other Flutterfire plugins.

## 0.9.0+8

* Remove AndroidX warning.

## 0.9.0+7

* Update Android gradle plugin, gradle, and Admob versions.
* Improvements to the Android implementation, fixing warnings about a possible null pointer exception.
* Fixed an issue where an advertisement could incorrectly remain displayed when transitioning to another screen.

## 0.9.0+6

* Remove duplicate example from documentation.

## 0.9.0+5

* Update documentation to reflect new repository location.

## 0.9.0+4

* Add the ability to horizontally adjust the ads banner location by specifying a pixel offset from the centre.

## 0.9.0+3

* Update google-services Android gradle plugin to 4.3.0 in documentation and examples.

## 0.9.0+2

* On Android, no longer crashes when registering the plugin if no activity is available.

## 0.9.0+1

* Add missing template type parameter to `invokeMethod` calls.
* Bump minimum Flutter version to 1.5.0.

## 0.9.0

* Update Android dependencies to latest.

## 0.8.0+4

* Update documentation to add AdMob App ID in Info.plist
* Add iOS AdMob App ID in Info.plist in example project

## 0.8.0+3

* Log messages about automatic configuration of the default app are now less confusing.

## 0.8.0+2

* Remove categories.

## 0.8.0+1

* Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.8.0

* **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.7.0

* Mark Dart code as deprecated where the newer version AdMob deprecates features (Birthday, Gender, and Family targeting).
* Update gradle dependencies.
* Add documentation for new AndroidManifest requirements.

## 0.6.1+1

* Bump Android dependencies to latest.
* __THIS WAS AN UNINTENTIONAL BREAKING CHANGE__. Users should consume 0.6.1 instead if they need the old API, or 0.7.0 for the bumped version.
* Guide how to fix crash with admob version 17.0.0 in README

## 0.6.1

* listener on MobileAd shouldn't be final.
* Ad listeners can to be set in or out of Ad initialization.

## 0.6.0

* Add nonPersonalizedAds option to MobileAdTargetingInfo

## 0.5.7

* Bumped mockito dependency to pick up Dart 2 support.

## 0.5.6

* Bump Android and Firebase dependency versions.

## 0.5.5

* Updated Gradle tooling to match Android Studio 3.1.2.

## 0.5.4+1

* Graduate to beta.

## 0.5.4

* Fixed a bug that was causing rewarded video failure event to be called on the wrong listener.

## 0.5.3

* Updated Google Play Services dependencies to version 15.0.0.
* Added handling of rewarded video completion event.

## 0.5.2

* Simplified podspec for Cocoapods 1.5.0, avoiding link issues in app archives.

## 0.5.1

* Fixed Dart 2 type errors.

## 0.5.0

* **Breaking change**. The BannerAd constructor now requires an AdSize
  parameter. BannerAds can be created with AdSize.smartBanner, or one of
  the other predefined AdSize values. Previously BannerAds were always
  defined with the smartBanner size.

## 0.4.0

* **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.3.2

* Fixed Dart 2 type errors.

## 0.3.1

* Enabled use in Swift projects.

## 0.3.0

* Added support for rewarded video ads.
* **Breaking change**. The properties and parameters named "unitId" in BannerAd
  and InterstitialAd have been renamed to "adUnitId" to better match AdMob's
  documentation and UI.

## 0.2.3

* Simplified and upgraded Android project template to Android SDK 27.
* Updated package description.

## 0.2.2

* Added platform-specific App IDs and ad unit IDs to example.
* Separated load and show functionality for interstitials in example.

## 0.2.1

* Use safe area layout to place ad in iOS 11

## 0.2.0

* **Breaking change**. MobileAd TargetingInfo requestAgent is now hardcoded to 'flutter-alpha'.

## 0.1.0

* **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).
* Relaxed GMS dependency to [11.4.0,12.0[

## 0.0.3

* Add FLT prefix to iOS types
* Change GMS dependency to 11.4.+

## 0.0.2

* Change GMS dependency to 11.+

## 0.0.1

* Initial Release: not ready for production use
