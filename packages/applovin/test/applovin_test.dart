import 'package:flutter_test/flutter_test.dart';
import 'package:applovin/applovin.dart';
import 'package:applovin/applovin_platform_interface.dart';
import 'package:applovin/applovin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockApplovinPlatform
    with MockPlatformInterfaceMixin
    implements ApplovinPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ApplovinPlatform initialPlatform = ApplovinPlatform.instance;

  test('$MethodChannelApplovin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelApplovin>());
  });

  test('getPlatformVersion', () async {
    Applovin applovinPlugin = Applovin();
    MockApplovinPlatform fakePlatform = MockApplovinPlatform();
    ApplovinPlatform.instance = fakePlatform;

    expect(await applovinPlugin.getPlatformVersion(), '42');
  });
}
