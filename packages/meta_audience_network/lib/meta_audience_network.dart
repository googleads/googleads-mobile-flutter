
import 'meta_audience_network_platform_interface.dart';

class MetaAudienceNetwork {
  Future<String?> getPlatformVersion() {
    return MetaAudienceNetworkPlatform.instance.getPlatformVersion();
  }
}
