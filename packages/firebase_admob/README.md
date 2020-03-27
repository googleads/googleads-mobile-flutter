# firebase_admob

A plugin for [Flutter](https://flutter.dev) that supports loading and
displaying banner, interstitial (full-screen), native, and rewarded video ads using the
[Firebase AdMob API](https://firebase.google.com/docs/admob/).

For Flutter plugins for other Firebase products, see [README.md](https://github.com/FirebaseExtended/flutterfire/blob/master/README.md).

## Platform Specific Setup

This plugin supports Android and iOS and requires additional setup on both platforms before it can
be used in your app. The sections below explain the setup for each platform.

### Android

#### Setting up a Firebase Project

This plugin requires using Admob through the Firebase SDK and requires that you have a
Google Service file from Firebase inside your project. For Android, you will need to:

1. Create a Firebase **App**.
1. Generate a `google-service.json` file for this project.
3. Add the `google-service.json` file to your project's `android/app` folder.

You can follow the steps
[here](https://firebase.google.com/docs/android/setup#create-firebase-project) to see how to setup
a firebase project. You should only need to follow steps 1 -> 3.1.

#### Update your AndroidManifest.xml

AdMob 18 requires the App ID to be included in the `AndroidManifest.xml`. Failure
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

#### Setting up a Firebase Project

This plugin requires using Admob through the Firebase SDK and requires that you have a
Google Service file from Firebase inside your project. For iOS, you will need to:

1. Create a Firebase **App**.
1. Generate a `GoogleService-info.plist` file for this project.
3. Add the `GoogleService-info.plist` file to your project's `ios/Runner` folder.

You can follow the steps
[here](https://firebase.google.com/docs/ios/setup#create-firebase-project) to see how to setup
a firebase project. You should only need to follow steps 1 -> 3.

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

## Initializing the plugin
The AdMob plugin must be initialized with the AdMob App ID used in your
`AndroidManifest.xml`/`GoogleService-info.plist`.

```dart
FirebaseAdMob.instance.initialize(appId: appId);
```

## Creating and Loading an Ad

Instantiating each ad is slightly different and each supported format is explained in this section.
To see how to display an Ad after loading one, see section **Displaying an Ad**.

### Banner

Instantiating a `BannerAd` requires at least an `adUnitId` and an `AdSize` as shown below. When
testing, you should always use `BannerAd.testAdUnitId` and switch to an ad unit id from your AdMob
account when releasing.

```dart
final BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.banner,
);
```

After a `BannerAd` is instantiated, you must call `load()` before it can be shown on the screen.

```dart
final bool adBeganLoading = await myBanner.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**Targeting Info and Ad Event Listeners** to see additional parameters.

### Interstitial

Instantiating an `InterstitialAd` requires at least an `adUnitId` as shown below. When testing, you
should always use `InterstitialAd.testAdUnitId` and switch to an ad unit id from your AdMob
account when releasing. 

```dart
final InterstitialAd myInterstitial = myInterstitial(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
);
```

After a `InterstitialAd` is instantiated, you must call `load()` before it can be shown on the
screen.

```dart
final bool adBeganLoading = await myInterstitial.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**Targeting Info and Ad Event Listeners** to see additional parameters.

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
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin.NativeAdFactory;
import java.util.Map;

class NativeAdFactoryExample implements NativeAdFactory {
  @Override
  public UnifiedNativeAdView createNativeAd(
      UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
    // Create UnifiedNativeAdView
  }
}
```

An instance of a `NativeAdFactory` should also be added to the `FirebaseAdMobPlugin`. This is done
slightly differently depending on whether you are using **Embedding V1** or **Embedding V2**. 

If you're using the **Embedding V1**, you need to register your `NativeAdFactory` with a unique
`String` identifier after calling `GeneratedPluginRegistrant.registerWith(this);`.

You're `MainActivity.java` should look similar to:

```java
package my.app.path;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    FirebaseAdMobPlugin.registerNativeAdFactory(this, "adFactoryExample", new NativeAdFactoryExample());
  }
}
```

If you're using **Embedding V2**, you need to register your `NativeAdFactory` with a unique `String`
identifier after adding the `FirebaseAdMobPlugin` to the `FlutterEngine`. (Adding the
`FirebaseAdMobPlugin` to `FlutterEngine` should be done in a `GeneratedPluginRegistrant` in the near
future, so you may not see it being added here). You should also unregister the factory in
`cleanUpFlutterEngine(engine)`.

You're `MainActivity.java` should look similar to:

```java
package my.app.path;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new FirebaseAdMobPlugin());

    FirebaseAdMobPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", NativeAdFactoryExample());
  }

  @Override
  public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
    FirebaseAdMobPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
  }
}
```

When creating the `NativeAd` in Flutter, the `factoryId` parameter should match the one you used to
add the factory to `FirebaseAdMobPlugin`.

An example of displaying a `UnifiedNativeAd` with a `UnifiedNativeAdView` can be found
[here](https://developers.google.com/admob/android/native/advanced). The example app also inflates
a custom layout and displays the test Native ad.

#### iOS
Native Ads for iOS require a class that implements the protocol `FLTNativeAdFactory` which has a
single method `createNativeAd:customOptions:`.

You can have your `AppDelegate` implement this protocol or create a separate class as seen below:

```objectivec
/* AppDelegate.m */

