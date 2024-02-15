import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gma_mediation_unity/gma_mediation_unity_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGmaMediationUnity platform = MethodChannelGmaMediationUnity();
  const MethodChannel channel = MethodChannel('gma_mediation_unity');

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
