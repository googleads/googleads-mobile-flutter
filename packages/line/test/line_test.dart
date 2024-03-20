import 'package:flutter_test/flutter_test.dart';
import 'package:line/line.dart';
import 'package:line/line_platform_interface.dart';
import 'package:line/line_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLinePlatform
    with MockPlatformInterfaceMixin
    implements LinePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LinePlatform initialPlatform = LinePlatform.instance;

  test('$MethodChannelLine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLine>());
  });

  test('getPlatformVersion', () async {
    Line linePlugin = Line();
    MockLinePlatform fakePlatform = MockLinePlatform();
    LinePlatform.instance = fakePlatform;

    expect(await linePlugin.getPlatformVersion(), '42');
  });
}
