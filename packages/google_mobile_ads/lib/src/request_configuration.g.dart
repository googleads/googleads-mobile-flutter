// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:reference/reference.dart';

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

mixin $RequestConfiguration {}

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

  $RequestConfigurationChannel get channelRequestConfiguration =>
      $RequestConfigurationChannel(messenger);
  $RequestConfigurationHandler get handlerRequestConfiguration =>
      $RequestConfigurationHandler();
}

class $ChannelRegistrar {
  $ChannelRegistrar(this.implementations);

  final $LibraryImplementations implementations;

  void registerHandlers() {
    implementations.channelRequestConfiguration.setHandler(
      implementations.handlerRequestConfiguration,
    );
  }

  void unregisterHandlers() {
    implementations.channelRequestConfiguration.removeHandler();
  }
}
