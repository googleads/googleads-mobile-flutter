import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gma_mediation_unity_method_channel.dart';

abstract class GmaMediationUnityPlatform extends PlatformInterface {
  /// Constructs a GmaMediationUnityPlatform.
  GmaMediationUnityPlatform() : super(token: _token);

  static final Object _token = Object();

  static GmaMediationUnityPlatform _instance = MethodChannelGmaMediationUnity();

  /// The default instance of [GmaMediationUnityPlatform] to use.
  ///
  /// Defaults to [MethodChannelGmaMediationUnity].
  static GmaMediationUnityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GmaMediationUnityPlatform] when
  /// they register themselves.
  static set instance(GmaMediationUnityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
