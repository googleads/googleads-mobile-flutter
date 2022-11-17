# Mediation Example App

An example flutter project that demonstrates how to configure your app to
support mediation.

Mediation is a feature that allows you to serve ads into your app from multiple
sources, such as third party ad networks.

## Initialize the SDK

Make sure to add your app id to your AndroidManifest.xml and Info.plist. This
example project will not run until this is done. More information on how to this
can be found [here](https://developers.google.com/admob/flutter/quick-start#import_the_mobile_ads_sdk).


When you [initialize the Mobile Ads SDK](https://developers.google.com/admob/flutter/quick-start#initialize_the_mobile_ads_sdk),
mediation and bidding adapters also get initialized. It is important to wait for
initialization to complete before you load ads in order to ensure full
participation from every ad network on the first ad request.

The sample code shows you how you can check each adapter's initialization status
prior to making an ad request.

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize()
    .then((initializationStatus) {
      initializationStatus.adapterStatuses.forEach((key, value) {
        debugPrint('Adapter status for $key: ${value.description}');
      });
  });
  runApp(MyApp());
}
```

## Check which network adapter loaded the ad
Here is some sample code that prints the ad network class name for a banner ad:

```dart
final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: '<your-ad-unit>',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded: ${ad.responseInfo?.mediationAdapterClassName}');
        },
      ),
      request: AdRequest(),
    );
```


## Configure the ad unit to use mediation in Admob or Ad Manager
This is done in the Admob or Ad Manager UI. See the following links for details
of how to configure mediation:
* AdMob: https://support.google.com/admob/answer/3124703?hl=en&ref_topic=7383089
* Ad Manager: https://support.google.com/admanager/answer/7387351?hl=en&ref_topic=6373639


## Configure your account and ad in the mediation network's UI
This is described in the `integrate partner networks` section in the GMA devsite
for each network:
* https://developers.google.com/admob/android/mediate
* https://developers.google.com/ad-manager/mobile-ads-sdk/android/mediate
* https://developers.google.com/admob/ios/mediate
* https://developers.google.com/ad-manager/mobile-ads-sdk/ios/mediate

## Add the mediation adapter libraries to your Android and iOS projects
Each network may have its own dependencies that need to be added to your `build.gradle` 
and `podfile`. The dependencies required for each network are listed in the GMA
devsite links above.

There may also be additional setup required for the network. For example,
AppLovin requires you to add its key to your [AndroidManifest.xml on Android](https://developers.google.com/admob/android/mediation/applovin#step_1_set_up_applovin)
and [Podfile on iOS](https://developers.google.com/admob/ios/mediation/applovin#step_1_set_up_applovin).
See the TODOs in the [AndroidManifest.xml](https://github.com/googleads/googleads-mobile-flutter/tree/master/packages/mediation_example/android/app/src/main/AndroidManifest.xml)
and [Podfile](https://github.com/googleads/googleads-mobile-flutter/tree/master/packages/mediation_example/ios/Runner/Info.plist)
for where to add them.

## Call APIs in the mediation network's SDK
You can call APIs in the mediation network SDK from dart code by using a
[platform channel](https://flutter.dev/docs/development/platform-integration/platform-channels).

The following sample shows you how to call privacy APIs in AppLovin:

In your dart code, create a method channel:
```dart
/// Wraps a method channel that makes calls to AppLovin privacy APIs.
class MyMethodChannel {
  final MethodChannel _methodChannel =
      MethodChannel('com.example.mediationexample/mediation-channel');

  /// Sets whether the user is age restricted in AppLovin.
  Future<void> setAppLovinIsAgeRestrictedUser(bool isAgeRestricted) async {
    return _methodChannel.invokeMethod(
      'setIsAgeRestrictedUser',
      {
        'isAgeRestricted': isAgeRestricted,
      },
    );
  }

