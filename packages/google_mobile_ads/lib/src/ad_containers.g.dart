// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:reference/reference.dart';

import 'ad_listeners.dart';

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

mixin $AdError {}

mixin $ResponseInfo {}

mixin $AdapterResponseInfo {}

mixin $LoadAdError {}

mixin $AdRequest {}

mixin $AdManagerAdRequest {}

mixin $AdSize {}

mixin $BannerAd {}

mixin $AdManagerBannerAd {}

mixin $NativeAd {}

mixin $InterstitialAd {}

mixin $AdManagerInterstitialAd {}

mixin $RewardedAd {}

mixin $RewardItem {}

mixin $ServerSideVerificationOptions {}

class $AdErrorChannel extends TypeChannel<$AdError> {
  $AdErrorChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdError');

  Future<PairedInstance?> $$create(
    $AdError $instance, {
    required bool $owner,
    required int code,
    required String domain,
    required String message,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        code,
        domain,
        message,
      ],
      owner: $owner,
    );
  }
}

class $ResponseInfoChannel extends TypeChannel<$ResponseInfo> {
  $ResponseInfoChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.ResponseInfo');

  Future<PairedInstance?> $$create(
    $ResponseInfo $instance, {
    required bool $owner,
    required String? responseId,
    required String? mediationAdapterClassName,
    required List<$AdapterResponseInfo>? adapterResponses,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        responseId,
        mediationAdapterClassName,
        adapterResponses,
      ],
      owner: $owner,
    );
  }
}

class $AdapterResponseInfoChannel extends TypeChannel<$AdapterResponseInfo> {
  $AdapterResponseInfoChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdapterResponseInfo');

  Future<PairedInstance?> $$create(
    $AdapterResponseInfo $instance, {
    required bool $owner,
    required String adapterClassName,
    required int latencyMillis,
    required String description,
    required String credentials,
    required $AdError? adError,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        adapterClassName,
        latencyMillis,
        description,
        credentials,
        adError,
      ],
      owner: $owner,
    );
  }
}

class $LoadAdErrorChannel extends TypeChannel<$LoadAdError> {
  $LoadAdErrorChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.LoadAdError');

  Future<PairedInstance?> $$create(
    $LoadAdError $instance, {
    required bool $owner,
    required int code,
    required String domain,
    required String message,
    required $ResponseInfo? responseInfo,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        code,
        domain,
        message,
        responseInfo,
      ],
      owner: $owner,
    );
  }
}

class $AdRequestChannel extends TypeChannel<$AdRequest> {
  $AdRequestChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdRequest');

  Future<PairedInstance?> $$create(
    $AdRequest $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> $addKeyword(
    $AdRequest $instance,
    String keyword,
  ) {
    return sendInvokeMethod(
      $instance,
      'addKeyword',
      <Object?>[
        keyword,
      ],
    );
  }

  Future<Object?> $setContentUrl(
    $AdRequest $instance,
    String url,
  ) {
    return sendInvokeMethod(
      $instance,
      'setContentUrl',
      <Object?>[
        url,
      ],
    );
  }

  Future<Object?> $setNonPersonalizedAds(
    $AdRequest $instance,
    bool nonPersonalizedAds,
  ) {
    return sendInvokeMethod(
      $instance,
      'setNonPersonalizedAds',
      <Object?>[
        nonPersonalizedAds,
      ],
    );
  }
}

class $AdManagerAdRequestChannel extends TypeChannel<$AdManagerAdRequest> {
  $AdManagerAdRequestChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdRequest');

  Future<PairedInstance?> $$create(
    $AdManagerAdRequest $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> $addCustomTargeting(
    $AdManagerAdRequest $instance,
    String key,
    String value,
  ) {
    return sendInvokeMethod(
      $instance,
      'addCustomTargeting',
      <Object?>[
        key,
        value,
      ],
    );
  }

  Future<Object?> $addCustomTargetingList(
    $AdManagerAdRequest $instance,
    String key,
    List<String> values,
  ) {
    return sendInvokeMethod(
      $instance,
      'addCustomTargetingList',
      <Object?>[
        key,
        values,
      ],
    );
  }
}

class $AdSizeChannel extends TypeChannel<$AdSize> {
  $AdSizeChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdSize');

