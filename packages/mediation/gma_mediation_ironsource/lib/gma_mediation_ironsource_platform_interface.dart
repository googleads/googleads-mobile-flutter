import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gma_mediation_ironsource_method_channel.dart';

abstract class GmaMediationIronsourcePlatform extends PlatformInterface {
  /// Constructs a GmaMediationIronsourcePlatform.
  GmaMediationIronsourcePlatform() : super(token: _token);

  static final Object _token = Object();

  static GmaMediationIronsourcePlatform _instance = MethodChannelGmaMediationIronsource();

  /// The default instance of [GmaMediationIronsourcePlatform] to use.
  ///
  /// Defaults to [MethodChannelGmaMediationIronsource].
  static GmaMediationIronsourcePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GmaMediationIronsourcePlatform] when
  /// they register themselves.
  static set instance(GmaMediationIronsourcePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
