# Google Mobile Ads SDK Flutter Plugin

A plugin for [Flutter](https://flutter.dev) that supports loading and
displaying banner, interstitial (full-screen), native, and rewarded video ads using the
[Google Mobile Ads SDK](https://developers.google.com/ad-manager/mobile-ads-sdk).

## Platform Specific Setup

This plugin supports Android and iOS and requires additional setup on both platforms before it can
be used in your app. The sections below explain the setup for each platform.

### Android

#### Update your AndroidManifest.xml

Your App ID must be included in the `AndroidManifest.xml`. Failure
to do so will result in a crash on launch of your app.

Add your AdMob App ID to your app's `android/app/src/main/AndroidManifest.xml` file by adding a
`<meta-data>` tag with name `com.google.android.gms.ads.APPLICATION_ID`, as shown below. You can
find your App ID in the AdMob UI. For `android:value` insert your own AdMob App ID in quotes,
as shown below.

```xml
<manifest>
    <application>
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

You must pass the same value when you initialize the plugin in your Dart code.

See https://goo.gl/fQ2neu for more information about configuring `AndroidManifest.xml`
and setting up your App ID.

### iOS

### Update your Info.plist

In your app's `ios/Runner/Info.plist` file, add a `GADApplicationIdentifier` key with a string value
of your AdMob app ID as shown below:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-################~##########</string>
```

You must pass the same value when you initialize the plugin in your Dart code.

See https://developers.google.com/admob/ios/quick-start#update_your_infoplist for more information
about configuring `Info.plist` and setting up your App ID.

## Initialize the Mobile Ads SDK
Before loading ads, have your app initialize the Mobile Ads SDK by calling
`MobileAds.instance.initialize()` which initializes the SDK and returns a `Future` that finishes
once initialization is complete (or after a 30-second timeout). This needs to be done only once,
ideally at app launch.

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      // Load ads.
   });
  }
}
```

## Creating and Loading an Ad with AdMob

Instantiating each ad is slightly different and each supported format is explained in this section.
To see how to display an Ad after loading one, see section **Displaying an Ad**.

### Banner

Instantiating a `BannerAd` requires at least an `adUnitId`, an `AdSize`, an `AdRequest`, and an
`AdListener` as seen below. When testing, you should always use `BannerAd.testAdUnitId` and switch
to an ad unit id from your AdMob account when releasing.

```dart
final BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(),
);
```

After a `BannerAd` is instantiated, you must call `load()` before it can be shown on the screen.

```dart
myBanner.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Interstitial

Instantiating an `InterstitialAd` requires at least an `adUnitId`, `AdRequest`, and `AdListener` as
shown below. When testing, you should always use `InterstitialAd.testAdUnitId` and switch to an ad
unit id from your AdMob account when releasing.

```dart
final InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
  request: AdRequest(),
  listener: AdListener(),
);
```

After a `InterstitialAd` is instantiated, you must call `load()` before it can be shown on the
screen.

```dart
myInterstitial.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Native

Native Ads are presented to users via UI components that
are native to the platform. (e.g. A
[View](https://developer.android.com/reference/android/view/View) on Android or a
[UIView](https://developer.apple.com/documentation/uikit/uiview?language=objc)
on iOS).

Since Native Ads require UI components native to a platform, this feature requires additional setup
for Android and iOS:

#### Android
The Android Admob Plugin requires a class that implements `NativeAdFactory` which contains a method
that takes a
[UnifiedNativeAd](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAd)
and custom options and returns a
[UnifiedNativeAdView](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAdView).

You can implement this in your `MainActivity.java` or create a separate class in the same directory
as `MainActivity.java` as seen below:

```java
package my.app.path;

import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

