// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:reference/reference.dart';

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

mixin $LoadAdError {
  int get code;
String get domain;
String get message;
  
}

mixin $AdRequest {
  
  Future<void> addKeyword(String keyword);

Future<void> setContentUrl(String url);

Future<void> setNonPersonalizedAds(bool nonPersonalizedAds);
}

mixin $PublisherAdRequest {
  
  Future<void> addCustomTargeting(String key, String value);

Future<void> addCustomTargetingList(String key, List<String> values);
}

mixin $AdSize {
  int get width;
int get height;
String? get constant;
  
}

mixin $AdListener {
  
  void onAdLoaded();

void onAdFailedToLoad($LoadAdError error);

void onAppEvent(String name, String data);

void onNativeAdClicked();

void onNativeAdImpression();

void onAdOpened();

void onApplicationExit();

void onAdClosed();

void onRewardedAdUserEarnedReward($RewardItem reward);
}

mixin $BannerAd {
  $AdSize get size;
String get adUnitId;
$AdListener get listener;
$AdRequest get request;
  Future<void> load();
}

mixin $PublisherBannerAd {
  List<$AdSize> get sizes;
String get adUnitId;
$AdListener get listener;
$PublisherAdRequest get request;
  Future<void> load();
}

mixin $NativeAd {
  String get adUnitId;
String get factoryId;
$AdListener get listener;
$AdRequest get request;
Map<String,Object> get customOptions;
  Future<void> load();
}

mixin $InterstitialAd {
  String get adUnitId;
$AdListener get listener;
$AdRequest get request;
  Future<void> load();

Future<void> show();
}

mixin $PublisherInterstitialAd {
  String get adUnitId;
$AdListener get listener;
$PublisherAdRequest get request;
  Future<void> load();

Future<void> show();
}

mixin $RewardedAd {
  String get adUnitId;
$AdListener get listener;
$AdRequest get request;
$ServerSideVerificationOptions? get serverSideVerificationOptions;
  Future<void> load();

Future<void> show();
}

mixin $RewardItem {
  num get amount;
String get type;
  
}

mixin $ServerSideVerificationOptions {
  
  Future<void> setUserId(String userId);

Future<void> setCustomData(String customData);
}

class $LoadAdErrorCreationArgs {
  late int code;
late String domain;
late String message;
}

class $AdRequestCreationArgs {
  
}

class $PublisherAdRequestCreationArgs {
  
}

class $AdSizeCreationArgs {
  late int width;
late int height;
late String? constant;
}

class $AdListenerCreationArgs {
  
}

class $BannerAdCreationArgs {
  late $AdSize size;
late String adUnitId;
late $AdListener listener;
late $AdRequest request;
}

class $PublisherBannerAdCreationArgs {
  late List<$AdSize> sizes;
late String adUnitId;
late $AdListener listener;
late $PublisherAdRequest request;
}

class $NativeAdCreationArgs {
  late String adUnitId;
late String factoryId;
late $AdListener listener;
late $AdRequest request;
late Map<String,Object> customOptions;
}

class $InterstitialAdCreationArgs {
  late String adUnitId;
late $AdListener listener;
late $AdRequest request;
}

class $PublisherInterstitialAdCreationArgs {
  late String adUnitId;
late $AdListener listener;
late $PublisherAdRequest request;
}

class $RewardedAdCreationArgs {
  late String adUnitId;
late $AdListener listener;
late $AdRequest request;
late $ServerSideVerificationOptions? serverSideVerificationOptions;
}

class $RewardItemCreationArgs {
  late num amount;
late String type;
}

class $ServerSideVerificationOptionsCreationArgs {
  
}

class $LoadAdErrorChannel extends TypeChannel<$LoadAdError> {
  $LoadAdErrorChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.LoadAdError');

  

  
}

class $AdRequestChannel extends TypeChannel<$AdRequest> {
  $AdRequestChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdRequest');

  

  Future<Object?> $invokeAddKeyword(
      $AdRequest instance, String keyword) {
    return sendInvokeMethod(
      instance,
      'addKeyword',
      <Object?>[keyword],
    );
  }

Future<Object?> $invokeSetContentUrl(
      $AdRequest instance, String url) {
    return sendInvokeMethod(
      instance,
      'setContentUrl',
      <Object?>[url],
    );
  }

Future<Object?> $invokeSetNonPersonalizedAds(
      $AdRequest instance, bool nonPersonalizedAds) {
    return sendInvokeMethod(
      instance,
      'setNonPersonalizedAds',
      <Object?>[nonPersonalizedAds],
    );
  }
}

