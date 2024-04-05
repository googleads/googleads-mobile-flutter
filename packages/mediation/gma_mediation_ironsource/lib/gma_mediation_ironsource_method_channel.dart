import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gma_mediation_ironsource_platform_interface.dart';

/// An implementation of [GmaMediationIronsourcePlatform] that uses method channels.
class MethodChannelGmaMediationIronsource extends GmaMediationIronsourcePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gma_mediation_ironsource');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
