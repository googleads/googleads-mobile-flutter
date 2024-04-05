
import 'gma_mediation_ironsource_platform_interface.dart';

class GmaMediationIronsource {
  Future<String?> getPlatformVersion() {
    return GmaMediationIronsourcePlatform.instance.getPlatformVersion();
  }
}