  /// Sets whether we have user consent for the user in AppLovin.
  Future<void> setHasUserConsent(bool hasUserConsent) async {
    return _methodChannel.invokeMethod(
      'setHasUserConsent',
      {
        'hasUserConsent': hasUserConsent,
      },
    );
  }
}
```

Setup a method call handler in your Android application:

```java
public class MainActivity extends FlutterActivity {
  private static final String CHANNEL_NAME =
    "com.example.mediationexample/mediation-channel";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    // Setup a method channel for calling APIs in the AppLovin SDK.
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            switch (call.method) {
              case "setIsAgeRestrictedUser":
                AppLovinPrivacySettings.setIsAgeRestrictedUser(call.argument("isAgeRestricted"), context);
                result.success(null);
                break;
              case "setHasUserConsent":
                AppLovinPrivacySettings.setHasUserConsent(call.argument("hasUserConsent"), context);
                result.success(null);
                break;
              default:
                result.notImplemented();
                break;
            }
          }
        );
  }
}
```

And in your iOS application:
```objective-c
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // Set up a method channel for calling methods in 3P SDKs.
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* methodChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.example.mediationexample/mediation-channel"
                                          binaryMessenger:controller.binaryMessenger];
  [methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([call.method isEqualToString:@"setIsAgeRestrictedUser"]) {
      [ALPrivacySettings setIsAgeRestrictedUser:call.arguments[@"isAgeRestricted"]];
      result(nil);
    } else if ([call.method isEqualToString:@"setHasUserConsent"]) {
      [ALPrivacySettings setHasUserConsent:call.arguments[@"hasUserConsent"]];
      result(nil);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}
@end
```

Now you can use your MethodChannel to call AppLovin privacy APIs from Dart.
Each network has its own APIs that you wish to call. More details of relevant
ones can be found in the AdMob and Ad Manager devsites (see `integrate partner networks`):
* https://developers.google.com/admob/android/mediate
* https://developers.google.com/ad-manager/mobile-ads-sdk/android/mediate
* https://developers.google.com/admob/ios/mediate
* https://developers.google.com/ad-manager/mobile-ads-sdk/ios/mediate

##  Network specific parameters
Some network adapters support additional parameters which can be passed to the
adapter when the ad request is created. These are referred to as network extras.

The plugin provides APIs on Android and iOS that let you pass network extras
when an ad request is created on the platform side. You need to implement
`MediationNetworkExtrasProvider` on Android and `FLTMediationNetworkExtrasProvider`
on iOS, and then register your extras provider with the plugin.

Android sample:

```java
// Register a MediationNetworkExtrasProvider with the plugin.
public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    // Register your MediationNetworkExtrasProvider to provide network extras to ad requests.
    GoogleMobileAdsPlugin.registerMediationNetworkExtrasProvider(
        flutterEngine, new MyMediationNetworkExtrasProvider());
  }
}

class MyMediationNetworkExtrasProvider implements MediationNetworkExtrasProvider {

  @Override
  public Map<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras(
      String adUnitId, @Nullable String identifier) {
    // This example passes extras to the applovin adapter.
    // This method is called with the ad unit of the associated ad request, and
    // an optional string parameter which comes from the dart ad request object.
    Bundle appLovinBundle = new AppLovinExtras.Builder().setMuteAudio(true).build();
    Map<Class<? extends MediationExtrasReceiver>, Bundle> extras = new HashMap<>();
    extras.put(ApplovinAdapter.class, appLovinBundle);

    return extras;
  }
}
```

iOS Sample:
```objective-c

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // Register your network extras provider if you want to provide
  // network extras to specific ad requests.
  MyFLTMediationNetworkExtrasProvider *networkExtrasProvider =
      [[MyFLTMediationNetworkExtrasProvider alloc] init];
  [FLTGoogleMobileAdsPlugin registerMediationNetworkExtrasProvider:networkExtrasProvider
                                                         registry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

@implementation MyFLTMediationNetworkExtrasProvider

- (NSArray<id<GADAdNetworkExtras>> *_Nullable)getMediationExtras:(NSString *_Nonnull)adUnitId
                                       mediationExtrasIdentifier:
                                           (NSString *_Nullable)mediationExtrasIdentifier {
  // This example passes extras to the applovin adapter.
  // This method is called with the ad unit of the associated ad request, and
  // an optional string parameter which comes from the dart ad request object.
  GADMAdapterAppLovinExtras *appLovinExtras = [[GADMAdapterAppLovinExtras alloc] init];
  appLovinExtras.muteAudio = NO;

  return @[ appLovinExtras ];
}
@end
```
