import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'meta_audience_network_platform_interface.dart';

/// An implementation of [MetaAudienceNetworkPlatform] that uses method channels.
class MethodChannelMetaAudienceNetwork extends MetaAudienceNetworkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('meta_audience_network');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
