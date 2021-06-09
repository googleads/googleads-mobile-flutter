// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:reference/reference.dart';

import 'ad_containers.dart';

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

class _FunctionHolder {
  late Function function;
}

typedef $UserEarnedRewardCallback = dynamic Function(
  RewardItem reward,
);

typedef $AppEventCallback = dynamic Function(
  String name,
  String data,
);

typedef $AdVoidCallback = dynamic Function();

typedef $InterstitialAdLoadCallback = dynamic Function(
  InterstitialAd ad,
);

typedef $AdManagerInterstitialAdLoadCallback = dynamic Function(
  AdManagerInterstitialAd ad,
);

typedef $RewardedAdLoadCallback = dynamic Function(
  RewardedAd ad,
);

typedef $LoadFailCallback = dynamic Function(
  LoadAdError error,
);

class $UserEarnedRewardCallbackChannel extends TypeChannel<Object> {
  $UserEarnedRewardCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.UserEarnedRewardCallback');

  Future<PairedInstance?> $$create(
    $UserEarnedRewardCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> _invoke(
    _FunctionHolder $instance,
    RewardItem reward,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[
        reward,
      ],
    );
  }
}

class $AppEventCallbackChannel extends TypeChannel<Object> {
  $AppEventCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AppEventCallback');

  Future<PairedInstance?> $$create(
    $AppEventCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> _invoke(
    _FunctionHolder $instance,
    String name,
    String data,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[
        name,
        data,
      ],
    );
  }
}

class $AdVoidCallbackChannel extends TypeChannel<Object> {
  $AdVoidCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdVoidCallback');

  Future<PairedInstance?> $$create(
    $AdVoidCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> _invoke(
    _FunctionHolder $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[],
    );
  }
}

class $InterstitialAdLoadCallbackChannel extends TypeChannel<Object> {
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

  Future<Object?> _invoke(
    _FunctionHolder $instance,
    InterstitialAd ad,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[
        ad,
      ],
    );
  }
}

class $AdManagerInterstitialAdLoadCallbackChannel extends TypeChannel<Object> {
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

  Future<Object?> _invoke(
    _FunctionHolder $instance,
    AdManagerInterstitialAd ad,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[
        ad,
      ],
    );
  }
}

class $RewardedAdLoadCallbackChannel extends TypeChannel<Object> {
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

  Future<Object?> _invoke(
    _FunctionHolder $instance,
    RewardedAd ad,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[
        ad,
      ],
    );
  }
}

class $LoadFailCallbackChannel extends TypeChannel<Object> {
  $LoadFailCallbackChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.LoadFailCallback');

