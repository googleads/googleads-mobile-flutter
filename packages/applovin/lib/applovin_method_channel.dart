import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'applovin_platform_interface.dart';

/// An implementation of [ApplovinPlatform] that uses method channels.
class MethodChannelApplovin extends ApplovinPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('applovin');

  @override
  void setDoNotSell(bool doNotSell) async {
    await methodChannel.invokeMethod<String>('setDoNotSell',
        <String, dynamic>{
          'doNotSell': doNotSell
        }
    );
  }
}