class NativeAdFactoryExample implements NativeAdFactory {
  @Override
  public UnifiedNativeAdView createNativeAd(
      UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
    // Create UnifiedNativeAdView
  }
}
```

You need to register your `NativeAdFactory` with a unique `String`
identifier after adding the `GoogleMobileAdsPlugin` to the `FlutterEngine`. (Adding the
`GoogleMobileAdsPlugin` to `FlutterEngine` should be done in a `GeneratedPluginRegistrant` in the near
future, so you may not see it being added here). You should also unregister the factory in
`cleanUpFlutterEngine(engine)`.

You're `MainActivity.java` should look similar to:

```java
package my.app.path;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());

    GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", NativeAdFactoryExample());
  }

  @Override
  public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
  }
}
```

When creating the `NativeAd` in Flutter, the `factoryId` parameter should match the one you used to
add the factory to `GoogleMobileAdsPlugin`.

An example of displaying a `UnifiedNativeAd` with a `UnifiedNativeAdView` can be found
[here](https://developers.google.com/admob/android/native/advanced). The example app also inflates
a custom layout and displays the test Native ad.

#### iOS
Native Ads for iOS require a class that implements the protocol `FLTNativeAdFactory` which has a
single method `createNativeAd:customOptions:`.

You can have your `AppDelegate` implement this protocol or create a separate class as seen below:

```objectivec
/* AppDelegate.m */

#import "FLTGoogleMobileAdsPlugin.h"

@interface NativeAdFactoryExample : NSObject<FLTNativeAdFactory>
@end

@implementation NativeAdFactoryExample
- (GADUnifiedNativeAdView *)createNativeAd:(GADUnifiedNativeAd *)nativeAd
                             customOptions:(NSDictionary *)customOptions {
  // Create GADUnifiedNativeAdView
}
@end
```

Once there is an implementation of `FLTNativeAdFactory`, it must be added to the
`FLTGoogleMobileAdsPlugin`. This is done by importing `FLTGoogleMobileAdsPlugin.h` and calling
`registerNativeAdFactory:factoryId:nativeAdFactory:` with a `FlutterPluginRegistry`, a unique
identifier for the factory, and the factory itself. The factory also *MUST* be added after
`[GeneratedPluginRegistrant registerWithRegistry:self];` has been called.

If this is done in `AppDelegate.m`, it should look similar to:

```objectivec
#import "FLTGoogleMobileAdsPlugin.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  NativeAdFactoryExample *nativeAdFactory = [[NativeAdFactoryExample alloc] init];
  [FLTGoogleMobileAdsPlugin registerNativeAdFactory:self
                                        factoryId:@"adFactoryExample"
                                  nativeAdFactory:nativeAdFactory];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

#### Dart Example

When creating a `NativeAd` in Dart, setup is similar to `BannerAd` or `InterstitialAd` with an additional
requirement of a `factoryId` that matches the id used to register the `NativeAdFactory` in
Java/Kotlin/Obj-C/Swift. An example of this implementation is seen below. Also, remember that
testing should always be done with the `NativeAd.testAdUnitId`.

```dart

final NativeAd nativeAd = NativeAd(
  adUnitId: NativeAd.testAdUnitId,
  factoryId: 'adFactoryExample',
  request: AdRequest(),
  listener: AdListener(),
);
```

Once created you can call `load()`.

```dart
nativeAd.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Rewarded Ads

Instantiating a `Rewarded` requires at least an `adUnitId`, an `AdRequest`, and an `AdListener`
as seen below. When testing, you should always use `RewardedAd.testAdUnitId` and switch
to an ad unit id from your AdMob account when releasing.

```dart
final RewardedAd myRewardedAd = RewardedAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: RewardedAd.testAdUnitId,
  request: AdRequest(),
  listener: AdListener(),
);
```

After a `RewardedAd` is instantiated, you must call `load()` before it can be shown on the screen.

```dart
myRewardedAd.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Test Ads

It's important to enable test ads during development so that you can click on them without charging
Google advertisers. If you click on too many ads without being in test mode, you risk your account
being flagged for invalid activity.

The quickest way to enable testing is to use Google-provided test ad units. These ad units are not
associated with your AdMob account, so there's no risk of your account generating invalid
traffic when using these ad units.

**Android**: https://developers.google.com/admob/android/test-ads
**iOS**: https://developers.google.com/admob/ios/test-ads

