# Google Mobile Ads for Flutter

[![google_mobile_ads](https://github.com/googleads/googleads-mobile-flutter/actions/workflows/google_mobile_ads.yaml/badge.svg)](https://github.com/googleads/googleads-mobile-flutter/actions/workflows/google_mobile_ads.yaml)

This guide is intended for publishers who want to monetize a [Flutter](https://flutter.dev/) app.

Integrating Google Mobile Ads SDK into a Flutter app, which you will do here, is the first step towards displaying AdMob ads and earning revenue. Once the integration is complete, you can choose an ad format to get detailed implementation steps.

The Google Mobile Ads SDK for Flutter currently supports loading and displaying banner, interstitial (full-screen), native ads, and rewarded video ads.

Note: This plugin also contains support for **[Google Ad Manager](https://admanager.google.com/home/)**. If you are interested in creating and loading an Ad with Ad Manager, you may follow the same prerequisites, platform setup, mobile ads SDK initialization steps outlined in this doc, and then see [creating and loading an ad with Ad Manager](https://github.com/googleads/googleads-mobile-flutter#creating-and-loading-an-ad-with-ad-manager) for further instructions.

See also the [codelab for inline ads in Flutter](https://codelabs.developers.google.com/codelabs/admob-inline-ads-in-flutter#0) for a detailed guide on setting
inline banner and native ads.

## Prerequisites

*   Flutter 1.22.0 or higher
*   Android
    *   Android Studio 3.2 or higher
    *   Target Android API level 19 or higher
    *   Set `compileSdkVersion` to 28 or higher
    *   Android Gradle Plugin 4.1 or higher (this is the version supported by Flutter out of the box)
*   Ios
    *   Latest version of Xcode with [enabled command-line tools](https://flutter.dev/docs/get-started/install/macos#install-xcode).
*   Recommended: [Create an AdMob account](https://support.google.com/admob/answer/2784575) and [register an Android and/or iOS app](https://support.google.com/admob/answer/2773509)


## Import the Mobile Ads SDK

*   Include [Google Mobile Ads SDK for Flutter](https://pub.dev/packages/google_mobile_ads/install ) in your Flutter project.

## Platform Specific Setup


### iOS


#### Update your Info.plist

Update your app's `ios/Runner/Info.plist` file to add two keys:

* A `GADApplicationIdentifier` key with a string value of your AdMob app ID ([identified in the AdMob UI](https://support.google.com/admob/answer/7356431)).
* A `SKAdNetworkItems` key with Google's `SKAdNetworkIdentifier` value of `cstr6suwn9.skadnetwork`.

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cstr6suwn9.skadnetwork</string>
    </dict>
  </array>
```

See https://developers.google.com/admob/ios/quick-start#update\_your\_infoplist for more information about configuring `Info.plist` and setting up your App ID.


### Android


#### Update AndroidManifest.xml

The AdMob App ID must be included in the `AndroidManifest.xml`. Failure to do so will result in a crash on launch of an app.

Add the AdMob App ID ([identified in the AdMob UI](https://support.google.com/admob/answer/7356431)) to the app's `android/app/src/main/AndroidManifest.xml` file by adding a `<meta-data>` tag with name `com.google.android.gms.ads.APPLICATION_ID`, as shown below. You can find your App ID in the AdMob UI. For `android:value` insert your own AdMob App ID in quotes, as shown below.


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


The same value when you initialize the plugin in your Dart code.

See https://goo.gl/fQ2neu for more information about configuring `AndroidManifest.xml` and setting up the App ID.


## Initialize the Mobile Ads SDK

Before loading ads, have your app initialize the Mobile Ads SDK by calling `MobileAds.instance.initialize()` which initializes the SDK and returns a `Future` that finishes once initialization is complete (or after a 30-second timeout). This needs to be done only once, ideally right before running the app.


```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load ads.
  }
}
```



## Select an Ad Format

The Mobile Ads SDK is now imported and you're ready to implement an ad. AdMob offers a number of different ad formats, so you can choose the one that best fits your app's user experience.



*   Banner
    *   Rectangular ads that appear at the top or bottom of the device screen. Banner ads stay on screen while users are interacting with the app, and can refresh automatically after a certain period of time. If you're new to mobile advertising, they're a great place to start.
*   Interstitial
    *   Full-screen ads that cover the interface of an app until closed by the user. They're best used at natural pauses in the flow of an app's execution, such as between levels of a game or just after a task is completed.
*   Native Ads
    *   Customizable ads that match the look and feel of your app. You decide how and where they're placed, so the layout is more consistent with your app's design.
*   Rewarded
    *   Ads that reward users for watching short videos and interacting with playable ads and surveys. Good for monetizing free-to-play users.

## Banner Ads

Banner ads occupy a spot within an app's layout, either at the top or bottom of the device screen. They stay on screen while users are interacting with the app, and can refresh automatically after a certain period of time.

This guide shows you how to integrate banner ads from AdMob into a Flutter app. In addition to code snippets and instructions, it also includes information about sizing banners properly and links to additional resources.

See also the [codelab for inline ads in Flutter](https://codelabs.developers.google.com/codelabs/admob-inline-ads-in-flutter#6) for a detailed guide on setting up banner ads.


### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for banners:

*   Android: https://developers.google.com/admob/android/test-ads#sample\_ad\_units
*   iOS: https://developers.google.com/admob/ios/test-ads#demo\_ad\_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate a Banner Ad

A `BannerAd` requires an `adUnitId`, an `AdSize`, an `AdRequest`, and an `AdListener`. An example is shown below as well as more information on each parameter following.


```dart
final BannerAd myBanner = BannerAd(
  adUnitId: '<ad unit id>',
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(),
);
```

#### Banner Sizes

The table below lists the standard banner sizes.

<table>
  <tr>
   <td><strong>Size in dp (WxH)</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>AdSize Constant</strong>
   </td>
  </tr>
  <tr>
   <td>320x50
   </td>
   <td>Standard Banner
   </td>
   <td><code>banner</code>
   </td>
  </tr>
  <tr>
   <td>320x100
   </td>
   <td>Large Banner
   </td>
   <td><code>largeBanner</code>
   </td>
  </tr>
  <tr>
   <td>320x250
   </td>
   <td>Medium Rectangle
   </td>
   <td><code>mediumRectangle</code>
   </td>
  </tr>
  <tr>
   <td>468x60
   </td>
   <td>Full-Size Banner
   </td>
   <td><code>fullBanner</code>
   </td>
  </tr>
  <tr>
   <td>728x90
   </td>
   <td>Leaderboard
   </td>
   <td><code>leaderboard</code>
   </td>
  </tr>
  <tr>
   <td>Screen width x 32|50|90
   </td>
   <td><a href="https://developers.google.com/admob/android/banner/smart">Smart Banner</a>
   </td>
   <td>Use <code>getSmartBanner(Orientation)</code>
   </td>
  </tr>
  <tr>
   <td>Provided width x Adaptive height</td>
   <td><a href="https://developers.google.com/admob/android/banner/adaptive">Adaptive Banner</a></td>
   <td>Use <code>getAnchoredAdaptiveBannerAdSize(Orientation, int)</code></td>
  </tr>
</table>


To define a custom banner size, set your desired `AdSize`, as shown here:


```dart
final AdSize adSize = AdSize(300, 50);
```


#### Banner Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:


```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) => print('Ad closed.'),
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
);
```

### Load Banner Ad

After a `BannerAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myBanner.load();
```

### Display a Banner Ad

To display a `BannerAd` as a widget, you must instantiate an `AdWidget` with a supported ad after calling `load()`. You can create the widget before calling `load()`, but `load()` must be called before adding it to the widget tree.


```dart
final AdWidget adWidget = AdWidget(ad: myBanner);
```


`AdWidget` inherits from Flutter's Widget class and can be used as any other widget. On iOS, make sure you place the widget in a widget with a specified width and height. Otherwise, your Ad may not be displayed. A `BannerAd` can be placed in a container with a size that matches the ad:


```dart
final Container adContainer = Container(
  alignment: Alignment.center,
  child: adWidget,
  width: myBanner.size.width.toDouble(),
  height: myBanner.size.height.toDouble(),
);
```

Once an Ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is either after the `AdWidget` is removed from the widget tree or in the `AdListener.onAdFailedToLoad` callback.

That's it! Your app is now ready to display banner ads.


## Interstitial Ad

Interstitial ads are full-screen ads that cover the interface of their host app. They're typically displayed at natural transition points in the flow of an app, such as between activities or during the pause between levels in a game. When an app shows an interstitial ad, the user has the choice to either tap on the ad and continue to its destination or close it and return to the app.

This guide explains how to integrate interstitial ads into a Flutter app.


### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for interstitials:


*   Android: https://developers.google.com/admob/android/test-ads#sample\_ad\_units
*   iOS: https://developers.google.com/admob/ios/test-ads#demo\_ad\_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate an Interstitial Ad

An `InterstitialAd` requires an `adUnitId`, an `AdRequest`, and an `AdListener`. An example is shown below as well as more information on each parameter following.


```dart
final InterstitialAd myInterstitial = InterstitialAd(
  adUnitId: '<ad unit id>',
  request: AdRequest(),
  listener: AdListener(),
);
```

#### Interstitial Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:


```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) {
   ad.dispose();
   print('Ad closed.');
 },
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
);
```

### Load Interstitial Ad

After an `InterstitialAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myInterstitial.load();
```

### Display an Interstitial Ad

An `InterstitialAd` is displayed as an Overlay on top of all app content and is statically placed. Which means it can not be added to the Flutter widget tree. You can choose when to show the add by calling `show()` after the ad is loaded.

```dart
myInterstitial.show();
```

This method should only be called after `load()` and the `AdListener.onAdLoaded` method has been triggered. Once `show()` is called, an `Ad` displayed this way can't be removed programmatically and requires user input. Do not call `show()` more than once for a loaded `InterstitialAd`. Instead you should load a new ad.

Once an ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is  in the `AdListener.onAdFailedToLoad/AdListener.onAdClosed` callbacks.

That's it! Your app is now ready to display interstitial ads.


### Next steps



*   See [Interstitial best practices](https://www.youtube.com/watch?v=r2RgFD3Apyo&index=5&list=PLOU2XLYxmsIKX0pUJV3uqp6N3NeHwHh0c) and [interstitial ad guidance](https://support.google.com/admob/answer/6066980).
*   Check out an [Interstitial ads case study](https://admob.google.com/home/resources/freaking-math-powers-revenue-increase-with-google-admob-support/).
*   If you haven't already, create your own interstitial ad unit in the [AdMob UI](https://apps.admob.com/).

## Native Ads


Native ads are ad assets that are presented to users via UI components that are native to the platform. They're shown using the same types of views with which you're already building your layouts, and can be formatted to match the visual design of the user experience in which they live. In coding terms, this means that when a native ad loads, your app receives a NativeAd object that contains its assets, and the app (rather than the Google Mobile Ads SDK) is then responsible for displaying them.

Broadly speaking, there are two parts to successfully implementing Native Ads: loading an ad via the SDK and displaying the ad content in your app. This guide is concerned with using the SDK to load native ads.

See also the [codelab for inline ads in Flutter](https://codelabs.developers.google.com/codelabs/admob-inline-ads-in-flutter#7) for a detailed guide on setting up native ads.


### Platform Setup

Native Ads are presented to users via UI components that are native to the platform. (e.g. A [View](https://developer.android.com/reference/android/view/View) on Android or a [UIView](https://developer.apple.com/documentation/uikit/uiview?language=objc) on iOS).

Since Native Ads require UI components native to a platform, this feature requires additional setup for Android and iOS:


#### Android

The Android implementation of the Google Mobile Ads plugin requires a class that implements a NativeAdFactory. A `NativeAdFactory` contains a method that takes a [UnifiedNativeAd](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAd) and custom options and returns a [UnifiedNativeAdView](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAdView). The [UnifiedNativeAdView](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAdView) is what will be displayed in your app.

You can implement this in your MainActivity.java or create a separate class in the same directory as MainActivity.java as seen below:


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


Each `NativeAdFactory` needs to be registered with a `factoryId`, a unique `String` identifier, in `MainActivity.configureFlutterEngine(FlutterEngine)`. A `NativeAdFactory` can be implemented and registered for each unique Native ad layout used by your app or a single one can handle all layouts. The `NativeAdFactory` should also be unregistered in `cleanUpFlutterEngine(engine)` when building with [add-to-app](https://flutter.dev/docs/development/add-to-app#add-to-app).

`MainActivity.java` should look similar to:


```java
package my.app.path;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());
   super.configureFlutterEngine(flutterEngine);

    GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", NativeAdFactoryExample());
  }

  @Override
  public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
  }
}
```


When creating the `NativeAd` in Dart, the `factoryId` will need to match the one used to add the factory to `GoogleMobileAdsPlugin`. In the above code snippet, `adFactoryExample` is the name of the `factoryId.` An example `NativeAdFactory` follows:


```java
package io.flutter.plugins.googlemobileadsexample;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.widget.TextView;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