  Future<PairedInstance?> $$create(
    $AdSize $instance, {
    required bool $owner,
    required int width,
    required int height,
    required String? constant,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        width,
        height,
        constant,
      ],
      owner: $owner,
    );
  }

  Future<Object?> $getPortraitAnchoredAdaptiveBannerAdSize(
    int width,
  ) {
    return sendInvokeStaticMethod(
      'getPortraitAnchoredAdaptiveBannerAdSize',
      <Object?>[
        width,
      ],
    );
  }

  Future<Object?> $getLandscapeAnchoredAdaptiveBannerAdSize(
    int width,
  ) {
    return sendInvokeStaticMethod(
      'getLandscapeAnchoredAdaptiveBannerAdSize',
      <Object?>[
        width,
      ],
    );
  }
}

class $BannerAdChannel extends TypeChannel<$BannerAd> {
  $BannerAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.BannerAd');

  Future<PairedInstance?> $$create(
    $BannerAd $instance, {
    required bool $owner,
    required $AdSize size,
    required String adUnitId,
    required BannerAdListener listener,
    required $AdRequest request,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        size,
        adUnitId,
        listener,
        request,
      ],
      owner: $owner,
    );
  }

  Future<Object?> $load(
    $BannerAd $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      'load',
      <Object?>[],
    );
  }
}

class $AdManagerBannerAdChannel extends TypeChannel<$AdManagerBannerAd> {
  $AdManagerBannerAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdManagerBannerAd');

  Future<PairedInstance?> $$create(
    $AdManagerBannerAd $instance, {
    required bool $owner,
    required List<$AdSize> sizes,
    required String adUnitId,
    required AdManagerBannerAdListener listener,
    required $AdManagerAdRequest request,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        sizes,
        adUnitId,
        listener,
        request,
      ],
      owner: $owner,
    );
  }

  Future<Object?> $load(
    $AdManagerBannerAd $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      'load',
      <Object?>[],
    );
  }
}

class $NativeAdChannel extends TypeChannel<$NativeAd> {
  $NativeAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.NativeAd');

  Future<PairedInstance?> $$create(
    $NativeAd $instance, {
    required bool $owner,
    required String adUnitId,
    required String factoryId,
    required NativeAdListener listener,
    required $AdRequest request,
    required Map<String, Object>? customOptions,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        adUnitId,
        factoryId,
        listener,
        request,
        customOptions,
      ],
      owner: $owner,
    );
  }

  Future<Object?> $load(
    $NativeAd $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      'load',
      <Object?>[],
    );
  }
}

class $InterstitialAdChannel extends TypeChannel<$InterstitialAd> {
  $InterstitialAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.InterstitialAd');

  Future<PairedInstance?> $$create(
    $InterstitialAd $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> $load(
    String adUnitId,
    $AdRequest request,
    InterstitialAdLoadCallback adLoadCallback,
    FullScreenContentCallback? fullScreenContentCallback,
  ) {
    return sendInvokeStaticMethod(
      'load',
      <Object?>[
        adUnitId,
        request,
        adLoadCallback,
        fullScreenContentCallback,
      ],
    );
  }

  Future<Object?> $show(
    $InterstitialAd $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      'show',
      <Object?>[],
    );
  }
}

class $AdManagerInterstitialAdChannel
    extends TypeChannel<$AdManagerInterstitialAd> {
  $AdManagerInterstitialAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdManagerInterstitialAd');

  Future<PairedInstance?> $$create(
    $AdManagerInterstitialAd $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> $load(
    String adUnitId,
    $AdManagerAdRequest request,
    AdManagerInterstitialAdLoadCallback adLoadCallback,
    AppEventListener? appEventListener,
    FullScreenContentCallback? fullScreenContentCallback,
  ) {
    return sendInvokeStaticMethod(
      'load',
      <Object?>[
        adUnitId,
        request,
        adLoadCallback,
        appEventListener,
        fullScreenContentCallback,
      ],
    );
  }

  Future<Object?> $show(
    $AdManagerInterstitialAd $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      'show',
      <Object?>[],
    );
  }
}