class $PublisherAdRequestChannel extends TypeChannel<$PublisherAdRequest> {
  $PublisherAdRequestChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.PublisherAdRequest');

  

  Future<Object?> $invokeAddCustomTargeting(
      $PublisherAdRequest instance, String key, String value) {
    return sendInvokeMethod(
      instance,
      'addCustomTargeting',
      <Object?>[key, value],
    );
  }

Future<Object?> $invokeAddCustomTargetingList(
      $PublisherAdRequest instance, String key, List<String> values) {
    return sendInvokeMethod(
      instance,
      'addCustomTargetingList',
      <Object?>[key, values],
    );
  }
}

class $AdSizeChannel extends TypeChannel<$AdSize> {
  $AdSizeChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdSize');

  Future<Object?> $invokeGetPortraitAnchoredAdaptiveBannerAdSize(int width) {
    return sendInvokeStaticMethod(
      'getPortraitAnchoredAdaptiveBannerAdSize',
      <Object?>[width],
    );
  }

Future<Object?> $invokeGetLandscapeAnchoredAdaptiveBannerAdSize(int width) {
    return sendInvokeStaticMethod(
      'getLandscapeAnchoredAdaptiveBannerAdSize',
      <Object?>[width],
    );
  }

  
}

class $AdListenerChannel extends TypeChannel<$AdListener> {
  $AdListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdListener');

  

  Future<Object?> $invokeOnAdLoaded(
      $AdListener instance, ) {
    return sendInvokeMethod(
      instance,
      'onAdLoaded',
      <Object?>[],
    );
  }

Future<Object?> $invokeOnAdFailedToLoad(
      $AdListener instance, $LoadAdError error) {
    return sendInvokeMethod(
      instance,
      'onAdFailedToLoad',
      <Object?>[error],
    );
  }

Future<Object?> $invokeOnAppEvent(
      $AdListener instance, String name, String data) {
    return sendInvokeMethod(
      instance,
      'onAppEvent',
      <Object?>[name, data],
    );
  }

Future<Object?> $invokeOnNativeAdClicked(
      $AdListener instance, ) {
    return sendInvokeMethod(
      instance,
      'onNativeAdClicked',
      <Object?>[],
    );
  }

Future<Object?> $invokeOnNativeAdImpression(
      $AdListener instance, ) {
    return sendInvokeMethod(
      instance,
      'onNativeAdImpression',
      <Object?>[],
    );
  }

Future<Object?> $invokeOnAdOpened(
      $AdListener instance, ) {
    return sendInvokeMethod(
      instance,
      'onAdOpened',
      <Object?>[],
    );
  }

Future<Object?> $invokeOnApplicationExit(
      $AdListener instance, ) {
    return sendInvokeMethod(
      instance,
      'onApplicationExit',
      <Object?>[],
    );
  }

Future<Object?> $invokeOnAdClosed(
      $AdListener instance, ) {
    return sendInvokeMethod(
      instance,
      'onAdClosed',
      <Object?>[],
    );
  }

Future<Object?> $invokeOnRewardedAdUserEarnedReward(
      $AdListener instance, $RewardItem reward) {
    return sendInvokeMethod(
      instance,
      'onRewardedAdUserEarnedReward',
      <Object?>[reward],
    );
  }
}

class $BannerAdChannel extends TypeChannel<$BannerAd> {
  $BannerAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.BannerAd');

  

  Future<Object?> $invokeLoad(
      $BannerAd instance, ) {
    return sendInvokeMethod(
      instance,
      'load',
      <Object?>[],
    );
  }
}

class $PublisherBannerAdChannel extends TypeChannel<$PublisherBannerAd> {
  $PublisherBannerAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.PublisherBannerAd');

  

  Future<Object?> $invokeLoad(
      $PublisherBannerAd instance, ) {
    return sendInvokeMethod(
      instance,
      'load',
      <Object?>[],
    );
  }
}

class $NativeAdChannel extends TypeChannel<$NativeAd> {
  $NativeAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.NativeAd');

  

  Future<Object?> $invokeLoad(
      $NativeAd instance, ) {
    return sendInvokeMethod(
      instance,
      'load',
      <Object?>[],
    );
  }
}

