
import 'applovin_platform_interface.dart';

class Applovin {
  void setDoNotSell(bool doNotSet) {
    ApplovinPlatform.instance.setDoNotSell(doNotSet);
  }
}
