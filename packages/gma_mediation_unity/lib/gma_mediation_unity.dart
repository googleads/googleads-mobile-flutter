
import 'gma_mediation_unity_platform_interface.dart';

class GmaMediationUnity {
  Future<String?> getPlatformVersion() {
    return GmaMediationUnityPlatform.instance.getPlatformVersion();
  }
}
