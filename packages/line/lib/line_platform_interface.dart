import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'line_method_channel.dart';

abstract class LinePlatform extends PlatformInterface {
  /// Constructs a LinePlatform.
  LinePlatform() : super(token: _token);

  static final Object _token = Object();

  static LinePlatform _instance = MethodChannelLine();

  /// The default instance of [LinePlatform] to use.
  ///
  /// Defaults to [MethodChannelLine].
  static LinePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LinePlatform] when
  /// they register themselves.
  static set instance(LinePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
