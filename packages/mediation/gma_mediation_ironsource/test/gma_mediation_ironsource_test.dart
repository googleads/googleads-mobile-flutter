import 'package:flutter_test/flutter_test.dart';
import 'package:gma_mediation_ironsource/gma_mediation_ironsource.dart';
import 'package:gma_mediation_ironsource/gma_mediation_ironsource_platform_interface.dart';
import 'package:gma_mediation_ironsource/gma_mediation_ironsource_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGmaMediationIronsourcePlatform
    with MockPlatformInterfaceMixin
    implements GmaMediationIronsourcePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GmaMediationIronsourcePlatform initialPlatform = GmaMediationIronsourcePlatform.instance;

  test('$MethodChannelGmaMediationIronsource is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGmaMediationIronsource>());
  });

  test('getPlatformVersion', () async {
    GmaMediationIronsource gmaMediationIronsourcePlugin = GmaMediationIronsource();
    MockGmaMediationIronsourcePlatform fakePlatform = MockGmaMediationIronsourcePlatform();
    GmaMediationIronsourcePlatform.instance = fakePlatform;

    expect(await gmaMediationIronsourcePlugin.getPlatformVersion(), '42');
  });
}
