// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:reference/reference.dart';

import 'ad_containers.dart';

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

mixin $AppEventListener {
  dynamic onAppEvent(
    String name,
    String data,
  );
}

mixin $AdWithViewListener {
  dynamic onAdLoaded();

  dynamic onAdFailedToLoad(
    LoadAdError error,
  );

  dynamic onAdOpened();

  dynamic onAdWillDismissScreen();

  dynamic onAdClosed();

  dynamic onAdImpression();
}

mixin $BannerAdListener {}

mixin $AdManagerBannerAdListener {}

mixin $NativeAdListener {
  dynamic onAdClicked();
}

mixin $FullScreenContentCallback {
  dynamic onAdShowedFullScreenContent();

  dynamic onAdDismissedFullScreenContent();

  dynamic onAdWillDismissFullScreenContent();

  dynamic onAdImpression();

  dynamic onAdFailedToShowFullScreenContent();
}

mixin $FullScreenAdLoadCallback {
  dynamic onAdLoaded();

  dynamic onAdFailedToLoad(
    LoadAdError error,
  );
}

mixin $RewardedAdLoadCallback {}

mixin $InterstitialAdLoadCallback {}

mixin $AdManagerInterstitialAdLoadCallback {}

class $AppEventListenerChannel extends TypeChannel<$AppEventListener> {
  $AppEventListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AppEventListener');