## Creating and Loading an Ad with Ad Manager

This plugin also contains support for ads using [Google Ad Manager](https://admanager.google.com/home/).
Below are all supported Ad Manager ad types.

### PublisherBanner

Instantiating a `PublisherBannerAd` requires at least an `adUnitId`, one `AdSize`, a
`PublisherAdRequest`, and an `AdListener` as seen below. When testing, you should always use
[test ads](https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads) and switch
to an ad unit id from your Ad Manager account when releasing.

```dart
final PublisherBannerAd myBanner = PublisherBannerAd(
  // Replace the adUnitId with an ad unit id from the Ad Manager dashboard.
  // https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads
  // https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads
  adUnitId: '/6499/example/banner',
  sizes: <AdSize>[AdSize.banner],
  request: PublisherAdRequest(),
  listener: AdListener(),
);
```

After a `PublisherBannerAd` is instantiated, you must call `load()` before it can be shown on the
screen.

```dart
myBanner.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### PublisherInterstitial

Instantiating a `PublisherInterstitialAd` requires at least an `adUnitId`, `PublisherAdRequest`, and
`AdListener`, as shown below. When testing, you should always use test ids and switch to an ad unit
id from your Ad Manager account when releasing.

```dart
final PublisherInterstitialAd myInterstitial = PublisherInterstitialAd(
  // Replace the adUnitId with an ad unit id from the Ad Manager dashboard or test ids from the
  // links below:
  // https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads
  // https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads
  adUnitId: '/6499/example/interstitial',
  request: PublisherAdRequest(),
  listener: AdListener(),
);
```

After a `PublisherInterstitialAd` is instantiated, you must call `load()` before it can be shown on
the screen.

```dart
myInterstitial.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Native Ads with Ad Manager

Creating a `NativeAd` with Ad Manager requires additional setup on Android and iOS. See section
**Native** under **Creating and Loading an Ad With AdMob** for steps creating a `NativeAdFactory` on
Android and iOS.

After a `NativeAdFactory` is implemented, instantiating a `NativeAd` from Dart is similar to
`BannerAd` or `InterstitialAd` with an additional requirement of a `factoryId` that matches the id
used to register the `NativeAdFactory` in Java/Kotlin/Obj-C/Swift. An example of this implementation
is seen below. Also, remember that testing should always be done with the test ids.

```dart
final NativeAd nativeAd = NativeAd.fromPublisherRequest(
  // Replace the adUnitId with an ad unit id from the Ad Manager dashboard or test ids from the
  // links below:
  // https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads
  // https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads
  adUnitId: '/6499/example/native',
  factoryId: 'adFactoryExample',
  publisherRequest: PublisherAdRequest(),
  listener: AdListener(),
);
```

Once created you can call `load()`.

```dart
nativeAd.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Rewarded Ads for Ad Manager

Instantiating a `RewardedAd` requires at least an `adUnitId`, an `AdRequest`/`PublisherAdRequest`, and
an `AdListener` as seen below. When testing, you should always use test ids and switch to an ad unit
id from your Ad Manager account when releasing.

```dart
final RewardedAd myRewardedAd = RewardedAd.fromPublisherRequest(
  // Replace the adUnitId with an ad unit id from the Ad Manager dashboard or test ids from the
  // links below:
  // https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads
  // https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads
  adUnitId: '/6499/example/rewarded-video',
  publisherRequest: PublisherAdRequest(),
  listener: AdListener(),
);
```

After a `RewardedAd` is instantiated, you must call `load()` before it can be shown on the screen.

```dart
myRewardedAd.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**AdRequest Info and Ad Event Listeners** to see additional parameters.

### Test Ads

It's important to enable test ads during development so that you can click on them without charging
Google advertisers. If you click on too many ads without being in test mode, you risk your account
being flagged for invalid activity.

The quickest way to enable testing is to use Google-provided test ad units. These ad units are not
associated with your Ad Manager account, so there's no risk of your account generating invalid
traffic when using these ad units.

**Android**: https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads
**iOS**: https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads

## Displaying an Ad

Each ad format can be displayed using at least one of two methods. **Overlay** and **Widget**. This
section explains the difference between them.

### Overlay

An ad that is displayed as an **Overlay** is displayed on top of all app content and is statically
placed. Ad displayed this way can't be added to the Flutter widget tree. Only `InterstitialAd`s and
`NativeAd`s can be displayed this way. You can display an ad by calling `show()` after the `Ad` is
loaded.

```dart
myInterstitial.show();
```

This method should only be called after `load()` and the `AdListener.onAdLoaded` method has been
triggered. Once `show()` is called, an `Ad` displayed this way can't be removed programmatically and
require user input.

Once an `Ad` has called `load()`, it must call `dispose()` when access to it is no longer needed.
The best practice for when to call `dispose()` is either after calling `show()` or in the
`AdListener.onAdFailedToLoad`/`AdListener.onAdClosed` callbacks.

### Widget

If you would like to display an ad as a Flutter `Widget`, you need to take an extra step by
opting-in to the embedded views preview. On Android, this is already done for you.

On iOS, you must do this by adding a boolean property to the app's `ios/Runner/Info.plist`
file with the key `io.flutter.embedded_views_preview` and the value `true`. Your `Info.plist` should
look similar to:

```xml
...
<dict>
...
    <key>io.flutter.embedded_views_preview</key>
    <true/>
</dict>
```

An ad that is displayed as a **Widget** is displayed as a typical Flutter `Widget` and can be added
to the Flutter widget tree. This is only supported by ads that don't cover an entire screen, such as
`BannerAd`, `PublisherBannerAd`, and `NativeAd`. To display one of these ads as a widget, you must
instantiate an `AdWidget` with a supported ad after calling `load()`. You can create the widget
before calling `load()`, but `load()` must be called before adding it to the widget tree.

```dart
final AdWidget adWidget = AdWidget(ad: myBanner);
```

`AdWidget` inherits from Flutter's `Widget` class and can be used as any other widget. On iOS, make
sure you place the widget in a widget with a specified width and height. Otherwise, you may see
your app crash. For a `BannerAd`, you can place the ad in a container with a size that matches the
ad.

```dart
final Container adContainer = Container(
  alignment: Alignment.center,
  child: adWidget,
  width: myBanner.size.width.toDouble(),
  height: myBanner.size.height.toDouble(),
);
```

Once an `Ad` has called `load()`, it must call `dispose()` when access to it is no longer needed.
The best practice for when to call `dispose()` is either after the `AdWidget` is removed from the
widget tree or in the `AdListener.onAdFailedToLoad` callback.

## AdRequest Info and Ad Event Listeners

`BannerAd`s, `InterstitialAd`s, `RewardedAd`s and `NativeAd`s can also be configured with targeting
information and an `AdListener` as shown below.

```dart
final AdRequest request = AdRequest(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  request: request,
  size: AdSize.smartBanner,
  listener: AdListener(
    onAdLoaded: (Ad ad) {
      print("$BannerAd loaded.");
    },
  ),
);
```

`PublisherBannerAd`s can also be configured with custom targeting information
and an `AdListener` as shown below.

```dart
final PublisherAdRequest request = PublisherAdRequest(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.dev',
  customTargeting: <String, String>{'some', 'targeting'},
  customTargetingLists: <String, List<String>>{'favoriteColors': <String>['red', 'yellow']},
);

final PublisherBannerAd myBanner = PublisherBannerAd(
  // Replace the adUnitId with an ad unit id from the Ad Manager dash.
  // https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads
  // https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads
  adUnitId: '/6499/example/banner',
  sizes: <AdSize>[AdSize.banner],
  request: request,
  listener: AdListener(
    onAdLoaded: (Ad ad) {
      print("$PublisherBannerAd loaded.");
    },
  ),
);
```

## Targeting
The `RequestConfiguration` object collects the global configuration for every ad
request and is applied by `MobileAds.instance.updateRequestConfiguration()`.

### Child-directed setting
For purposes of the [Children's Online Privacy Protection Act (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy), there is
a setting called "tag for child-directed treatment."

As an app developer, you can indicate whether you want Google to treat your
content as child-directed when you make an ad request. If you indicate that you
want Google to treat your content as child-directed, we take steps to disable
IBA and remarketing ads on that ad request. The setting can be used with all
versions of the Google Play services SDK via
`RequestConfiguration.tagForChildDirectedTreatment()`:

- Use the argument `TagForChildDirectedTreatment.yes` to indicate that you want your content treated as child-directed for the purposes of COPPA.
- Use the argument `TagForChildDirectedTreatment.no` to indicate that you don't want your content treated as child-directed for the purposes of COPPA.
- Use the argument `TagForChildDirectedTreatment.unspecified` or do not set this tag if you do not wish to indicate how you would like your content
treated with respect to COPPA in ad requests.

The following example indicates that you want your content treated as child-directed for purposes of COPPA:

```dart
RequestConfiguration requestConfiguration = RequestConfiguration(
  tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes);
MobileAds.instance.updateRequestConfiguration(requestConfiguration);
```

### Users under the age of consent
You can mark your ad requests to receive treatment for users in the European Economic Area (EEA) under the age of consent.
 This feature is designed to help facilitate compliance with the [General Data Protection Regulation (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679).
 Note that you may have other legal obligations under GDPR. Please review the European Union’s guidance and
 consult with your own legal counsel. Please remember that Google's tools are designed to facilitate compliance and do not
 relieve any particular publisher of its obligations under the law. [Learn more about how the GDPR affects publishers](https://support.google.com/admob/answer/7666366).

When using this feature, a Tag For Users under the Age of Consent in Europe (TFUA) parameter will be included in the ad request.
This parameter disables personalized advertising, including remarketing, for that specific ad request. It also disables requests to third-party ad vendors,
 such as ad measurement pixels and third-party ad servers.

The setting can be used via `RequestConfiguration.tagForUnderAgeOfConsent()`:
- Use the argument `TagForUnderAgeOfConsent.yes` to indicate that you want the request configuration to be handled in a manner suitable for users under the age of consent.
- Use the argument `TagForUnderAgeOfConsent.no` to indicates that you don't want the request configuration to be handled in a manner suitable for users under the age of consent.
- Use the argument `TagForUnderAgeOfConsent.unspecified` or do not set this tag to indicate that you have not specified whether the ad request should receive treatment for users in the European Economic Area (EEA) under the age of consent.
The following example indicates that you want TFUA included in your ad request:
```dart
RequestConfiguration requestConfiguration = RequestConfiguration(
  tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes
);
MobileAds.instance.updateRequestConfiguration(requestConfiguration);
```

The tags to enable the Child-directed setting and setTagForUnderAgeOfConsent should not both simultaneously be set to true. If they are, the child-directed setting takes precedence.
### Ad Content Filtering
The setting can be set via `RequestConfiguration.maxAdContentRating()`:

AdMob ads returned for these requests have a content rating at or below that level. The possible values for this network extra are based on [digital content label classifications](https://support.google.com/admob/answer/7562142),
and should be one of the following `MaxAdContentRating` objects:

- `MaxAdContentRating.g`
- `MaxAdContentRating.pg`
- `MaxAdContentRating.t`
- `MaxAdContentRating.ma`

## Issues and feedback

Please file FlutterFire specific issues, bugs, or feature requests in our [issue tracker](https://github.com/flutter/flutterfire_temporary/issues/new).

Plugin issues that are not specific to Google Mobile Ads can be filed in the [Flutter issue tracker](https://github.com/flutter/flutter/issues/new).

To contribute a change to this plugin,
please review our [contribution guide](https://github.com/flutter/flutterfire_temporary/blob/master/CONTRIBUTING.md)
and open a [pull request](https://github.com/flutter/flutterfire_temporary/pulls).