#import "FLTFirebaseAdMobPlugin.h"

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
`FLTFirebaseAdMobPlugin`. This is done by importing `FLTFirebaseAdMobPlugin.h` and calling
`registerNativeAdFactory:factoryId:nativeAdFactory:` with a `FlutterPluginRegistry`, a unique
identifier for the factory, and the factory itself. The factory also *MUST* be added after
`[GeneratedPluginRegistrant registerWithRegistry:self];` has been called.

If this is done in `AppDelegate.m`, it should look similar to:

```objectivec
#import "FLTFirebaseAdMobPlugin.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  NativeAdFactoryExample *nativeAdFactory = [[NativeAdFactoryExample alloc] init];
  [FLTFirebaseAdMobPlugin registerNativeAdFactory:self
                                        factoryId:@"adFactoryExample"
                                  nativeAdFactory:nativeAdFactory];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

#### Dart Example

When creating a `NativeAd` in Dart, setup is similar to Banners and Interstitials. You need at least
an ad unit id and the `factoryId` that matches the id used to register the `NativeAdFactory`
in Java/Kotlin/Obj-C/Swift. An example of this implementation is seen below. Also, remember that
testing should always be done with the `NativeAd.testAdUnitId`.

```dart

final NativeAd nativeAd = NativeAd(
  adUnitId: NativeAd.testAdUnitId,
  factoryId: 'adFactoryExample',
);
```

Once created you can call `load()`.

```dart
final bool adBeganLoading = await nativeAd.load();
```

See section **Displaying an Ad** to see how to show the ad in your app and section
**Targeting Info and Ad Event Listeners** to see additional parameters.

### Rewarded Video Ads

Unlike `BannerAd`s and `InterstitialAd`s, rewarded video ads are loaded one at a time
via a singleton object, `RewardedVideoAd.instance`. Its `load` method takes an
AdMob ad unit ID and an instance of `MobileAdTargetingInfo`:

```dart
RewardedVideoAd.instance.load(myAdMobAdUnitId, targetingInfo);
```

To listen for events in the rewarded video ad lifecycle, apps can define a
function matching the `RewardedVideoAdListener` typedef, and assign it to the
`listener` instance variable in `RewardedVideoAd`. If set, the `listener`
function will be invoked whenever one of the events in the `RewardedVideAdEvent`
enum occurs. After a rewarded video ad loads, for example, the
`RewardedVideoAdEvent.loaded` is sent. Any time after that, apps can show the ad.

When the AdMob SDK decides it's time to grant an in-app reward, it does so via
the `RewardedVideoAdEvent.rewarded` event:

```dart
RewardedVideoAd.instance.listener =
    (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  if (event == RewardedVideoAdEvent.rewarded) {
    setState(() {
      // Here, apps should update state to reflect the reward.
      _goldCoins += rewardAmount;
    });
  }
};
```

Because `RewardedVideoAd` is a singleton object, it does not offer a `dispose`
method.

## Displaying an Ad

Each ad format can be displayed using at least one of two methods. **Overlay** and **Widget**. This
section explain the difference between using both.

### Overlay

An ad that is displayed as an **Overlay** is displayed on top of all app content and is statically
placed. Ad displayed this way can't be added to the Flutter widget tree.
`BannerAd`s, `InterstitialAd`s, `NativeAd`s, and `RewardedVideoAd`s can all be displayed this way.
You can display and remove an ad by calling `show()` and `dispose` respectively. This method must
only be called after `load()`.

```dart
mybanner.show();
```

For `BannerAd`s and `NativeAd`s you can also change the position on the screen.

```dart
mybanner.show(
    // Positions the banner ad 60 pixels from the bottom of the screen
    anchorOffset: 60.0,
    // Positions the banner ad 10 pixels from the center of the screen to the right
    horizontalCenterOffset: 10.0,
    // Banner Position
    anchorType: AnchorType.bottom,
);
```

It is also worth noting that `InterstitialAds`s and `RewardedVideoAd`s can't be programmatically
removed from view. They require user input to be dismissed from the screen.

### Widget

An ad that is displayed as a **Widget** is displayed as a typical Flutter `Widget` and can be added
to the Flutter widget tree. This is only supported by ads that don't cover an entire screen, such as
`BannerAd` and `NativeAd`. To display one of these ads as a widget, you must instantiate an
`AdWidget` with a supported ad after calling. You can create the widget before calling `load()`, but
`load()` must be called before adding it to the widget tree.

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

When the ad is no longer needed, call `dispose()` to release resources used by the add.

## Targeting Info and Ad Event Listeners

`BannerAd`s, `InterstitialAd`s, and `NativeAd`s can also be configured with targeting information
and a `MobileAdEvent` listener as shown in a `BannerAd` below.

```dart
final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
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
  targetingInfo: targetingInfo,
  size: AdSize.smartBanner,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
```

## Limitations

This plugin currently has some limitations:

- It's not possible to specify a banner ad's size.
- The existing tests are fairly rudimentary.
- There is no API doc.
- The example should demonstrate how to show gate a route push with an
  interstitial ad.

## Issues and feedback

Please file Flutterfire specific issues, bugs, or feature requests in our [issue tracker](https://github.com/FirebaseExtended/flutterfire/issues/new).

Plugin issues that are not specific to Flutterfire can be filed in the [Flutter issue tracker](https://github.com/flutter/flutter/issues/new).

To contribute a change to this plugin,
please review our [contribution guide](https://github.com/FirebaseExtended/flutterfire/blob/master/CONTRIBUTING.md),
and send a [pull request](https://github.com/FirebaseExtended/flutterfire/pulls).
