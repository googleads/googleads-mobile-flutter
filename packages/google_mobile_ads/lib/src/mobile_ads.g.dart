// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:reference/reference.dart';

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

mixin $AdapterInitializationState {}

mixin $MobileAds {}

mixin $InitializationStatus {}

mixin $AdapterStatus {}

mixin $RequestConfiguration {}

class $AdapterInitializationStateChannel
    extends TypeChannel<$AdapterInitializationState> {
  $AdapterInitializationStateChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdapterInitializationState');

  Future<PairedInstance?> $$create(
    $AdapterInitializationState $instance, {
    required bool $owner,
    required String value,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        value,
      ],
      owner: $owner,
    );
  }
}

class $MobileAdsChannel extends TypeChannel<$MobileAds> {
  $MobileAdsChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.MobileAds');

  Future<PairedInstance?> $$create(
    $MobileAds $instance, {
    required bool $owner,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[],
      owner: $owner,
    );
  }

  Future<Object?> $initialize(
    $MobileAds $instance,
  ) {
    return sendInvokeMethod(
      $instance,
      'initialize',
      <Object?>[],
    );
  }

  Future<Object?> $updateRequestConfiguration(
    $MobileAds $instance,
    $RequestConfiguration requestConfiguration,
  ) {
    return sendInvokeMethod(
      $instance,
      'updateRequestConfiguration',
      <Object?>[
        requestConfiguration,
      ],
    );
  }

  Future<Object?> $setSameAppKeyEnabled(
    $MobileAds $instance,
    bool isEnabled,
  ) {
    return sendInvokeMethod(
      $instance,
      'setSameAppKeyEnabled',
      <Object?>[
        isEnabled,
      ],
    );
  }
}

class $InitializationStatusChannel extends TypeChannel<$InitializationStatus> {
  $InitializationStatusChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.InitializationStatus');

  Future<PairedInstance?> $$create(
    $InitializationStatus $instance, {
    required bool $owner,
    required Map<String, $AdapterStatus> adapterStatuses,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        adapterStatuses,
      ],
      owner: $owner,
    );
  }
}

class $AdapterStatusChannel extends TypeChannel<$AdapterStatus> {
  $AdapterStatusChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.AdapterStatus');

  Future<PairedInstance?> $$create(
    $AdapterStatus $instance, {
    required bool $owner,
    required $AdapterInitializationState state,
    required String description,
    required double latency,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        state,
        description,
        latency,
      ],
      owner: $owner,
    );
  }
}

class $RequestConfigurationChannel extends TypeChannel<$RequestConfiguration> {
  $RequestConfigurationChannel(TypeChannelMessenger messenger)
      : super(messenger, 'google_mobile_ads.RequestConfiguration');

  Future<PairedInstance?> $$create(
    $RequestConfiguration $instance, {
    required bool $owner,
    required String? maxAdContentRating,
    required int? tagForChildDirectedTreatment,
    required int? tagForUnderAgeOfConsent,
    required List<String>? testDeviceIds,
  }) {
    return createNewInstancePair(
      $instance,
      <Object?>[
        maxAdContentRating,
        tagForChildDirectedTreatment,
        tagForUnderAgeOfConsent,
        testDeviceIds,
      ],
      owner: $owner,
    );
  }
}

class $AdapterInitializationStateHandler
    implements TypeChannelHandler<$AdapterInitializationState> {
  $AdapterInitializationState $$create(
    TypeChannelMessenger messenger,
    String value,
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
  $AdapterInitializationState createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as String,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdapterInitializationState instance,
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

class $MobileAdsHandler implements TypeChannelHandler<$MobileAds> {
  $MobileAds $$create(
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
  $MobileAds createInstance(
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
    $MobileAds instance,
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

class $InitializationStatusHandler
    implements TypeChannelHandler<$InitializationStatus> {
  $InitializationStatus $$create(
    TypeChannelMessenger messenger,
    Map<String, $AdapterStatus> adapterStatuses,
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
  $InitializationStatus createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as Map<String, $AdapterStatus>,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $InitializationStatus instance,
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

class $AdapterStatusHandler implements TypeChannelHandler<$AdapterStatus> {
  $AdapterStatus $$create(
    TypeChannelMessenger messenger,
    $AdapterInitializationState state,
    String description,
    double latency,
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
  $AdapterStatus createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as $AdapterInitializationState,
      arguments[1] as String,
      arguments[2] as double,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $AdapterStatus instance,
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

class $RequestConfigurationHandler
    implements TypeChannelHandler<$RequestConfiguration> {
  $RequestConfiguration $$create(
    TypeChannelMessenger messenger,
    String? maxAdContentRating,
    int? tagForChildDirectedTreatment,
    int? tagForUnderAgeOfConsent,
    List<String>? testDeviceIds,
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
  $RequestConfiguration createInstance(
    TypeChannelMessenger messenger,
    List<Object?> arguments,
  ) {
    return $$create(
      messenger,
      arguments[0] as String?,
      arguments[1] as int?,
      arguments[2] as int?,
      arguments[3] as List<String>?,
    );
  }

  @override
  Object? invokeMethod(
    TypeChannelMessenger messenger,
    $RequestConfiguration instance,
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

  $AdapterInitializationStateChannel get channelAdapterInitializationState =>
      $AdapterInitializationStateChannel(messenger);
  $AdapterInitializationStateHandler get handlerAdapterInitializationState =>
      $AdapterInitializationStateHandler();

  $MobileAdsChannel get channelMobileAds => $MobileAdsChannel(messenger);
  $MobileAdsHandler get handlerMobileAds => $MobileAdsHandler();

  $InitializationStatusChannel get channelInitializationStatus =>
      $InitializationStatusChannel(messenger);
  $InitializationStatusHandler get handlerInitializationStatus =>
      $InitializationStatusHandler();

  $AdapterStatusChannel get channelAdapterStatus =>
      $AdapterStatusChannel(messenger);
  $AdapterStatusHandler get handlerAdapterStatus => $AdapterStatusHandler();

  $RequestConfigurationChannel get channelRequestConfiguration =>
      $RequestConfigurationChannel(messenger);
  $RequestConfigurationHandler get handlerRequestConfiguration =>
      $RequestConfigurationHandler();
}

class $ChannelRegistrar {
  $ChannelRegistrar(this.implementations);

  final $LibraryImplementations implementations;

  void registerHandlers() {
    implementations.channelAdapterInitializationState.setHandler(
      implementations.handlerAdapterInitializationState,
    );

    implementations.channelMobileAds.setHandler(
      implementations.handlerMobileAds,
    );

    implementations.channelInitializationStatus.setHandler(
      implementations.handlerInitializationStatus,
    );

    implementations.channelAdapterStatus.setHandler(
      implementations.handlerAdapterStatus,
    );

    implementations.channelRequestConfiguration.setHandler(
      implementations.handlerRequestConfiguration,
    );
  }

  void unregisterHandlers() {
    implementations.channelAdapterInitializationState.removeHandler();

    implementations.channelMobileAds.removeHandler();

    implementations.channelInitializationStatus.removeHandler();

    implementations.channelAdapterStatus.removeHandler();

    implementations.channelRequestConfiguration.removeHandler();
  }
}