class $RewardedAdChannel extends TypeChannel<$RewardedAd> {
  $RewardedAdChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RewardedAd');

  Future<PairedInstance?> $$create(
    $RewardedAd $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> $load(
    String adUnitId,
    $AdRequest request,
    RewardedAdLoadCallback rewardedAdLoadCallback,
    $ServerSideVerificationOptions? serverSideVerificationOptions,
    FullScreenContentCallback? fullScreenContentCallback,
  ) {
    return sendInvokeStaticMethod(
      'load',
      <Object?>[
        adUnitId,
        request,
        rewardedAdLoadCallback,
        serverSideVerificationOptions,
        fullScreenContentCallback,
      ],
    );
  }

  Future<Object?> $show(
    $RewardedAd $instance,
    dynamic onUserEarnedReward,
  ) {
    return sendInvokeMethod(
      $instance,
      'show',
      <Object?>[
        onUserEarnedReward,
      ],
    );
  }
}

class $RewardItemChannel extends TypeChannel<$RewardItem> {
  $RewardItemChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RewardItem');

  Future<PairedInstance?> $$create(
    $RewardItem $instance, {
    required bool $owner,
    required num amount,
    required String type,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        amount,
        type,
      ],
      owner: $owner,
    );
  }
}

class $ServerSideVerificationOptionsChannel
    extends TypeChannel<$ServerSideVerificationOptions> {
  $ServerSideVerificationOptionsChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.ServerSideVerificationOptions');

  Future<PairedInstance?> $$create(
    $ServerSideVerificationOptions $instance, {
    required bool $owner,
    required String? userId,
    required String? customData,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        userId,
        customData,
      ],
      owner: $owner,
    );
  }
}

