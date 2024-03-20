import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta_audience_network/meta_audience_network_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMetaAudienceNetwork platform = MethodChannelMetaAudienceNetwork();
  const MethodChannel channel = MethodChannel('meta_audience_network');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