class $InterstitialAdChannel extends TypeChannel<$InterstitialAd> {
  $InterstitialAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.InterstitialAd');

  

  Future<Object?> $invokeLoad(
      $InterstitialAd instance, ) {
    return sendInvokeMethod(
      instance,
      'load',
      <Object?>[],
    );
  }

Future<Object?> $invokeShow(
      $InterstitialAd instance, ) {
    return sendInvokeMethod(
      instance,
      'show',
      <Object?>[],
    );
  }
}

class $PublisherInterstitialAdChannel extends TypeChannel<$PublisherInterstitialAd> {
  $PublisherInterstitialAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.PublisherInterstitialAd');

  

  Future<Object?> $invokeLoad(
      $PublisherInterstitialAd instance, ) {
    return sendInvokeMethod(
      instance,
      'load',
      <Object?>[],
    );
  }

Future<Object?> $invokeShow(
      $PublisherInterstitialAd instance, ) {
    return sendInvokeMethod(
      instance,
      'show',
      <Object?>[],
    );
  }
}

class $RewardedAdChannel extends TypeChannel<$RewardedAd> {
  $RewardedAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RewardedAd');

  

  Future<Object?> $invokeLoad(
      $RewardedAd instance, ) {
    return sendInvokeMethod(
      instance,
      'load',
      <Object?>[],
    );
  }

Future<Object?> $invokeShow(
      $RewardedAd instance, ) {
    return sendInvokeMethod(
      instance,
      'show',
      <Object?>[],
    );
  }
}

class $RewardItemChannel extends TypeChannel<$RewardItem> {
  $RewardItemChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RewardItem');

  

  
}

class $ServerSideVerificationOptionsChannel extends TypeChannel<$ServerSideVerificationOptions> {
  $ServerSideVerificationOptionsChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.ServerSideVerificationOptions');

  

  Future<Object?> $invokeSetUserId(
      $ServerSideVerificationOptions instance, String userId) {
    return sendInvokeMethod(
      instance,
      'setUserId',
      <Object?>[userId],
    );
  }

Future<Object?> $invokeSetCustomData(
      $ServerSideVerificationOptions instance, String customData) {
    return sendInvokeMethod(
      instance,
      'setCustomData',
      <Object?>[customData],
    );
  }
}

class $LoadAdErrorHandler implements TypeChannelHandler<$LoadAdError> {
  $LoadAdError onCreate(
    TypeChannelMessenger messenger,
    $LoadAdErrorCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $LoadAdError instance,
  ) {
    return <Object?>[instance.code, instance.domain, instance.message];
  }

