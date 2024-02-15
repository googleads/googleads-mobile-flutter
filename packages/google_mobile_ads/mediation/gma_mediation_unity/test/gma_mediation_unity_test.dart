import 'package:flutter_test/flutter_test.dart';
import 'package:gma_mediation_unity/gma_mediation_unity.dart';
import 'package:gma_mediation_unity/gma_mediation_unity_platform_interface.dart';
import 'package:gma_mediation_unity/gma_mediation_unity_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGmaMediationUnityPlatform
    with MockPlatformInterfaceMixin
    implements GmaMediationUnityPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GmaMediationUnityPlatform initialPlatform = GmaMediationUnityPlatform.instance;

  test('$MethodChannelGmaMediationUnity is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGmaMediationUnity>());
  });

  test('getPlatformVersion', () async {
    GmaMediationUnity gmaMediationUnityPlugin = GmaMediationUnity();
    MockGmaMediationUnityPlatform fakePlatform = MockGmaMediationUnityPlatform();
    GmaMediationUnityPlatform.instance = fakePlatform;

    expect(await gmaMediationUnityPlugin.getPlatformVersion(), '42');
  });
}
