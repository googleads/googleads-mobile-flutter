// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_admob/src/ad_instance_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mobile Ads', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final List<MethodCall> log = <MethodCall>[];
    final AdMessageCodec codec = AdMessageCodec();

    setUpAll(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    });

    setUp(() async {
      log.clear();
      instanceManager = AdInstanceManager('test_channel');
      instanceManager.channel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'MobileAds#initialize':
            return InitializationStatus(<String, AdapterStatus>{
              'aName': AdapterStatus(
                AdapterInitializationState.notReady,
                'desc',
                null,
              ),
            });
          default:
            assert(false);
            return null;
        }
      });
    });

    test('encode/decode $AdapterInitializationState', () {
      final ByteData byteData =
          codec.encodeMessage(AdapterInitializationState.ready);

      final AdapterInitializationState result = codec.decodeMessage(byteData);
      expect(result, AdapterInitializationState.ready);
    });

    test('encode/decode $AdapterStatus', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final ByteData byteData = codec.encodeMessage(AdapterStatus(
        AdapterInitializationState.notReady,
        'describe',
        23,
      ));

      AdapterStatus result = codec.decodeMessage(byteData);
      expect(result.state, AdapterInitializationState.notReady);
      expect(result.description, 'describe');
      expect(result.latency, 0.023);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      result = codec.decodeMessage(byteData);
      expect(result.state, AdapterInitializationState.notReady);
      expect(result.description, 'describe');
      expect(result.latency, 23);
    });

    test('handle int values for AdapterStatus', () {
      final WriteBuffer buffer = WriteBuffer();
      codec.writeValue(buffer, AdapterInitializationState.ready);
      codec.writeValue(buffer, null);
      codec.writeValue(buffer, 23);

      expect(
        () => codec.readValueOfType(
          136 /* AdMessageCodec._valueAdapterStatus */,
          ReadBuffer(buffer.done()),
        ),
        returnsNormally,
      );
    });

    test('encode/decode $InitializationStatus', () {
      final ByteData byteData =
          codec.encodeMessage(InitializationStatus(<String, AdapterStatus>{
        'adMediation': AdapterStatus(
          AdapterInitializationState.ready,
          'aDescription',
          null,
        ),
      }));

      final InitializationStatus result = codec.decodeMessage(byteData);
      expect(result.adapterStatuses, hasLength(1));
      final AdapterStatus status = result.adapterStatuses['adMediation'];
      expect(status.state, AdapterInitializationState.ready);
      expect(status.description, 'aDescription');
      expect(status.latency, null);
    });

    test('$MobileAds.initialize', () async {
      final InitializationStatus result = await MobileAds.instance.initialize();

      expect(log,
          <Matcher>[isMethodCall("MobileAds#initialize", arguments: null)]);

      expect(result.adapterStatuses, hasLength(1));
      final AdapterStatus status = result.adapterStatuses['aName'];
      expect(status.state, AdapterInitializationState.notReady);
      expect(status.description, 'desc');
      expect(status.latency, null);
    });
  });
}
