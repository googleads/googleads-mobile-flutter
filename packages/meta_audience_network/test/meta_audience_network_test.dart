import 'package:flutter_test/flutter_test.dart';
import 'package:meta_audience_network/meta_audience_network.dart';
import 'package:meta_audience_network/meta_audience_network_platform_interface.dart';
import 'package:meta_audience_network/meta_audience_network_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMetaAudienceNetworkPlatform
    with MockPlatformInterfaceMixin
    implements MetaAudienceNetworkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MetaAudienceNetworkPlatform initialPlatform = MetaAudienceNetworkPlatform.instance;

  test('$MethodChannelMetaAudienceNetwork is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMetaAudienceNetwork>());
  });

  test('getPlatformVersion', () async {
    MetaAudienceNetwork metaAudienceNetworkPlugin = MetaAudienceNetwork();
    MockMetaAudienceNetworkPlatform fakePlatform = MockMetaAudienceNetworkPlatform();
    MetaAudienceNetworkPlatform.instance = fakePlatform;

    expect(await metaAudienceNetworkPlugin.getPlatformVersion(), '42');
  });
}
