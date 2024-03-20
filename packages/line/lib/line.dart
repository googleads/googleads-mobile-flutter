
import 'line_platform_interface.dart';

class Line {
  Future<String?> getPlatformVersion() {
    return LinePlatform.instance.getPlatformVersion();
  }
}