class $AdErrorHandler implements TypeChannelHandler<$AdError> {
  $AdError $$create(
    TypeChannelMessenger messenger,
    int code,
    String domain,
    String message,
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
  $AdError createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as int,
      arguments[1] as String,
      arguments[2] as String,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdError instance,
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

class $ResponseInfoHandler implements TypeChannelHandler<$ResponseInfo> {
  $ResponseInfo $$create(
    TypeChannelMessenger messenger,
    String? responseId,
    String? mediationAdapterClassName,
    List<$AdapterResponseInfo>? adapterResponses,
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
  $ResponseInfo createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as String?,
      arguments[1] as String?,
      arguments[2] as List<$AdapterResponseInfo>?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $ResponseInfo instance,
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

class $AdapterResponseInfoHandler
    implements TypeChannelHandler<$AdapterResponseInfo> {
  $AdapterResponseInfo $$create(
    TypeChannelMessenger messenger,
    String adapterClassName,
    int latencyMillis,
    String description,
    String credentials,
    $AdError? adError,
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
  $AdapterResponseInfo createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as String,
      arguments[1] as int,
      arguments[2] as String,
      arguments[3] as String,
      arguments[4] as $AdError?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdapterResponseInfo instance,
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

class $LoadAdErrorHandler implements TypeChannelHandler<$LoadAdError> {
  $LoadAdError $$create(
    TypeChannelMessenger messenger,
    int code,
    String domain,
    String message,
    $ResponseInfo? responseInfo,
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
  $LoadAdError createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as int,
      arguments[1] as String,
      arguments[2] as String,
      arguments[3] as $ResponseInfo?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $LoadAdError instance,
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

class $AdRequestHandler implements TypeChannelHandler<$AdRequest> {
  $AdRequest $$create(
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
  $AdRequest createInstance(
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
    $AdRequest instance,
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

class $AdManagerAdRequestHandler
    implements TypeChannelHandler<$AdManagerAdRequest> {
  $AdManagerAdRequest $$create(
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
  $AdManagerAdRequest createInstance(
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
    $AdManagerAdRequest instance,
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

class $AdSizeHandler implements TypeChannelHandler<$AdSize> {
  $AdSize $$create(
    TypeChannelMessenger messenger,
    int width,
    int height,
    String? constant,
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
  $AdSize createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as int,
      arguments[1] as int,
      arguments[2] as String?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdSize instance,
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

class $BannerAdHandler implements TypeChannelHandler<$BannerAd> {
  $BannerAd $$create(
    TypeChannelMessenger messenger,
    $AdSize size,
    String adUnitId,
    BannerAdListener listener,
    $AdRequest request,
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
  $BannerAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $AdSize,
      arguments[1] as String,
      arguments[2] as BannerAdListener,
      arguments[3] as $AdRequest,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $BannerAd instance,
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

class $AdManagerBannerAdHandler
    implements TypeChannelHandler<$AdManagerBannerAd> {
  $AdManagerBannerAd $$create(
    TypeChannelMessenger messenger,
    List<$AdSize> sizes,
    String adUnitId,
    AdManagerBannerAdListener listener,
    $AdManagerAdRequest request,
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
  $AdManagerBannerAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as List<$AdSize>,
      arguments[1] as String,
      arguments[2] as AdManagerBannerAdListener,
      arguments[3] as $AdManagerAdRequest,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdManagerBannerAd instance,
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

class $NativeAdHandler implements TypeChannelHandler<$NativeAd> {
  $NativeAd $$create(
    TypeChannelMessenger messenger,
    String adUnitId,
    String factoryId,
    NativeAdListener listener,
    $AdRequest request,
    Map<String, Object>? customOptions,
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
  $NativeAd createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as String,
      arguments[1] as String,
      arguments[2] as NativeAdListener,
      arguments[3] as $AdRequest,
      arguments[4] as Map<String, Object>?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $NativeAd instance,
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

class $InterstitialAdHandler implements TypeChannelHandler<$InterstitialAd> {
  $InterstitialAd $$create(
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
  $InterstitialAd createInstance(
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
    $InterstitialAd instance,
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

class $AdManagerInterstitialAdHandler
    implements TypeChannelHandler<$AdManagerInterstitialAd> {
  $AdManagerInterstitialAd $$create(
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
  $AdManagerInterstitialAd createInstance(
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
    $AdManagerInterstitialAd instance,
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

class $RewardedAdHandler implements TypeChannelHandler<$RewardedAd> {
  $RewardedAd $$create(
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
  $RewardedAd createInstance(
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
    $RewardedAd instance,
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

class $RewardItemHandler implements TypeChannelHandler<$RewardItem> {
  $RewardItem $$create(
    TypeChannelMessenger messenger,
    num amount,
    String type,
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
  $RewardItem createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as num,
      arguments[1] as String,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $RewardItem instance,
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

class $ServerSideVerificationOptionsHandler
    implements TypeChannelHandler<$ServerSideVerificationOptions> {
  $ServerSideVerificationOptions $$create(
    TypeChannelMessenger messenger,
    String? userId,
    String? customData,
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
  $ServerSideVerificationOptions createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as String?,
      arguments[1] as String?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $ServerSideVerificationOptions instance,
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

  $AdErrorChannel get channelAdError => $AdErrorChannel(messenger);
  $AdErrorHandler get handlerAdError => $AdErrorHandler();

  $ResponseInfoChannel get channelResponseInfo =>
      $ResponseInfoChannel(messenger);
  $ResponseInfoHandler get handlerResponseInfo => $ResponseInfoHandler();

  $AdapterResponseInfoChannel get channelAdapterResponseInfo =>
      $AdapterResponseInfoChannel(messenger);
  $AdapterResponseInfoHandler get handlerAdapterResponseInfo =>
      $AdapterResponseInfoHandler();

  $LoadAdErrorChannel get channelLoadAdError => $LoadAdErrorChannel(messenger);
  $LoadAdErrorHandler get handlerLoadAdError => $LoadAdErrorHandler();

  $AdRequestChannel get channelAdRequest => $AdRequestChannel(messenger);
  $AdRequestHandler get handlerAdRequest => $AdRequestHandler();

  $AdManagerAdRequestChannel get channelAdManagerAdRequest =>
      $AdManagerAdRequestChannel(messenger);
  $AdManagerAdRequestHandler get handlerAdManagerAdRequest =>
      $AdManagerAdRequestHandler();

  $AdSizeChannel get channelAdSize => $AdSizeChannel(messenger);
  $AdSizeHandler get handlerAdSize => $AdSizeHandler();

  $BannerAdChannel get channelBannerAd => $BannerAdChannel(messenger);
  $BannerAdHandler get handlerBannerAd => $BannerAdHandler();

  $AdManagerBannerAdChannel get channelAdManagerBannerAd =>
      $AdManagerBannerAdChannel(messenger);
  $AdManagerBannerAdHandler get handlerAdManagerBannerAd =>
      $AdManagerBannerAdHandler();

  $NativeAdChannel get channelNativeAd => $NativeAdChannel(messenger);
  $NativeAdHandler get handlerNativeAd => $NativeAdHandler();

  $InterstitialAdChannel get channelInterstitialAd =>
      $InterstitialAdChannel(messenger);
  $InterstitialAdHandler get handlerInterstitialAd => $InterstitialAdHandler();

  $AdManagerInterstitialAdChannel get channelAdManagerInterstitialAd =>
      $AdManagerInterstitialAdChannel(messenger);
  $AdManagerInterstitialAdHandler get handlerAdManagerInterstitialAd =>
      $AdManagerInterstitialAdHandler();

  $RewardedAdChannel get channelRewardedAd => $RewardedAdChannel(messenger);
  $RewardedAdHandler get handlerRewardedAd => $RewardedAdHandler();

  $RewardItemChannel get channelRewardItem => $RewardItemChannel(messenger);
  $RewardItemHandler get handlerRewardItem => $RewardItemHandler();

  $ServerSideVerificationOptionsChannel
      get channelServerSideVerificationOptions =>
          $ServerSideVerificationOptionsChannel(messenger);
  $ServerSideVerificationOptionsHandler
      get handlerServerSideVerificationOptions =>
          $ServerSideVerificationOptionsHandler();
}

class $ChannelRegistrar {
  $ChannelRegistrar(this.implementations);

  final $LibraryImplementations implementations;

  void registerHandlers() {
    implementations.channelAdError.setHandler(
      implementations.handlerAdError,
    );

    implementations.channelResponseInfo.setHandler(
      implementations.handlerResponseInfo,
    );

    implementations.channelAdapterResponseInfo.setHandler(
      implementations.handlerAdapterResponseInfo,
    );

    implementations.channelLoadAdError.setHandler(
      implementations.handlerLoadAdError,
    );

    implementations.channelAdRequest.setHandler(
      implementations.handlerAdRequest,
    );

    implementations.channelAdManagerAdRequest.setHandler(
      implementations.handlerAdManagerAdRequest,
    );

    implementations.channelAdSize.setHandler(
      implementations.handlerAdSize,
    );

    implementations.channelBannerAd.setHandler(
      implementations.handlerBannerAd,
    );

    implementations.channelAdManagerBannerAd.setHandler(
      implementations.handlerAdManagerBannerAd,
    );

    implementations.channelNativeAd.setHandler(
      implementations.handlerNativeAd,
    );

    implementations.channelInterstitialAd.setHandler(
      implementations.handlerInterstitialAd,
    );

    implementations.channelAdManagerInterstitialAd.setHandler(
      implementations.handlerAdManagerInterstitialAd,
    );

    implementations.channelRewardedAd.setHandler(
      implementations.handlerRewardedAd,
    );

    implementations.channelRewardItem.setHandler(
      implementations.handlerRewardItem,
    );

    implementations.channelServerSideVerificationOptions.setHandler(
      implementations.handlerServerSideVerificationOptions,
    );
  }

  void unregisterHandlers() {
    implementations.channelAdError.removeHandler();

    implementations.channelResponseInfo.removeHandler();

    implementations.channelAdapterResponseInfo.removeHandler();

    implementations.channelLoadAdError.removeHandler();

    implementations.channelAdRequest.removeHandler();

    implementations.channelAdManagerAdRequest.removeHandler();

    implementations.channelAdSize.removeHandler();

    implementations.channelBannerAd.removeHandler();

    implementations.channelAdManagerBannerAd.removeHandler();

    implementations.channelNativeAd.removeHandler();

    implementations.channelInterstitialAd.removeHandler();

    implementations.channelAdManagerInterstitialAd.removeHandler();

    implementations.channelRewardedAd.removeHandler();

    implementations.channelRewardItem.removeHandler();

    implementations.channelServerSideVerificationOptions.removeHandler();
  }
}