  @override
  $LoadAdError createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $LoadAdErrorCreationArgs()..code = arguments[0] as int
..domain = arguments[1] as String
..message = arguments[2] as String,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $LoadAdError instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $AdRequestHandler implements TypeChannelHandler<$AdRequest> {
  $AdRequest onCreate(
    TypeChannelMessenger messenger,
    $AdRequestCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $AdRequest instance,
  ) {
    return <Object?>[];
  }

  @override
  $AdRequest createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $AdRequestCreationArgs(),
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdRequest instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'addKeyword':
        method = () => instance.addKeyword(arguments[0] as String);
        break;
case 'setContentUrl':
        method = () => instance.setContentUrl(arguments[0] as String);
        break;
case 'setNonPersonalizedAds':
        method = () => instance.setNonPersonalizedAds(arguments[0] as bool);
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $PublisherAdRequestHandler implements TypeChannelHandler<$PublisherAdRequest> {
  $PublisherAdRequest onCreate(
    TypeChannelMessenger messenger,
    $PublisherAdRequestCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $PublisherAdRequest instance,
  ) {
    return <Object?>[];
  }

  @override
  $PublisherAdRequest createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $PublisherAdRequestCreationArgs(),
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $PublisherAdRequest instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'addCustomTargeting':
        method = () => instance.addCustomTargeting(arguments[0] as String,arguments[1] as String);
        break;
case 'addCustomTargetingList':
        method = () => instance.addCustomTargetingList(arguments[0] as String,arguments[1] as List<String>);
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $AdSizeHandler implements TypeChannelHandler<$AdSize> {
  $AdSize onCreate(
    TypeChannelMessenger messenger,
    $AdSizeCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  double $onGetPortraitAnchoredAdaptiveBannerAdSize(
      TypeChannelMessenger messenger, int width) {
    throw UnimplementedError();
  }
double $onGetLandscapeAnchoredAdaptiveBannerAdSize(
      TypeChannelMessenger messenger, int width) {
    throw UnimplementedError();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'getPortraitAnchoredAdaptiveBannerAdSize':
        method =
            () => $onGetPortraitAnchoredAdaptiveBannerAdSize(messenger, arguments[0] as int);
        break;
case 'getLandscapeAnchoredAdaptiveBannerAdSize':
        method =
            () => $onGetLandscapeAnchoredAdaptiveBannerAdSize(messenger, arguments[0] as int);
        break;
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $AdSize instance,
  ) {
    return <Object?>[instance.width, instance.height, instance.constant];
  }

  @override
  $AdSize createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $AdSizeCreationArgs()..width = arguments[0] as int
..height = arguments[1] as int
..constant = arguments[2] as String?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdSize instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $AdListenerHandler implements TypeChannelHandler<$AdListener> {
  $AdListener onCreate(
    TypeChannelMessenger messenger,
    $AdListenerCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $AdListener instance,
  ) {
    return <Object?>[];
  }

  @override
  $AdListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $AdListenerCreationArgs(),
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdListener instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'onAdLoaded':
        method = () => instance.onAdLoaded();
        break;
case 'onAdFailedToLoad':
        method = () => instance.onAdFailedToLoad(arguments[0] as $LoadAdError);
        break;
case 'onAppEvent':
        method = () => instance.onAppEvent(arguments[0] as String,arguments[1] as String);
        break;
case 'onNativeAdClicked':
        method = () => instance.onNativeAdClicked();
        break;
case 'onNativeAdImpression':
        method = () => instance.onNativeAdImpression();
        break;
case 'onAdOpened':
        method = () => instance.onAdOpened();
        break;
case 'onApplicationExit':
        method = () => instance.onApplicationExit();
        break;
case 'onAdClosed':
        method = () => instance.onAdClosed();
        break;
case 'onRewardedAdUserEarnedReward':
        method = () => instance.onRewardedAdUserEarnedReward(arguments[0] as $RewardItem);
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $BannerAdHandler implements TypeChannelHandler<$BannerAd> {
  $BannerAd onCreate(
    TypeChannelMessenger messenger,
    $BannerAdCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $BannerAd instance,
  ) {
    return <Object?>[instance.size, instance.adUnitId, instance.listener, instance.request];
  }

  @override
  $BannerAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $BannerAdCreationArgs()..size = arguments[0] as $AdSize
..adUnitId = arguments[1] as String
..listener = arguments[2] as $AdListener
..request = arguments[3] as $AdRequest,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $BannerAd instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'load':
        method = () => instance.load();
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $PublisherBannerAdHandler implements TypeChannelHandler<$PublisherBannerAd> {
  $PublisherBannerAd onCreate(
    TypeChannelMessenger messenger,
    $PublisherBannerAdCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $PublisherBannerAd instance,
  ) {
    return <Object?>[instance.sizes, instance.adUnitId, instance.listener, instance.request];
  }

  @override
  $PublisherBannerAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $PublisherBannerAdCreationArgs()..sizes = arguments[0] as List<$AdSize>
..adUnitId = arguments[1] as String
..listener = arguments[2] as $AdListener
..request = arguments[3] as $PublisherAdRequest,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $PublisherBannerAd instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'load':
        method = () => instance.load();
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $NativeAdHandler implements TypeChannelHandler<$NativeAd> {
  $NativeAd onCreate(
    TypeChannelMessenger messenger,
    $NativeAdCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $NativeAd instance,
  ) {
    return <Object?>[instance.adUnitId, instance.factoryId, instance.listener, instance.request, instance.customOptions];
  }

  @override
  $NativeAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $NativeAdCreationArgs()..adUnitId = arguments[0] as String
..factoryId = arguments[1] as String
..listener = arguments[2] as $AdListener
..request = arguments[3] as $AdRequest
..customOptions = arguments[4] as Map<String,Object>,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $NativeAd instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'load':
        method = () => instance.load();
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $InterstitialAdHandler implements TypeChannelHandler<$InterstitialAd> {
  $InterstitialAd onCreate(
    TypeChannelMessenger messenger,
    $InterstitialAdCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $InterstitialAd instance,
  ) {
    return <Object?>[instance.adUnitId, instance.listener, instance.request];
  }

  @override
  $InterstitialAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $InterstitialAdCreationArgs()..adUnitId = arguments[0] as String
..listener = arguments[1] as $AdListener
..request = arguments[2] as $AdRequest,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $InterstitialAd instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'load':
        method = () => instance.load();
        break;
case 'show':
        method = () => instance.show();
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $PublisherInterstitialAdHandler implements TypeChannelHandler<$PublisherInterstitialAd> {
  $PublisherInterstitialAd onCreate(
    TypeChannelMessenger messenger,
    $PublisherInterstitialAdCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $PublisherInterstitialAd instance,
  ) {
    return <Object?>[instance.adUnitId, instance.listener, instance.request];
  }

  @override
  $PublisherInterstitialAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $PublisherInterstitialAdCreationArgs()..adUnitId = arguments[0] as String
..listener = arguments[1] as $AdListener
..request = arguments[2] as $PublisherAdRequest,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $PublisherInterstitialAd instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'load':
        method = () => instance.load();
        break;
case 'show':
        method = () => instance.show();
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $RewardedAdHandler implements TypeChannelHandler<$RewardedAd> {
  $RewardedAd onCreate(
    TypeChannelMessenger messenger,
    $RewardedAdCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $RewardedAd instance,
  ) {
    return <Object?>[instance.adUnitId, instance.listener, instance.request, instance.serverSideVerificationOptions];
  }

  @override
  $RewardedAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $RewardedAdCreationArgs()..adUnitId = arguments[0] as String
..listener = arguments[1] as $AdListener
..request = arguments[2] as $AdRequest
..serverSideVerificationOptions = arguments[3] as $ServerSideVerificationOptions?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $RewardedAd instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'load':
        method = () => instance.load();
        break;
case 'show':
        method = () => instance.show();
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $RewardItemHandler implements TypeChannelHandler<$RewardItem> {
  $RewardItem onCreate(
    TypeChannelMessenger messenger,
    $RewardItemCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $RewardItem instance,
  ) {
    return <Object?>[instance.amount, instance.type];
  }

  @override
  $RewardItem createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $RewardItemCreationArgs()..amount = arguments[0] as num
..type = arguments[1] as String,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $RewardItem instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}class $ServerSideVerificationOptionsHandler implements TypeChannelHandler<$ServerSideVerificationOptions> {
  $ServerSideVerificationOptions onCreate(
    TypeChannelMessenger messenger,
    $ServerSideVerificationOptionsCreationArgs args,
  ) {
    throw UnimplementedError();
  }

  

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      
      default:
        throw ArgumentError.value(
          methodName,
          'methodName',
          'Unable to invoke static method `$methodName`',
        );
    }

    // ignore: dead_code
    return method();
  }

  @override
  List<Object?> getCreationArguments(
    TypeChannelMessenger messenger,
    $ServerSideVerificationOptions instance,
  ) {
    return <Object?>[];
  }

  @override
  $ServerSideVerificationOptions createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return onCreate(
      messenger,
      $ServerSideVerificationOptionsCreationArgs(),
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $ServerSideVerificationOptions instance,
    String methodName,
    List<Object?> arguments,
  ) {
    // ignore: prefer_final_locals, prefer_function_declarations_over_variables
    Function method = () {};
    switch (methodName) {
      case 'setUserId':
        method = () => instance.setUserId(arguments[0] as String);
        break;
case 'setCustomData':
        method = () => instance.setCustomData(arguments[0] as String);
        break;
      default:
        throw ArgumentError.value(
          instance,
          'instance',
          'Unable to invoke method `$methodName` on',
        );
    }

    // ignore: dead_code
    return method();
  }
}

class $LibraryImplementations {
  $LibraryImplementations(this.messenger);

  final TypeChannelMessenger messenger;

  $LoadAdErrorChannel get loadAdErrorChannel =>
      $LoadAdErrorChannel(messenger);
$AdRequestChannel get adRequestChannel =>
      $AdRequestChannel(messenger);
$PublisherAdRequestChannel get publisherAdRequestChannel =>
      $PublisherAdRequestChannel(messenger);
$AdSizeChannel get adSizeChannel =>
      $AdSizeChannel(messenger);
$AdListenerChannel get adListenerChannel =>
      $AdListenerChannel(messenger);
$BannerAdChannel get bannerAdChannel =>
      $BannerAdChannel(messenger);
$PublisherBannerAdChannel get publisherBannerAdChannel =>
      $PublisherBannerAdChannel(messenger);
$NativeAdChannel get nativeAdChannel =>
      $NativeAdChannel(messenger);
$InterstitialAdChannel get interstitialAdChannel =>
      $InterstitialAdChannel(messenger);
$PublisherInterstitialAdChannel get publisherInterstitialAdChannel =>
      $PublisherInterstitialAdChannel(messenger);
$RewardedAdChannel get rewardedAdChannel =>
      $RewardedAdChannel(messenger);
$RewardItemChannel get rewardItemChannel =>
      $RewardItemChannel(messenger);
$ServerSideVerificationOptionsChannel get serverSideVerificationOptionsChannel =>
      $ServerSideVerificationOptionsChannel(messenger);
  $LoadAdErrorHandler get loadAdErrorHandler => $LoadAdErrorHandler();
$AdRequestHandler get adRequestHandler => $AdRequestHandler();
$PublisherAdRequestHandler get publisherAdRequestHandler => $PublisherAdRequestHandler();
$AdSizeHandler get adSizeHandler => $AdSizeHandler();
$AdListenerHandler get adListenerHandler => $AdListenerHandler();
$BannerAdHandler get bannerAdHandler => $BannerAdHandler();
$PublisherBannerAdHandler get publisherBannerAdHandler => $PublisherBannerAdHandler();
$NativeAdHandler get nativeAdHandler => $NativeAdHandler();
$InterstitialAdHandler get interstitialAdHandler => $InterstitialAdHandler();
$PublisherInterstitialAdHandler get publisherInterstitialAdHandler => $PublisherInterstitialAdHandler();
$RewardedAdHandler get rewardedAdHandler => $RewardedAdHandler();
$RewardItemHandler get rewardItemHandler => $RewardItemHandler();
$ServerSideVerificationOptionsHandler get serverSideVerificationOptionsHandler => $ServerSideVerificationOptionsHandler();
}

class $ChannelRegistrar {
  $ChannelRegistrar(this.implementations);

  final $LibraryImplementations implementations;

  void registerHandlers() {
    implementations.loadAdErrorChannel.setHandler(
      implementations.loadAdErrorHandler,
    );
implementations.adRequestChannel.setHandler(
      implementations.adRequestHandler,
    );
implementations.publisherAdRequestChannel.setHandler(
      implementations.publisherAdRequestHandler,
    );
implementations.adSizeChannel.setHandler(
      implementations.adSizeHandler,
    );
implementations.adListenerChannel.setHandler(
      implementations.adListenerHandler,
    );
implementations.bannerAdChannel.setHandler(
      implementations.bannerAdHandler,
    );
implementations.publisherBannerAdChannel.setHandler(
      implementations.publisherBannerAdHandler,
    );
implementations.nativeAdChannel.setHandler(
      implementations.nativeAdHandler,
    );
implementations.interstitialAdChannel.setHandler(
      implementations.interstitialAdHandler,
    );
implementations.publisherInterstitialAdChannel.setHandler(
      implementations.publisherInterstitialAdHandler,
    );
implementations.rewardedAdChannel.setHandler(
      implementations.rewardedAdHandler,
    );
implementations.rewardItemChannel.setHandler(
      implementations.rewardItemHandler,
    );
implementations.serverSideVerificationOptionsChannel.setHandler(
      implementations.serverSideVerificationOptionsHandler,
    );
  }

  void unregisterHandlers() {
    implementations.loadAdErrorChannel.removeHandler();
implementations.adRequestChannel.removeHandler();
implementations.publisherAdRequestChannel.removeHandler();
implementations.adSizeChannel.removeHandler();
implementations.adListenerChannel.removeHandler();
implementations.bannerAdChannel.removeHandler();
implementations.publisherBannerAdChannel.removeHandler();
implementations.nativeAdChannel.removeHandler();
implementations.interstitialAdChannel.removeHandler();
implementations.publisherInterstitialAdChannel.removeHandler();
implementations.rewardedAdChannel.removeHandler();
implementations.rewardItemChannel.removeHandler();
implementations.serverSideVerificationOptionsChannel.removeHandler();
  }
}
