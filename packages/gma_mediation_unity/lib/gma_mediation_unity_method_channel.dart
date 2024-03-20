import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gma_mediation_unity_platform_interface.dart';

/// An implementation of [GmaMediationUnityPlatform] that uses method channels.
class MethodChannelGmaMediationUnity extends GmaMediationUnityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gma_mediation_unity');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