  Future<PairedInstance?> $$create(
    $LoadFailCallback $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> _invoke(
    _FunctionHolder $instance,
    LoadAdError error,
  ) {
    return sendInvokeMethod(
      $instance,
      '',
      <Object?>[
        error,
      ],
    );
  }
}

class $UserEarnedRewardCallbackHandler implements TypeChannelHandler<Object> {
  $UserEarnedRewardCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = (
      RewardItem reward,
    ) {
      implementations.channelUserEarnedRewardCallback._invoke(
        functionHolder,
        reward,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $UserEarnedRewardCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance(
      arguments[0] as RewardItem,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

class $AppEventCallbackHandler implements TypeChannelHandler<Object> {
  $AppEventCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = (
      String name,
      String data,
    ) {
      implementations.channelAppEventCallback._invoke(
        functionHolder,
        name,
        data,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $AppEventCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance(
      arguments[0] as String,
      arguments[1] as String,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

class $AdVoidCallbackHandler implements TypeChannelHandler<Object> {
  $AdVoidCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = () {
      implementations.channelAdVoidCallback._invoke(
        functionHolder,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $AdVoidCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance();
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

class $InterstitialAdLoadCallbackHandler implements TypeChannelHandler<Object> {
  $InterstitialAdLoadCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = (
      InterstitialAd ad,
    ) {
      implementations.channelInterstitialAdLoadCallback._invoke(
        functionHolder,
        ad,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $InterstitialAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance(
      arguments[0] as InterstitialAd,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

class $AdManagerInterstitialAdLoadCallbackHandler
    implements TypeChannelHandler<Object> {
  $AdManagerInterstitialAdLoadCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = (
      AdManagerInterstitialAd ad,
    ) {
      implementations.channelAdManagerInterstitialAdLoadCallback._invoke(
        functionHolder,
        ad,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $AdManagerInterstitialAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance(
      arguments[0] as AdManagerInterstitialAd,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

class $RewardedAdLoadCallbackHandler implements TypeChannelHandler<Object> {
  $RewardedAdLoadCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = (
      RewardedAd ad,
    ) {
      implementations.channelRewardedAdLoadCallback._invoke(
        functionHolder,
        ad,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $RewardedAdLoadCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance(
      arguments[0] as RewardedAd,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

class $LoadFailCallbackHandler implements TypeChannelHandler<Object> {
  $LoadFailCallbackHandler(this.implementations);

  final $LibraryImplementations implementations;

  @override
  _FunctionHolder createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    final _FunctionHolder functionHolder = _FunctionHolder();
    functionHolder.function = (
      LoadAdError error,
    ) {
      implementations.channelLoadFailCallback._invoke(
        functionHolder,
        error,
      );
    };
    return functionHolder;
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    covariant $LoadFailCallback instance,
    String methodName,
    List<Object?> arguments,
  ) {
    return instance(
      arguments[0] as LoadAdError,
    );
  }

  @override
  Object? invokeStaticMethod(
    TypeChannelMessenger messenger,
    String methodName,
    List<Object?> arguments,
  ) {
    throw UnimplementedError();
  }
}

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

mixin $OnUserEarnedRewardListener {}

mixin $AppEventListener {}

mixin $BannerAdListener {}

mixin $AdManagerBannerAdListener {}

mixin $NativeAdListener {}

mixin $FullScreenContentListener {}

mixin $InterstitialAdLoadListener {}

mixin $AdManagerInterstitialAdLoadListener {}

mixin $RewardedAdLoadListener {}

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
      : super(messenger, 'google_mobile_ads.AdManagerAdRequest');

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
    required $BannerAdListener listener,
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
    required $AdManagerBannerAdListener listener,
    required $AdManagerAdRequest request,
    required $AppEventListener? appEventListener,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        sizes,
        adUnitId,
        listener,
        request,
        appEventListener,
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
    required $NativeAdListener listener,
    required $AdRequest request,
    required Map? customOptions,
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
    $InterstitialAdLoadListener listener,
  ) {
    return sendInvokeStaticMethod(
      'load',
      <Object?>[
        adUnitId,
        request,
        listener,
      ],
    );
  }

  Future<Object?> $show(
    $InterstitialAd $instance,
    $FullScreenContentListener? fullScreenContentListener,
  ) {
    return sendInvokeMethod(
      $instance,
      'show',
      <Object?>[
        fullScreenContentListener,
      ],
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
    $AdManagerInterstitialAdLoadListener listener,
  ) {
    return sendInvokeStaticMethod(
      'load',
      <Object?>[
        adUnitId,
        request,
        listener,
      ],
    );
  }

  Future<Object?> $show(
    $AdManagerInterstitialAd $instance,
    $AppEventListener? appEventListener,
    $FullScreenContentListener? fullScreenContentListener,
  ) {
    return sendInvokeMethod(
      $instance,
      'show',
      <Object?>[
        appEventListener,
        fullScreenContentListener,
      ],
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
    $RewardedAdLoadListener listener,
  ) {
    return sendInvokeStaticMethod(
      'load',
      <Object?>[
        adUnitId,
        request,
        listener,
      ],
    );
  }

  Future<Object?> $show(
    $RewardedAd $instance,
    $OnUserEarnedRewardListener onUserEarnedReward,
    $ServerSideVerificationOptions? serverSideVerificationOptions,
    $FullScreenContentListener? fullScreenContentListener,
  ) {
    return sendInvokeMethod(
      $instance,
      'show',
      <Object?>[
        onUserEarnedReward,
        serverSideVerificationOptions,
        fullScreenContentListener,
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

class $OnUserEarnedRewardListenerChannel
    extends TypeChannel<$OnUserEarnedRewardListener> {
  $OnUserEarnedRewardListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.OnUserEarnedRewardListener');

  Future<PairedInstance?> $$create(
    $OnUserEarnedRewardListener $instance, {
    required bool $owner,
    required $UserEarnedRewardCallback onUserEarnedRewardCallback,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onUserEarnedRewardCallback,
      ],
      owner: $owner,
    );
  }
}

class $AppEventListenerChannel extends TypeChannel<$AppEventListener> {
  $AppEventListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AppEventListener');

  Future<PairedInstance?> $$create(
    $AppEventListener $instance, {
    required bool $owner,
    required $AppEventCallback onAppEvent,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAppEvent,
      ],
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
    required $AdVoidCallback onAdLoaded,
    required $LoadFailCallback? onAdFailedToLoad,
    required $AdVoidCallback? onAdOpened,
    required $AdVoidCallback? onAdWillDismissScreen,
    required $AdVoidCallback? onAdClosed,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdLoaded,
        onAdFailedToLoad,
        onAdOpened,
        onAdWillDismissScreen,
        onAdClosed,
      ],
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
    required $AdVoidCallback onAdLoaded,
    required $LoadFailCallback? onAdFailedToLoad,
    required $AdVoidCallback? onAdOpened,
    required $AdVoidCallback? onAdWillDismissScreen,
    required $AdVoidCallback? onAdClosed,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdLoaded,
        onAdFailedToLoad,
        onAdOpened,
        onAdWillDismissScreen,
        onAdClosed,
      ],
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
    required $AdVoidCallback onAdLoaded,
    required $LoadFailCallback? onAdFailedToLoad,
    required $AdVoidCallback? onAdOpened,
    required $AdVoidCallback? onAdWillDismissScreen,
    required $AdVoidCallback? onAdImpression,
    required $AdVoidCallback? onAdClosed,
    required $AdVoidCallback? onAdClicked,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdLoaded,
        onAdFailedToLoad,
        onAdOpened,
        onAdWillDismissScreen,
        onAdImpression,
        onAdClosed,
        onAdClicked,
      ],
      owner: $owner,
    );
  }
}

class $FullScreenContentListenerChannel
    extends TypeChannel<$FullScreenContentListener> {
  $FullScreenContentListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.FullScreenContentCallback');

  Future<PairedInstance?> $$create(
    $FullScreenContentListener $instance, {
    required bool $owner,
    required $AdVoidCallback? onAdShowedFullScreenContent,
    required $AdVoidCallback? onAdImpression,
    required $AdVoidCallback? onAdFailedToShowFullScreenContent,
    required $AdVoidCallback? onAdWillDismissFullScreenContent,
    required $AdVoidCallback? onAdDismissedFullScreenContent,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdShowedFullScreenContent,
        onAdImpression,
        onAdFailedToShowFullScreenContent,
        onAdWillDismissFullScreenContent,
        onAdDismissedFullScreenContent,
      ],
      owner: $owner,
    );
  }
}

class $InterstitialAdLoadListenerChannel
    extends TypeChannel<$InterstitialAdLoadListener> {
  $InterstitialAdLoadListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.InterstitialAdLoadListener');

  Future<PairedInstance?> $$create(
    $InterstitialAdLoadListener $instance, {
    required bool $owner,
    required $InterstitialAdLoadCallback onAdLoaded,
    required $LoadFailCallback? onAdFailedToLoad,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdLoaded,
        onAdFailedToLoad,
      ],
      owner: $owner,
    );
  }
}

class $AdManagerInterstitialAdLoadListenerChannel
    extends TypeChannel<$AdManagerInterstitialAdLoadListener> {
  $AdManagerInterstitialAdLoadListenerChannel(TypeChannelMessenger messenger)
      : super(
            messenger, 'google_mobile_ads.AdManagerInterstitialAdLoadListener');

  Future<PairedInstance?> $$create(
    $AdManagerInterstitialAdLoadListener $instance, {
    required bool $owner,
    required $AdManagerInterstitialAdLoadCallback onAdLoaded,
    required $LoadFailCallback? onAdFailedToLoad,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdLoaded,
        onAdFailedToLoad,
      ],
      owner: $owner,
    );
  }
}

class $RewardedAdLoadListenerChannel
    extends TypeChannel<$RewardedAdLoadListener> {
  $RewardedAdLoadListenerChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RewardedAdAdLoadListener');

  Future<PairedInstance?> $$create(
    $RewardedAdLoadListener $instance, {
    required bool $owner,
    required $RewardedAdLoadCallback onAdLoaded,
    required $LoadFailCallback? onAdFailedToLoad,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        onAdLoaded,
        onAdFailedToLoad,
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
    $BannerAdListener listener,
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
      arguments[2] as $BannerAdListener,
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
    $AdManagerBannerAdListener listener,
    $AdManagerAdRequest request,
    $AppEventListener? appEventListener,
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
      arguments[2] as $AdManagerBannerAdListener,
      arguments[3] as $AdManagerAdRequest,
      arguments[4] as $AppEventListener?,
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
    $NativeAdListener listener,
    $AdRequest request,
    Map? customOptions,
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
      arguments[2] as $NativeAdListener,
      arguments[3] as $AdRequest,
      arguments[4] as Map?,
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

class $OnUserEarnedRewardListenerHandler
    implements TypeChannelHandler<$OnUserEarnedRewardListener> {
  $OnUserEarnedRewardListener $$create(
    TypeChannelMessenger messenger,
    $UserEarnedRewardCallback onUserEarnedRewardCallback,
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
  $OnUserEarnedRewardListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $UserEarnedRewardCallback,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $OnUserEarnedRewardListener instance,
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

class $AppEventListenerHandler
    implements TypeChannelHandler<$AppEventListener> {
  $AppEventListener $$create(
    TypeChannelMessenger messenger,
    $AppEventCallback onAppEvent,
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
  $AppEventListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $AppEventCallback,
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
    $AdVoidCallback onAdLoaded,
    $LoadFailCallback? onAdFailedToLoad,
    $AdVoidCallback? onAdOpened,
    $AdVoidCallback? onAdWillDismissScreen,
    $AdVoidCallback? onAdClosed,
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
      arguments[0] as $AdVoidCallback,
      arguments[1] as $LoadFailCallback?,
      arguments[2] as $AdVoidCallback?,
      arguments[3] as $AdVoidCallback?,
      arguments[4] as $AdVoidCallback?,
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
    $AdVoidCallback onAdLoaded,
    $LoadFailCallback? onAdFailedToLoad,
    $AdVoidCallback? onAdOpened,
    $AdVoidCallback? onAdWillDismissScreen,
    $AdVoidCallback? onAdClosed,
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
      arguments[0] as $AdVoidCallback,
      arguments[1] as $LoadFailCallback?,
      arguments[2] as $AdVoidCallback?,
      arguments[3] as $AdVoidCallback?,
      arguments[4] as $AdVoidCallback?,
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
    $AdVoidCallback onAdLoaded,
    $LoadFailCallback? onAdFailedToLoad,
    $AdVoidCallback? onAdOpened,
    $AdVoidCallback? onAdWillDismissScreen,
    $AdVoidCallback? onAdImpression,
    $AdVoidCallback? onAdClosed,
    $AdVoidCallback? onAdClicked,
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
  $NativeAdListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $AdVoidCallback,
      arguments[1] as $LoadFailCallback?,
      arguments[2] as $AdVoidCallback?,
      arguments[3] as $AdVoidCallback?,
      arguments[4] as $AdVoidCallback?,
      arguments[5] as $AdVoidCallback?,
      arguments[6] as $AdVoidCallback?,
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
    }

    throw ArgumentError.value(
      instance,
      'instance',
      'Unable to invoke method `$methodName` on',
    );
  }
}

class $FullScreenContentListenerHandler
    implements TypeChannelHandler<$FullScreenContentListener> {
  $FullScreenContentListener $$create(
    TypeChannelMessenger messenger,
    $AdVoidCallback? onAdShowedFullScreenContent,
    $AdVoidCallback? onAdImpression,
    $AdVoidCallback? onAdFailedToShowFullScreenContent,
    $AdVoidCallback? onAdWillDismissFullScreenContent,
    $AdVoidCallback? onAdDismissedFullScreenContent,
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
  $FullScreenContentListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $AdVoidCallback?,
      arguments[1] as $AdVoidCallback?,
      arguments[2] as $AdVoidCallback?,
      arguments[3] as $AdVoidCallback?,
      arguments[4] as $AdVoidCallback?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $FullScreenContentListener instance,
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

class $InterstitialAdLoadListenerHandler
    implements TypeChannelHandler<$InterstitialAdLoadListener> {
  $InterstitialAdLoadListener $$create(
    TypeChannelMessenger messenger,
    $InterstitialAdLoadCallback onAdLoaded,
    $LoadFailCallback? onAdFailedToLoad,
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
  $InterstitialAdLoadListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $InterstitialAdLoadCallback,
      arguments[1] as $LoadFailCallback?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $InterstitialAdLoadListener instance,
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

class $AdManagerInterstitialAdLoadListenerHandler
    implements TypeChannelHandler<$AdManagerInterstitialAdLoadListener> {
  $AdManagerInterstitialAdLoadListener $$create(
    TypeChannelMessenger messenger,
    $AdManagerInterstitialAdLoadCallback onAdLoaded,
    $LoadFailCallback? onAdFailedToLoad,
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
  $AdManagerInterstitialAdLoadListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $AdManagerInterstitialAdLoadCallback,
      arguments[1] as $LoadFailCallback?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdManagerInterstitialAdLoadListener instance,
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

class $RewardedAdLoadListenerHandler
    implements TypeChannelHandler<$RewardedAdLoadListener> {
  $RewardedAdLoadListener $$create(
    TypeChannelMessenger messenger,
    $RewardedAdLoadCallback onAdLoaded,
    $LoadFailCallback? onAdFailedToLoad,
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
  $RewardedAdLoadListener createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $RewardedAdLoadCallback,
      arguments[1] as $LoadFailCallback?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $RewardedAdLoadListener instance,
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

  $OnUserEarnedRewardListenerChannel get channelOnUserEarnedRewardListener =>
      $OnUserEarnedRewardListenerChannel(messenger);
  $OnUserEarnedRewardListenerHandler get handlerOnUserEarnedRewardListener =>
      $OnUserEarnedRewardListenerHandler();

  $AppEventListenerChannel get channelAppEventListener =>
      $AppEventListenerChannel(messenger);
  $AppEventListenerHandler get handlerAppEventListener =>
      $AppEventListenerHandler();

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

  $FullScreenContentListenerChannel get channelFullScreenContentListener =>
      $FullScreenContentListenerChannel(messenger);
  $FullScreenContentListenerHandler get handlerFullScreenContentListener =>
      $FullScreenContentListenerHandler();

  $InterstitialAdLoadListenerChannel get channelInterstitialAdLoadListener =>
      $InterstitialAdLoadListenerChannel(messenger);
  $InterstitialAdLoadListenerHandler get handlerInterstitialAdLoadListener =>
      $InterstitialAdLoadListenerHandler();

  $AdManagerInterstitialAdLoadListenerChannel
      get channelAdManagerInterstitialAdLoadListener =>
          $AdManagerInterstitialAdLoadListenerChannel(messenger);
  $AdManagerInterstitialAdLoadListenerHandler
      get handlerAdManagerInterstitialAdLoadListener =>
          $AdManagerInterstitialAdLoadListenerHandler();

  $RewardedAdLoadListenerChannel get channelRewardedAdLoadListener =>
      $RewardedAdLoadListenerChannel(messenger);
  $RewardedAdLoadListenerHandler get handlerRewardedAdLoadListener =>
      $RewardedAdLoadListenerHandler();

  $UserEarnedRewardCallbackChannel get channelUserEarnedRewardCallback =>
      $UserEarnedRewardCallbackChannel(messenger);
  $UserEarnedRewardCallbackHandler get handlerUserEarnedRewardCallback =>
      $UserEarnedRewardCallbackHandler(this);

  $AppEventCallbackChannel get channelAppEventCallback =>
      $AppEventCallbackChannel(messenger);
  $AppEventCallbackHandler get handlerAppEventCallback =>
      $AppEventCallbackHandler(this);

  $AdVoidCallbackChannel get channelAdVoidCallback =>
      $AdVoidCallbackChannel(messenger);
  $AdVoidCallbackHandler get handlerAdVoidCallback =>
      $AdVoidCallbackHandler(this);

  $InterstitialAdLoadCallbackChannel get channelInterstitialAdLoadCallback =>
      $InterstitialAdLoadCallbackChannel(messenger);
  $InterstitialAdLoadCallbackHandler get handlerInterstitialAdLoadCallback =>
      $InterstitialAdLoadCallbackHandler(this);

  $AdManagerInterstitialAdLoadCallbackChannel
      get channelAdManagerInterstitialAdLoadCallback =>
          $AdManagerInterstitialAdLoadCallbackChannel(messenger);
  $AdManagerInterstitialAdLoadCallbackHandler
      get handlerAdManagerInterstitialAdLoadCallback =>
          $AdManagerInterstitialAdLoadCallbackHandler(this);

  $RewardedAdLoadCallbackChannel get channelRewardedAdLoadCallback =>
      $RewardedAdLoadCallbackChannel(messenger);
  $RewardedAdLoadCallbackHandler get handlerRewardedAdLoadCallback =>
      $RewardedAdLoadCallbackHandler(this);

  $LoadFailCallbackChannel get channelLoadFailCallback =>
      $LoadFailCallbackChannel(messenger);
  $LoadFailCallbackHandler get handlerLoadFailCallback =>
      $LoadFailCallbackHandler(this);
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

    implementations.channelOnUserEarnedRewardListener.setHandler(
      implementations.handlerOnUserEarnedRewardListener,
    );

    implementations.channelAppEventListener.setHandler(
      implementations.handlerAppEventListener,
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

    implementations.channelFullScreenContentListener.setHandler(
      implementations.handlerFullScreenContentListener,
    );

    implementations.channelInterstitialAdLoadListener.setHandler(
      implementations.handlerInterstitialAdLoadListener,
    );

    implementations.channelAdManagerInterstitialAdLoadListener.setHandler(
      implementations.handlerAdManagerInterstitialAdLoadListener,
    );

    implementations.channelRewardedAdLoadListener.setHandler(
      implementations.handlerRewardedAdLoadListener,
    );

    implementations.channelUserEarnedRewardCallback.setHandler(
      implementations.handlerUserEarnedRewardCallback,
    );

    implementations.channelAppEventCallback.setHandler(
      implementations.handlerAppEventCallback,
    );

    implementations.channelAdVoidCallback.setHandler(
      implementations.handlerAdVoidCallback,
    );

    implementations.channelInterstitialAdLoadCallback.setHandler(
      implementations.handlerInterstitialAdLoadCallback,
    );

    implementations.channelAdManagerInterstitialAdLoadCallback.setHandler(
      implementations.handlerAdManagerInterstitialAdLoadCallback,
    );

    implementations.channelRewardedAdLoadCallback.setHandler(
      implementations.handlerRewardedAdLoadCallback,
    );

    implementations.channelLoadFailCallback.setHandler(
      implementations.handlerLoadFailCallback,
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

    implementations.channelOnUserEarnedRewardListener.removeHandler();

    implementations.channelAppEventListener.removeHandler();

    implementations.channelBannerAdListener.removeHandler();

    implementations.channelAdManagerBannerAdListener.removeHandler();

    implementations.channelNativeAdListener.removeHandler();

    implementations.channelFullScreenContentListener.removeHandler();

    implementations.channelInterstitialAdLoadListener.removeHandler();

    implementations.channelAdManagerInterstitialAdLoadListener.removeHandler();

    implementations.channelRewardedAdLoadListener.removeHandler();

    implementations.channelUserEarnedRewardCallback.removeHandler();

    implementations.channelAppEventCallback.removeHandler();

    implementations.channelAdVoidCallback.removeHandler();

    implementations.channelInterstitialAdLoadCallback.removeHandler();

    implementations.channelAdManagerInterstitialAdLoadCallback.removeHandler();

    implementations.channelRewardedAdLoadCallback.removeHandler();

    implementations.channelLoadFailCallback.removeHandler();
  }
}
