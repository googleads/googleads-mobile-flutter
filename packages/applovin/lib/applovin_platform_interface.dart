import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'applovin_method_channel.dart';

abstract class ApplovinPlatform extends PlatformInterface {

  ApplovinPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApplovinPlatform _instance = MethodChannelApplovin();

  static ApplovinPlatform get instance => _instance;

  static set instance(ApplovinPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void setDoNotSell(bool doNotSell) async {
    throw UnimplementedError('setDoNotSell(bool) has not been implemented.');
  }
}
