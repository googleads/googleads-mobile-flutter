import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'line_platform_interface.dart';

/// An implementation of [LinePlatform] that uses method channels.
class MethodChannelLine extends LinePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('line');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
