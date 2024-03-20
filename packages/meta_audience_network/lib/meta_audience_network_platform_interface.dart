import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'meta_audience_network_method_channel.dart';

abstract class MetaAudienceNetworkPlatform extends PlatformInterface {
  /// Constructs a MetaAudienceNetworkPlatform.
  MetaAudienceNetworkPlatform() : super(token: _token);

  static final Object _token = Object();

  static MetaAudienceNetworkPlatform _instance = MethodChannelMetaAudienceNetwork();

  /// The default instance of [MetaAudienceNetworkPlatform] to use.
  ///
  /// Defaults to [MethodChannelMetaAudienceNetwork].
  static MetaAudienceNetworkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MetaAudienceNetworkPlatform] when
  /// they register themselves.
  static set instance(MetaAudienceNetworkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