  Future<PairedInstance?> $$create(
    $AppEventListener $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $AdWithViewListenerChannel extends TypeChannel<$AdWithViewListener> {
  $AdWithViewListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdWithViewListener');

  Future<PairedInstance?> $$create(
    $AdWithViewListener $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $BannerAdListenerChannel extends TypeChannel<$BannerAdListener> {
  $BannerAdListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.BannerAdListener');

  Future<PairedInstance?> $$create(
    $BannerAdListener $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $AdManagerBannerAdListenerChannel
    extends TypeChannel<$AdManagerBannerAdListener> {
  $AdManagerBannerAdListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdManagerBannerAdListener');

  Future<PairedInstance?> $$create(
    $AdManagerBannerAdListener $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $NativeAdListenerChannel extends TypeChannel<$NativeAdListener> {
  $NativeAdListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.NativeAdListener');

  Future<PairedInstance?> $$create(
    $NativeAdListener $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $FullScreenContentCallbackChannel
    extends TypeChannel<$FullScreenContentCallback> {
  $FullScreenContentCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.FullScreenContentCallback');

  Future<PairedInstance?> $$create(
    $FullScreenContentCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $FullScreenAdLoadCallbackChannel
    extends TypeChannel<$FullScreenAdLoadCallback> {
  $FullScreenAdLoadCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.FullScreenAdLoadCallback');

  Future<PairedInstance?> $$create(
    $FullScreenAdLoadCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $RewardedAdLoadCallbackChannel
    extends TypeChannel<$RewardedAdLoadCallback> {
  $RewardedAdLoadCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RewardedAdLoadCallback');

  Future<PairedInstance?> $$create(
    $RewardedAdLoadCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $InterstitialAdLoadCallbackChannel
    extends TypeChannel<$InterstitialAdLoadCallback> {
  $InterstitialAdLoadCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.InterstitialAdLoadCallback');

  Future<PairedInstance?> $$create(
    $InterstitialAdLoadCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $AdManagerInterstitialAdLoadCallbackChannel
    extends TypeChannel<$AdManagerInterstitialAdLoadCallback> {
  $AdManagerInterstitialAdLoadCallbackChannel(TypeChannelMessenger messenger)
      : super(
            messenger, 'google_mobile_ads.AdManagerInterstitialAdLoadCallback');

  Future<PairedInstance?> $$create(
    $AdManagerInterstitialAdLoadCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }
}

class $AppEventListenerHandler
    implements TypeChannelHandler<$AppEventListener> {
  $AppEventListener $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  dynamic $onAppEvent(
    $AppEventListener $instance,
    String name,
    String data,
  ) {
    return $instance.onAppEvent(
      name,
      data,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $AppEventListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AppEventListener instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
      case 'onAppEvent':
        return $onAppEvent(
          instance,
          arguments[0] as String,
          arguments[1] as String,
        );
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $AdWithViewListenerHandler
    implements TypeChannelHandler<$AdWithViewListener> {
  $AdWithViewListener $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  dynamic $onAdLoaded(
    $AdWithViewListener $instance,
  ) {
    return $instance.onAdLoaded();
  }

  dynamic $onAdFailedToLoad(
    $AdWithViewListener $instance,
    LoadAdError error,
  ) {
    return $instance.onAdFailedToLoad(
      error,
    );
  }

  dynamic $onAdOpened(
    $AdWithViewListener $instance,
  ) {
    return $instance.onAdOpened();
  }

  dynamic $onAdWillDismissScreen(
    $AdWithViewListener $instance,
  ) {
    return $instance.onAdWillDismissScreen();
  }

  dynamic $onAdClosed(
    $AdWithViewListener $instance,
  ) {
    return $instance.onAdClosed();
  }

  dynamic $onAdImpression(
    $AdWithViewListener $instance,
  ) {
    return $instance.onAdImpression();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $AdWithViewListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdWithViewListener instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
      case 'onAdLoaded':
        return $onAdLoaded(
          instance,
        );

      case 'onAdFailedToLoad':
        return $onAdFailedToLoad(
          instance,
          arguments[0] as LoadAdError,
        );

      case 'onAdOpened':
        return $onAdOpened(
          instance,
        );

      case 'onAdWillDismissScreen':
        return $onAdWillDismissScreen(
          instance,
        );

      case 'onAdClosed':
        return $onAdClosed(
          instance,
        );

      case 'onAdImpression':
        return $onAdImpression(
          instance,
        );
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $BannerAdListenerHandler
    implements TypeChannelHandler<$BannerAdListener> {
  $BannerAdListener $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $BannerAdListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $BannerAdListener instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $AdManagerBannerAdListenerHandler
    implements TypeChannelHandler<$AdManagerBannerAdListener> {
  $AdManagerBannerAdListener $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $AdManagerBannerAdListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdManagerBannerAdListener instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $NativeAdListenerHandler
    implements TypeChannelHandler<$NativeAdListener> {
  $NativeAdListener $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  dynamic $onAdClicked(
    $NativeAdListener $instance,
  ) {
    return $instance.onAdClicked();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $NativeAdListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $NativeAdListener instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
      case 'onAdClicked':
        return $onAdClicked(
          instance,
        );
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $FullScreenContentCallbackHandler
    implements TypeChannelHandler<$FullScreenContentCallback> {
  $FullScreenContentCallback $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  dynamic $onAdShowedFullScreenContent(
    $FullScreenContentCallback $instance,
  ) {
    return $instance.onAdShowedFullScreenContent();
  }

  dynamic $onAdDismissedFullScreenContent(
    $FullScreenContentCallback $instance,
  ) {
    return $instance.onAdDismissedFullScreenContent();
  }

  dynamic $onAdWillDismissFullScreenContent(
    $FullScreenContentCallback $instance,
  ) {
    return $instance.onAdWillDismissFullScreenContent();
  }

  dynamic $onAdImpression(
    $FullScreenContentCallback $instance,
  ) {
    return $instance.onAdImpression();
  }

  dynamic $onAdFailedToShowFullScreenContent(
    $FullScreenContentCallback $instance,
  ) {
    return $instance.onAdFailedToShowFullScreenContent();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $FullScreenContentCallback createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $FullScreenContentCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
      case 'onAdShowedFullScreenContent':
        return $onAdShowedFullScreenContent(
          instance,
        );

      case 'onAdDismissedFullScreenContent':
        return $onAdDismissedFullScreenContent(
          instance,
        );

      case 'onAdWillDismissFullScreenContent':
        return $onAdWillDismissFullScreenContent(
          instance,
        );

      case 'onAdImpression':
        return $onAdImpression(
          instance,
        );

      case 'onAdFailedToShowFullScreenContent':
        return $onAdFailedToShowFullScreenContent(
          instance,
        );
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $FullScreenAdLoadCallbackHandler
    implements TypeChannelHandler<$FullScreenAdLoadCallback> {
  $FullScreenAdLoadCallback $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  dynamic $onAdLoaded(
    $FullScreenAdLoadCallback $instance,
  ) {
    return $instance.onAdLoaded();
  }

  dynamic $onAdFailedToLoad(
    $FullScreenAdLoadCallback $instance,
    LoadAdError error,
  ) {
    return $instance.onAdFailedToLoad(
      error,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $FullScreenAdLoadCallback createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $FullScreenAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
      case 'onAdLoaded':
        return $onAdLoaded(
          instance,
        );

      case 'onAdFailedToLoad':
        return $onAdFailedToLoad(
          instance,
          arguments[0] as LoadAdError,
        );
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $RewardedAdLoadCallbackHandler
    implements TypeChannelHandler<$RewardedAdLoadCallback> {
  $RewardedAdLoadCallback $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $RewardedAdLoadCallback createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $RewardedAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $InterstitialAdLoadCallbackHandler
    implements TypeChannelHandler<$InterstitialAdLoadCallback> {
  $InterstitialAdLoadCallback $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $InterstitialAdLoadCallback createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $InterstitialAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $AdManagerInterstitialAdLoadCallbackHandler
    implements TypeChannelHandler<$AdManagerInterstitialAdLoadCallback> {
  $AdManagerInterstitialAdLoadCallback $$create(
    TypeChannelMessenger messenger,
  ) {
    throw UnimplementedError();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      methodName,
      'methodName',
      'Unable to invoke static method `$methodName`',
    );
  }

  @override
  $AdManagerInterstitialAdLoadCallback createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdManagerInterstitialAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    switch (methodName) {
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $LibraryImplementations {
  $LibraryImplementations(this.messenger);

  final TypeChannelMessenger messenger;

  $AppEventListenerChannel get channelAppEventListener =>
      $AppEventListenerChannel(messenger);
  $AppEventListenerHandler get handlerAppEventListener =>
      $AppEventListenerHandler();

  $AdWithViewListenerChannel get channelAdWithViewListener =>
      $AdWithViewListenerChannel(messenger);
  $AdWithViewListenerHandler get handlerAdWithViewListener =>
      $AdWithViewListenerHandler();

  $BannerAdListenerChannel get channelBannerAdListener =>
      $BannerAdListenerChannel(messenger);
  $BannerAdListenerHandler get handlerBannerAdListener =>
      $BannerAdListenerHandler();

  $AdManagerBannerAdListenerChannel get channelAdManagerBannerAdListener =>
      $AdManagerBannerAdListenerChannel(messenger);
  $AdManagerBannerAdListenerHandler get handlerAdManagerBannerAdListener =>
      $AdManagerBannerAdListenerHandler();

  $NativeAdListenerChannel get channelNativeAdListener =>
      $NativeAdListenerChannel(messenger);
  $NativeAdListenerHandler get handlerNativeAdListener =>
      $NativeAdListenerHandler();

  $FullScreenContentCallbackChannel get channelFullScreenContentCallback =>
      $FullScreenContentCallbackChannel(messenger);
  $FullScreenContentCallbackHandler get handlerFullScreenContentCallback =>
      $FullScreenContentCallbackHandler();

  $FullScreenAdLoadCallbackChannel get channelFullScreenAdLoadCallback =>
      $FullScreenAdLoadCallbackChannel(messenger);
  $FullScreenAdLoadCallbackHandler get handlerFullScreenAdLoadCallback =>
      $FullScreenAdLoadCallbackHandler();

  $RewardedAdLoadCallbackChannel get channelRewardedAdLoadCallback =>
      $RewardedAdLoadCallbackChannel(messenger);
  $RewardedAdLoadCallbackHandler get handlerRewardedAdLoadCallback =>
      $RewardedAdLoadCallbackHandler();

  $InterstitialAdLoadCallbackChannel get channelInterstitialAdLoadCallback =>
      $InterstitialAdLoadCallbackChannel(messenger);
  $InterstitialAdLoadCallbackHandler get handlerInterstitialAdLoadCallback =>
      $InterstitialAdLoadCallbackHandler();

  $AdManagerInterstitialAdLoadCallbackChannel
      get channelAdManagerInterstitialAdLoadCallback =>
          $AdManagerInterstitialAdLoadCallbackChannel(messenger);
  $AdManagerInterstitialAdLoadCallbackHandler
      get handlerAdManagerInterstitialAdLoadCallback =>
          $AdManagerInterstitialAdLoadCallbackHandler();
}

class $ChannelRegistrar {
  $ChannelRegistrar(this.implementations);

  final $LibraryImplementations implementations;

  void registerHandlers() {
    implementations.channelAppEventListener.setHandler(
      implementations.handlerAppEventListener,
    );

    implementations.channelAdWithViewListener.setHandler(
      implementations.handlerAdWithViewListener,
    );

    implementations.channelBannerAdListener.setHandler(
      implementations.handlerBannerAdListener,
    );

    implementations.channelAdManagerBannerAdListener.setHandler(
      implementations.handlerAdManagerBannerAdListener,
    );

    implementations.channelNativeAdListener.setHandler(
      implementations.handlerNativeAdListener,
    );

    implementations.channelFullScreenContentCallback.setHandler(
      implementations.handlerFullScreenContentCallback,
    );

    implementations.channelFullScreenAdLoadCallback.setHandler(
      implementations.handlerFullScreenAdLoadCallback,
    );

    implementations.channelRewardedAdLoadCallback.setHandler(
      implementations.handlerRewardedAdLoadCallback,
    );

    implementations.channelInterstitialAdLoadCallback.setHandler(
      implementations.handlerInterstitialAdLoadCallback,
    );

    implementations.channelAdManagerInterstitialAdLoadCallback.setHandler(
      implementations.handlerAdManagerInterstitialAdLoadCallback,
    );
  }

  void unregisterHandlers() {
    implementations.channelAppEventListener.removeHandler();

    implementations.channelAdWithViewListener.removeHandler();

    implementations.channelBannerAdListener.removeHandler();

    implementations.channelAdManagerBannerAdListener.removeHandler();

    implementations.channelNativeAdListener.removeHandler();

    implementations.channelFullScreenContentCallback.removeHandler();

    implementations.channelFullScreenAdLoadCallback.removeHandler();

    implementations.channelRewardedAdLoadCallback.removeHandler();

    implementations.channelInterstitialAdLoadCallback.removeHandler();

    implementations.channelAdManagerInterstitialAdLoadCallback.removeHandler();
  }
}