// my_native_ad.xml can be found at
/* https://github.com/googleads/googleads-mobile-flutter/tree/master/packages/google_mobile_ads/example/android/app/src/main/res/layout
*/
class NativeAdFactoryExample implements NativeAdFactory {
 private final LayoutInflater layoutInflater;

 NativeAdFactoryExample(LayoutInflater layoutInflater) {
   this.layoutInflater = layoutInflater;
 }

 @Override
 public UnifiedNativeAdView createNativeAd(
     UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
   final UnifiedNativeAdView adView =
       (UnifiedNativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
   final TextView headlineView = adView.findViewById(R.id.ad_headline);
   final TextView bodyView = adView.findViewById(R.id.ad_body);

   headlineView.setText(nativeAd.getHeadline());
   bodyView.setText(nativeAd.getBody());

   adView.setBackgroundColor(Color.YELLOW);

   adView.setNativeAd(nativeAd);
   adView.setBodyView(bodyView);
   adView.setHeadlineView(headlineView);
   return adView;
 }
}
```

#### iOS

The iOS implementation of the Google Mobile Ads plugin requires a class that implements a `FLTNativeAdFactory`. A `FLTNativeAdFactory` contains a method that takes a `GADUnifiedNativeAd` and custom options and returns a `GADUnifiedNativeAdView`. The `GADUnifiedNativeAdView` is what will be displayed in your app.

The `FLTNativeAdFactory` protocol can be implemented by `AppDelegate` or a separate class could be created as seen below:


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

Each `FLTNativeAdFactory` needs to be registered with a `factoryId`, a unique `String` identifier, in `registerNativeAdFactory:factoryId:nativeAdFactory:`. A `FLTNativeAdFactory` can be implemented and registered for each unique Native ad layout used by your app or a single one can handle all layouts. This is done by importing `FLTGoogleMobileAdsPlugin.h` and calling `registerNativeAdFactory:factoryId:nativeAdFactory:` with a `FlutterPluginRegistry`, a unique identifier for the factory, and the factory itself. The factory also MUST be added after `[GeneratedPluginRegistrant registerWithRegistry:self];` has been called.

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


When creating the `NativeAd` in Dart, the `factoryID` will need to match the one used to add the factory to `FLTGoogleMobileAdsPlugin`. In the above code snippet, `adFactoryExample` is the name of the `factoryID`.` An example `FLTNativeAdFactory` follows:


```objectivec
// The example UnifiedNativeAdView.xib can be found at
/* https://github.com/googleads/googleads-mobile-flutter/blob/master/packages/google_mobile_ads/example/ios/Runner/UnifiedNativeAdView.xib
*/
@interface NativeAdFactoryExample : NSObject <FLTNativeAdFactory>
@end

@implementation NativeAdFactoryExample
- (GADUnifiedNativeAdView *)createNativeAd:(GADUnifiedNativeAd *)nativeAd
                            customOptions:(NSDictionary *)customOptions {
 // Create and place ad in view hierarchy.
 GADUnifiedNativeAdView *adView =
     [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil].firstObject;

 // Associate the native ad view with the native ad object. This is
 // required to make the ad clickable.
 adView.nativeAd = nativeAd;

 // Populate the native ad view with the native ad assets.
 // The headline is guaranteed to be present in every native ad.
 ((UILabel *)adView.headlineView).text = nativeAd.headline;

 // These assets are not guaranteed to be present. Check that they are before
 // showing or hiding them.
 ((UILabel *)adView.bodyView).text = nativeAd.body;
 adView.bodyView.hidden = nativeAd.body ? NO : YES;

 [((UIButton *)adView.callToActionView) setTitle:nativeAd.callToAction
                                        forState:UIControlStateNormal];
 adView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

 ((UIImageView *)adView.iconView).image = nativeAd.icon.image;
 adView.iconView.hidden = nativeAd.icon ? NO : YES;

 ((UILabel *)adView.storeView).text = nativeAd.store;
 adView.storeView.hidden = nativeAd.store ? NO : YES;

 ((UILabel *)adView.priceView).text = nativeAd.price;
 adView.priceView.hidden = nativeAd.price ? NO : YES;

 ((UILabel *)adView.advertiserView).text = nativeAd.advertiser;
 adView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;

 // In order for the SDK to process touch events properly, user interaction
 // should be disabled.
 adView.callToActionView.userInteractionEnabled = NO;

 return adView;
}
@end
```

### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for native ads:

*   Android: https://developers.google.com/admob/android/test-ads#sample\_ad\_units
*   iOS: https://developers.google.com/admob/ios/test-ads#demo\_ad\_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate a Native Ad

A `NativeAd` requires an `adUnitId`, a `factoryId`, an `AdRequest`, and an `AdListener`. An example is shown below as well as more information on each parameter following.


```dart
final NativeAd myNative = NativeAd(
  adUnitId: '<test id or account id>',
  factoryId: 'adFactoryExample',
  request: AdRequest(),
  listener: AdListener(),
);
```

#### Factory Id

The `factoryId` will need to match the one used to add the factory to `GoogleMobileAdsPlugin` on Android and/or the `FLTGoogleMobileAdsPlugin` on iOS. The same `factoryId` can be used by both platforms or each can have their own.


#### Native Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:

```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) => print('Ad closed.'),
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
 // Called when a click is recorded for a NativeAd.
 onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
 // Called when an impression is recorded for a NativeAd.
 onNativeAdImpression: (NativeAd ad) => print('Ad impression.'),
);
```

### Load Native Ad

After a `NativeAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myNative.load();
```

### Display a Native Ad

To display a `NativeAd` as a widget, you must instantiate an `AdWidget` with a supported ad after calling `load()`. You can create the widget before calling `load()`, but `load()` must be called before adding it to the widget tree.


```dart
final AdWidget adWidget = AdWidget(ad: myBanner);
```

`AdWidget` inherits from Flutter's `Widget` class and can be used as any other widget. On iOS, make sure you place the widget in a widget with a specified width and height. Otherwise, your Ad may not be displayed.

```dart
final Container adContainer = Container(
  alignment: Alignment.center,
  child: adWidget,
  width: 500,
  height: 500,
);
```

Once an Ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is either after the `AdWidget` is removed from the widget tree or in the `AdListener.onAdFailedToLoad` callback.

That's it! Your app is now ready to display native ads.


### Next steps

*   Learn more about native ads in our [native ad playbook](https://admob.google.com/home/resources/native-ads-playbook/).
*   See [native ads policies and guidelines](https://support.google.com/admob/answer/6329638) for implementing native ads.
*   Check out some customer success stories: [Case study 1](https://admob.google.com/home/resources/alarmmon-achieves-higher-rpm-with-admob-triggered-native-ads/), [Case Study 2](https://admob.google.com/home/resources/linghit-limited-doubles-ad-revenue-with-admob-native-ads/)


## Rewarded Ads

Rewarded ads are ads that users have the option of interacting with [in exchange for in-app rewards](https://support.google.com/admob/answer/7313578). This guide shows you how to integrate rewarded ads from AdMob into a Flutter app.


### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for rewarded:


*   Android: https://developers.google.com/admob/android/test-ads#sample\_ad\_units
*   iOS: https://developers.google.com/admob/ios/test-ads#demo\_ad\_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate a Rewarded Ad

A `RewardedAd` requires an `adUnitId`, an `AdRequest`, and an `AdListener` with the `onRewardedAdUserEarnedReward` callback implemented. An example is shown below as well as more information on each parameter following.


```dart
final RewardedAd myRewarded = RewardedAd(
 adUnitId: '<test id or account id>',
 request: AdRequest(),
 listener: AdListener(
   onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
     print(reward.type);
     print(reward.amount);
   },
 ),
);
```


#### Rewarded Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:


```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) {
   ad.dispose();
   print('Ad closed.');
 },
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
 // Called when a RewardedAd triggers a reward.
 onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
   print('Reward earned: $reward');
 },
);
```

Key Point: Make sure to implement the `onRewardedAdUserEarnedReward` event to
reward the user for watching an ad.

### Load Rewarded Ad

After a `RewardedAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myRewarded.load();
```

### Display a RewardedAd

A `RewardedAd` is displayed as an Overlay is displayed on top of all app content and is statically placed. Which means it can not be displayed this way can't be added to the Flutter widget tree. You can choose when to show the add by calling `show()` after the ad is loaded.


```dart
myRewarded.show();
```

This method should only be called after `load()` and the `AdListener.onAdLoaded` method has been triggered. Once `show()` is called, an `Ad` displayed this way can't be removed programmatically and require user input.  Do not call `show()` more than once for a loaded `RewardedAd`. Instead you should load a new ad.

Once an ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is in the `AdListener.onAdFailedToLoad` and  `AdListener.onAdClosed` and  callbacks.

That's it! Your app is now ready to display rewarded ads.


## Creating and Loading an Ad with Ad Manager

This section shows how to create and load ads with [Google Ad Manager](https://admanager.google.com/home/).

## Select an Ad Format

*   Banner
    *   Rectangular ads that appear at the top or bottom of the device screen. Banner ads stay on screen while users are interacting with the app, and can refresh automatically after a certain period of time. If you're new to mobile advertising, they're a great place to start.
*   Interstitial
    *   Full-screen ads that cover the interface of an app until closed by the user. They're best used at natural pauses in the flow of an app's execution, such as between levels of a game or just after a task is completed.
*   Native Ads
    *   Customizable ads that match the look and feel of your app. You decide how and where they're placed, so the layout is more consistent with your app's design.
*   Rewarded
    *   Ads that reward users for watching short videos and interacting with playable ads and surveys. Good for monetizing free-to-play users.

### PublisherAdRequest

For Ad Manager you will be using `PublisherAdRequest` instead of `AdRequest`.
`PublisherAdRequest` is similar to `AdRequest` but has two additional properties: `customTargeting` and `customTargetingLists`,
which are used to support [custom targeting](https://support.google.com/admanager/answer/188092?hl=en).

```
final PublisherAdRequest request = PublisherAdRequest(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.dev',
  customTargeting: <String, String>{'some', 'targeting'},
  customTargetingLists: <String, List<String>>{'favoriteColors': <String>['red', 'yellow']},
);
```

## Ad Manager Banner Ads

Banner ads occupy a spot within an app's layout, either at the top or bottom of the device screen. They stay on screen while users are interacting with the app, and can refresh automatically after a certain period of time.

This guide shows you how to integrate banner ads from Ad Manager into a Flutter app. In addition to code snippets and instructions, it also includes information about sizing banners properly and links to additional resources.

See also the [codelab for inline ads in Flutter](https://codelabs.developers.google.com/codelabs/admob-inline-ads-in-flutter#6) for a detailed guide on setting up banner ads.


### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for banners:

*   Android: https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads#sample_ad_units
*   iOS: https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#demo_ad_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate a Banner Ad

A `PublisherBannerAd` requires an `adUnitId`, an `AdSize`, an `AdRequest`, and an `AdListener`. An example is shown below as well as more information on each parameter following.


```dart
final PublisherBannerAd myBanner = PublisherBannerAd(
  adUnitId: '<ad unit id>',
  size: AdSize.banner,
  request: PublisherAdRequest(),
  listener: AdListener(),
);
```

#### Banner Sizes

The table below lists the standard banner sizes.

<table>
  <tr>
   <td><strong>Size in dp (WxH)</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>AdSize Constant</strong>
   </td>
  </tr>
  <tr>
   <td>320x50
   </td>
   <td>Standard Banner
   </td>
   <td><code>banner</code>
   </td>
  </tr>
  <tr>
   <td>320x100
   </td>
   <td>Large Banner
   </td>
   <td><code>largeBanner</code>
   </td>
  </tr>
  <tr>
   <td>320x250
   </td>
   <td>Medium Rectangle
   </td>
   <td><code>mediumRectangle</code>
   </td>
  </tr>
  <tr>
   <td>468x60
   </td>
   <td>Full-Size Banner
   </td>
   <td><code>fullBanner</code>
   </td>
  </tr>
  <tr>
   <td>728x90
   </td>
   <td>Leaderboard
   </td>
   <td><code>leaderboard</code>
   </td>
  </tr>
  <tr>
   <td>Screen width x 32|50|90
   </td>
   <td><a href="https://developers.google.com/admob/android/banner/smart">Smart Banner</a>
   </td>
   <td>Use <code>getSmartBanner(Orientation)</code>
   </td>
  </tr>
</table>


To define a custom banner size, set your desired `AdSize`, as shown here:


```dart
final AdSize adSize = AdSize(300, 50);
```


#### Banner Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:


```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) => print('Ad closed.'),
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
);
```

### Load Banner Ad

After a `PublisherBannerAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myBanner.load();
```

### Display a Banner Ad

To display a `PublisherBannerAd` as a widget, you must instantiate an `AdWidget` with a supported ad after calling `load()`. You can create the widget before calling `load()`, but `load()` must be called before adding it to the widget tree.


```dart
final AdWidget adWidget = AdWidget(ad: myBanner);
```


`AdWidget` inherits from Flutter's Widget class and can be used as any other widget. On iOS, make sure you place the widget in a widget with a specified width and height. Otherwise, your Ad may not be displayed. A `PublisherBannerAd` can be placed in a container with a size that matches the ad:


```dart
final Container adContainer = Container(
  alignment: Alignment.center,
  child: adWidget,
  width: myBanner.size.width.toDouble(),
  height: myBanner.size.height.toDouble(),
);
```

Once an Ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is either after the `AdWidget` is removed from the widget tree or in the `AdListener.onAdFailedToLoad` callback.

That's it! Your app is now ready to display banner ads.


## Ad Manager Interstitial Ad

Interstitial ads are full-screen ads that cover the interface of their host app. They're typically displayed at natural transition points in the flow of an app, such as between activities or during the pause between levels in a game. When an app shows an interstitial ad, the user has the choice to either tap on the ad and continue to its destination or close it and return to the app.

This guide explains how to integrate interstitial ads into a Flutter app.


### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for interstitials:


*   Android: https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads#sample_ad_units
*   iOS: https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#demo_ad_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate an Interstitial Ad

A `PublisherInterstitialAd` requires an `adUnitId`, an `AdRequest`, and an `AdListener`. An example is shown below as well as more information on each parameter following.


```dart
final PublisherInterstitialAd myInterstitial = PublisherInterstitialAd(
  adUnitId: '<ad unit id>',
  request: PublisherAdRequest(),
  listener: AdListener(),
);
```

#### Interstitial Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:


```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) {
   ad.dispose();
   print('Ad closed.');
 },
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
);
```

### Load Interstitial Ad

After a `PublisherInterstitialAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myInterstitial.load();
```

### Display an Interstitial Ad

A `PublisherInterstitialAd` is displayed as an Overlay on top of all app content and is statically placed. Which means it can not be added to the Flutter widget tree. You can choose when to show the add by calling `show()` after the ad is loaded.

```dart
myInterstitial.show();
```

This method should only be called after `load()` and the `AdListener.onAdLoaded` method has been triggered. Once `show()` is called, an `Ad` displayed this way can't be removed programmatically and requires user input. Do not call `show()` more than once for a loaded `PublisherInterstitialAd`. Instead you should load a new ad.

Once an ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is  in the `AdListener.onAdFailedToLoad/AdListener.onAdClosed` callbacks.

That's it! Your app is now ready to display interstitial ads.


### Next steps



*   See [Interstitial best practices](https://www.youtube.com/watch?v=r2RgFD3Apyo&index=5&list=PLOU2XLYxmsIKX0pUJV3uqp6N3NeHwHh0c) and [interstitial ad guidance](https://support.google.com/admanager/answer/6309702?hl=en).
*   If you haven't already, create your own interstitial ad unit in the [Ad Manager UI](https://admanager.google.com/home/).

## Ad Manager Native Ads


Native ads are ad assets that are presented to users via UI components that are native to the platform. They're shown using the same types of views with which you're already building your layouts, and can be formatted to match the visual design of the user experience in which they live. In coding terms, this means that when a native ad loads, your app receives a NativeAd object that contains its assets, and the app (rather than the Google Mobile Ads SDK) is then responsible for displaying them.

Broadly speaking, there are two parts to successfully implementing Native Ads: loading an ad via the SDK and displaying the ad content in your app. This guide is concerned with using the SDK to load native ads.

See also the [codelab for inline ads in Flutter](https://codelabs.developers.google.com/codelabs/admob-inline-ads-in-flutter#7) for a detailed guide on setting up native ads.


### Platform Setup

Native Ads are presented to users via UI components that are native to the platform. (e.g. A [View](https://developer.android.com/reference/android/view/View) on Android or a [UIView](https://developer.apple.com/documentation/uikit/uiview?language=objc) on iOS).

Since Native Ads require UI components native to a platform, this feature requires additional setup for Android and iOS:


#### Android

The Android implementation of the Google Mobile Ads plugin requires a class that implements a NativeAdFactory. A `NativeAdFactory` contains a method that takes a [UnifiedNativeAd](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAd) and custom options and returns a [UnifiedNativeAdView](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAdView). The [UnifiedNativeAdView](https://developers.google.com/android/reference/com/google/android/gms/ads/formats/UnifiedNativeAdView) is what will be displayed in your app.

You can implement this in your MainActivity.java or create a separate class in the same directory as MainActivity.java as seen below:


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


Each `NativeAdFactory` needs to be registered with a `factoryId`, a unique `String` identifier, in `MainActivity.configureFlutterEngine(FlutterEngine)`. A `NativeAdFactory` can be implemented and registered for each unique Native ad layout used by your app or a single one can handle all layouts. The `NativeAdFactory` should also be unregistered in `cleanUpFlutterEngine(engine)` when building with [add-to-app](https://flutter.dev/docs/development/add-to-app#add-to-app).

`MainActivity.java` should look similar to:


```java
package my.app.path;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());
   super.configureFlutterEngine(flutterEngine);

    GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", NativeAdFactoryExample());
  }

  @Override
  public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
  }
}
```


When creating the `NativeAd` in Dart, the `factoryId` will need to match the one used to add the factory to `GoogleMobileAdsPlugin`. In the above code snippet, `adFactoryExample` is the name of the `factoryId.` An example `NativeAdFactory` follows:


```java
package io.flutter.plugins.googlemobileadsexample;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.widget.TextView;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

// my_native_ad.xml can be found at
/* https://github.com/googleads/googleads-mobile-flutter/tree/master/packages/google_mobile_ads/example/android/app/src/main/res/layout
*/
class NativeAdFactoryExample implements NativeAdFactory {
 private final LayoutInflater layoutInflater;

 NativeAdFactoryExample(LayoutInflater layoutInflater) {
   this.layoutInflater = layoutInflater;
 }

 @Override
 public UnifiedNativeAdView createNativeAd(
     UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
   final UnifiedNativeAdView adView =
       (UnifiedNativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
   final TextView headlineView = adView.findViewById(R.id.ad_headline);
   final TextView bodyView = adView.findViewById(R.id.ad_body);

   headlineView.setText(nativeAd.getHeadline());
   bodyView.setText(nativeAd.getBody());

   adView.setBackgroundColor(Color.YELLOW);

   adView.setNativeAd(nativeAd);
   adView.setBodyView(bodyView);
   adView.setHeadlineView(headlineView);
   return adView;
 }
}
```

#### iOS

The iOS implementation of the Google Mobile Ads plugin requires a class that implements a `FLTNativeAdFactory`. A `FLTNativeAdFactory` contains a method that takes a `GADUnifiedNativeAd` and custom options and returns a `GADUnifiedNativeAdView`. The `GADUnifiedNativeAdView` is what will be displayed in your app.

The `FLTNativeAdFactory` protocol can be implemented by `AppDelegate` or a separate class could be created as seen below:


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

Each `FLTNativeAdFactory` needs to be registered with a `factoryId`, a unique `String` identifier, in `registerNativeAdFactory:factoryId:nativeAdFactory:`. A `FLTNativeAdFactory` can be implemented and registered for each unique Native ad layout used by your app or a single one can handle all layouts. This is done by importing `FLTGoogleMobileAdsPlugin.h` and calling `registerNativeAdFactory:factoryId:nativeAdFactory:` with a `FlutterPluginRegistry`, a unique identifier for the factory, and the factory itself. The factory also MUST be added after `[GeneratedPluginRegistrant registerWithRegistry:self];` has been called.

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


When creating the `NativeAd` in Dart, the `factoryID` will need to match the one used to add the factory to `FLTGoogleMobileAdsPlugin`. In the above code snippet, `adFactoryExample` is the name of the `factoryID`.` An example `FLTNativeAdFactory` follows:


```objectivec
// The example UnifiedNativeAdView.xib can be found at
/* https://github.com/googleads/googleads-mobile-flutter/blob/master/packages/google_mobile_ads/example/ios/Runner/UnifiedNativeAdView.xib
*/
@interface NativeAdFactoryExample : NSObject <FLTNativeAdFactory>
@end

@implementation NativeAdFactoryExample
- (GADUnifiedNativeAdView *)createNativeAd:(GADUnifiedNativeAd *)nativeAd
                            customOptions:(NSDictionary *)customOptions {
 // Create and place ad in view hierarchy.
 GADUnifiedNativeAdView *adView =
     [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil].firstObject;

 // Associate the native ad view with the native ad object. This is
 // required to make the ad clickable.
 adView.nativeAd = nativeAd;

 // Populate the native ad view with the native ad assets.
 // The headline is guaranteed to be present in every native ad.
 ((UILabel *)adView.headlineView).text = nativeAd.headline;

 // These assets are not guaranteed to be present. Check that they are before
 // showing or hiding them.
 ((UILabel *)adView.bodyView).text = nativeAd.body;
 adView.bodyView.hidden = nativeAd.body ? NO : YES;

 [((UIButton *)adView.callToActionView) setTitle:nativeAd.callToAction
                                        forState:UIControlStateNormal];
 adView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

 ((UIImageView *)adView.iconView).image = nativeAd.icon.image;
 adView.iconView.hidden = nativeAd.icon ? NO : YES;

 ((UILabel *)adView.storeView).text = nativeAd.store;
 adView.storeView.hidden = nativeAd.store ? NO : YES;

 ((UILabel *)adView.priceView).text = nativeAd.price;
 adView.priceView.hidden = nativeAd.price ? NO : YES;

 ((UILabel *)adView.advertiserView).text = nativeAd.advertiser;
 adView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;

 // In order for the SDK to process touch events properly, user interaction
 // should be disabled.
 adView.callToActionView.userInteractionEnabled = NO;

 return adView;
}
@end
```

### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for native ads:

*   Android: https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads#sample_ad_units
*   iOS: https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#demo_ad_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate a Native Ad

A `NativeAd` requires an `adUnitId`, a `factoryId`, an `AdRequest`, and an `AdListener`. An example is shown below as well as more information on each parameter following.


```dart
final NativeAd myNative = NativeAd.fromPublisherRequest(
  adUnitId: '<test id or account id>',
  factoryId: 'adFactoryExample',
  request: PublisherAdRequest(),
  listener: AdListener(),
);
```

#### Factory Id

The `factoryId` will need to match the one used to add the factory to `GoogleMobileAdsPlugin` on Android and/or the `FLTGoogleMobileAdsPlugin` on iOS. The same `factoryId` can be used by both platforms or each can have their own.


#### Native Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:

```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) => print('Ad closed.'),
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
 // Called when a click is recorded for a NativeAd.
 onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
 // Called when an impression is recorded for a NativeAd.
 onNativeAdImpression: (NativeAd ad) => print('Ad impression.'),
);
```

### Load Native Ad

After a `NativeAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myNative.load();
```

### Display a Native Ad

To display a `NativeAd` as a widget, you must instantiate an `AdWidget` with a supported ad after calling `load()`. You can create the widget before calling `load()`, but `load()` must be called before adding it to the widget tree.


```dart
final AdWidget adWidget = AdWidget(ad: myBanner);
```

`AdWidget` inherits from Flutter's `Widget` class and can be used as any other widget. On iOS, make sure you place the widget in a widget with a specified width and height. Otherwise, your Ad may not be displayed.

```dart
final Container adContainer = Container(
  alignment: Alignment.center,
  child: adWidget,
  width: 500,
  height: 500,
);
```

Once an Ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is either after the `AdWidget` is removed from the widget tree or in the `AdListener.onAdFailedToLoad` callback.

That's it! Your app is now ready to display native ads.


### Next steps

*   See [native ads policies and guidelines](https://support.google.com/admanager/topic/9417059?hl=en&ref_topic=6366825) for implementing native ads.
*   Check out a [Native ads case study](https://admanager.google.com/home/resources/case-study-meaww-increases-cpms-with-native-ads/).


## Ad Manager Rewarded Ads

Rewarded ads are ads that users have the option of interacting with [in exchange for in-app rewards](https://support.google.com/admanager/answer/7496282?hl=en). This guide shows you how to integrate rewarded ads from Ad Manager into a Flutter app.


### Always test with test ads

When building and testing your apps, make sure you use test ads rather than live, production ads. Failure to do so can lead to suspension of your account.

The easiest way to load test ads is to use our dedicated test ad unit ID for rewarded:


*   Android: https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads#sample_ad_units
*   iOS: https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#demo_ad_units

It's been specially configured to return test ads for every request, and you're free to use it in your own apps while coding, testing, and debugging. Just make sure you replace it with your own ad unit ID before publishing your app.


### Instantiate a Rewarded Ad

A `RewardedAd` requires an `adUnitId`, an `AdRequest`, and an `AdListener` with the `onRewardedAdUserEarnedReward` callback implemented. An example is shown below as well as more information on each parameter following.


```dart
final RewardedAd myRewarded = RewardedAd.fromPublisherRequest(
 adUnitId: '<test id or account id>',
 request: PublisherAdRequest(),
 listener: AdListener(
   onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
     print(reward.type);
     print(reward.amount);
   },
 ),
);
```


#### Rewarded Ad Events

Through the use of `AdListener`, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app. This example implements each method and logs a message to the console:


```dart
final AdListener listener = AdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   ad.dispose();
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) {
   ad.dispose();
   print('Ad closed.');
 },
 // Called when an ad is in the process of leaving the application.
 onApplicationExit: (Ad ad) => print('Left application.'),
 // Called when a RewardedAd triggers a reward.
 onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
   print('Reward earned: $reward');
 },
);
```

Key Point: Make sure to implement the `onRewardedAdUserEarnedReward` event to
reward the user for watching an ad.

### Load Rewarded Ad

After a `RewardedAd` is instantiated, `load()` must be called before it can be shown on the screen.


```dart
myRewarded.load();
```

### Display a RewardedAd

A `RewardedAd` is displayed as an Overlay is displayed on top of all app content and is statically placed. Which means it can not be displayed this way can't be added to the Flutter widget tree. You can choose when to show the add by calling `show()` after the ad is loaded.


```dart
myRewarded.show();
```

This method should only be called after `load()` and the `AdListener.onAdLoaded` method has been triggered. Once `show()` is called, an `Ad` displayed this way can't be removed programmatically and require user input.  Do not call `show()` more than once for a loaded `RewardedAd`. Instead you should load a new ad.

Once an ad has called `load()`, it must call `dispose()` when access to it is no longer needed. The best practice for when to call `dispose()` is in the `AdListener.onAdFailedToLoad` and  `AdListener.onAdClosed` and  callbacks.

That's it! Your app is now ready to display rewarded ads.

### Next Steps

* See [rewarded ad policies](https://support.google.com/admanager/answer/7496282?hl=en).

## Targeting

The `RequestConfiguration` object collects the global configuration for every ad request and is applied by` MobileAds.instance.updateRequestConfiguration()`.

### Child-directed setting

For purposes of the [Children's Online Privacy Protection Act (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy), there is a setting called "tag for child-directed treatment."

As an app developer, you can indicate whether you want Google to treat your content as child-directed when you make an ad request. If you indicate that you want Google to treat your content as child-directed, we take steps to disable IBA and remarketing ads on that ad request. The setting can be used with all versions of the Google Play services SDK via` RequestConfiguration.tagForChildDirectedTreatment()`:

*   Use the argument `TagForChildDirectedTreatment.yes` to indicate that you want your content treated as child-directed for the purposes of COPPA.
*   Use the argument `TagForChildDirectedTreatment.no` to indicate that you don't want your content treated as child-directed for the purposes of COPPA.
*   Use the argument `TagForChildDirectedTreatment.unspecified` or do not set this tag if you do not wish to indicate how you would like your content treated with respect to COPPA in ad requests.

The following example indicates that you want your content treated as child-directed for purposes of COPPA:


```dart
final RequestConfiguration requestConfiguration = RequestConfiguration(
  tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes);
MobileAds.instance.updateRequestConfiguration(requestConfiguration);
```

### Users under the age of consent

You can mark your ad requests to receive treatment for users in the European Economic Area (EEA) under the age of consent. This feature is designed to help facilitate compliance with the [General Data Protection Regulation (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679). Note that you may have other legal obligations under GDPR. Please review the European Union’s guidance and consult with your own legal counsel. Please remember that Google's tools are designed to facilitate compliance and do not relieve any particular publisher of its obligations under the law. [Learn more about how the GDPR affects publishers](https://support.google.com/admob/answer/7666366).

When using this feature, a Tag For Users under the Age of Consent in Europe (TFUA) parameter will be included in the ad request. This parameter disables personalized advertising, including remarketing, for that specific ad request. It also disables requests to third-party ad vendors, such as ad measurement pixels and third-party ad servers.

The setting can be used via `RequestConfiguration.tagForUnderAgeOfConsent()`:


*   Use the argument `TagForUnderAgeOfConsent.yes` to indicate that you want the request configuration to be handled in a manner suitable for users under the age of consent.
*   Use the argument `TagForUnderAgeOfConsent.no` to indicates that you don't want the request configuration to be handled in a manner suitable for users under the age of consent.
*   Use the argument `TagForUnderAgeOfConsent.unspecified` or do not set this tag to indicate that you have not specified whether the ad request should receive treatment for users in the European Economic Area (EEA) under the age of consent. The following example indicates that you want TFUA included in your ad request:

```dart
final RequestConfiguration requestConfiguration = RequestConfiguration(
  tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes);
MobileAds.instance.updateRequestConfiguration(requestConfiguration);
```

The tags to enable the Child-directed setting and setTagForUnderAgeOfConsent should not both simultaneously be set to true. If they are, the child-directed setting takes precedence.


### Ad Content Filtering

The setting can be set via` RequestConfiguration.maxAdContentRating()`:

AdMob ads returned for these requests have a content rating at or below that level. The possible values for this network extra are based on [digital content label classifications](https://support.google.com/admob/answer/7562142), and should be one of the following` MaxAdContentRating` objects:

*   `MaxAdContentRating.g`
*   `MaxAdContentRating.pg`
*   `MaxAdContentRating.t`
*   `MaxAdContentRating.ma`

The following code configures a` RequestConfiguration` object to specify that ad content returned should correspond to a digital content label designation no higher than `G`:


```dart
final RequestConfiguration requestConfiguration = RequestConfiguration(
  maxAdContentRating: MaxAdContentRating.g);
MobileAds.instance.updateRequestConfiguration(requestConfiguration);
```
