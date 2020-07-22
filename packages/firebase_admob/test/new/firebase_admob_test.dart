// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'package:firebase_admob/new/ad_instance_manager.dart';
import 'package:firebase_admob/new/firebase_admob.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirebaseAdMob', () {
    const MethodChannel channel = MethodChannel(
        'plugins.flutter.io/firebase_admob',
        StandardMethodCodec(AdMessageCodec()));

    // TODO(cg021): Fix unnecessary adId incrementing
    final AdInstanceManager manager =
        AdInstanceManager('plugins.flutter.io/firebase_admob');

    final AdMessageCodec messageCodec = AdMessageCodec();

    final List<MethodCall> log = <MethodCall>[];

    setUp(() async {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'loadBannerAd':
          case 'loadNativeAd':
          case 'showAd':
          case 'disposeAd':
          case 'loadRewardedAd':
          case 'loadInterstitialAd':
            return Future<bool>.value(true);
          default:
            assert(false);
            return null;
        }
      });
    });

    test('load banner', () async {
      log.clear();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(),
        request: AdRequest(),
      );

      await banner.load();

      expect(log, <Matcher>[
        isMethodCall('loadBannerAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': BannerAd.testAdUnitId,
          'request': banner.request,
          'size': AdSize.banner
        })
      ]);

      await manager.loadBannerAd(banner);
      expect(manager.adFor(1), isNotNull);
    });

    test('dispose banner', () async {
      log.clear();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(),
        request: AdRequest(),
      );

      await banner.load();
      await banner.dispose();

      expect(log, <Matcher>[
        isMethodCall('loadBannerAd', arguments: <String, dynamic>{
          'adId': 2,
          'adUnitId': BannerAd.testAdUnitId,
          'request': banner.request,
          'size': AdSize.banner
        }),
        isMethodCall('disposeAd', arguments: <String, dynamic>{
          'adId': 2,
        })
      ]);

      await manager.disposeAd(banner);
      expect(manager.adFor(2), isNull);
      expect(manager.adIdFor(banner), isNull);
    });

    test('load native', () async {
      log.clear();

      final Map<String, Object> options = <String, Object>{'a': 1, 'b': 2};

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: "0",
        customOptions: options,
        listener: AdListener(),
        request: AdRequest(),
      );

      await native.load();

      expect(log, <Matcher>[
        isMethodCall('loadNativeAd', arguments: <String, dynamic>{
          'adId': 3,
          'adUnitId': NativeAd.testAdUnitId,
          'request': native.request,
          'factoryId': "0",
          'customOptions': options,
        })
      ]);

      await manager.loadNativeAd(native);
      expect(manager.adFor(4), isNotNull);
    });

    test('dispose native', () async {
      log.clear();

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: "0",
        listener: AdListener(),
        request: AdRequest(),
      );

      await native.load();
      await native.dispose();

      expect(log, <Matcher>[
        isMethodCall('loadNativeAd', arguments: <String, dynamic>{
          'adId': 5,
          'adUnitId': NativeAd.testAdUnitId,
          'request': native.request,
          'factoryId': "0",
          'customOptions': null
        }),
        isMethodCall('disposeAd', arguments: <String, dynamic>{
          'adId': 5,
        })
      ]);

      await manager.disposeAd(native);
      expect(manager.adFor(0), isNull);
      expect(manager.adIdFor(native), isNull);
    });

    testWidgets('build ad widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            final NativeAd native = NativeAd(
              adUnitId: NativeAd.testAdUnitId,
              factoryId: "0",
              listener: AdListener(),
              request: AdRequest(),
            );

            AdWidget widget = AdWidget(ad: native);
            var buildWidget = widget.build(context);
            expect(buildWidget, isA<PlatformViewLink>());
            return widget;
          },
        ),
      );
    });

    test('rewarded', () async {
      log.clear();

      final RewardedAd rewarded = RewardedAd(
        adUnitId: RewardedAd.testAdUnitId,
        listener: AdListener(),
        request: AdRequest(),
      );

      await rewarded.load();
      await rewarded.dispose();

      expect(log, <Matcher>[
        isMethodCall('loadRewardedAd', arguments: <String, dynamic>{
          'adId': 6,
          'adUnitId': RewardedAd.testAdUnitId,
          'request': rewarded.request,
        }),
        isMethodCall('disposeAd', arguments: <String, dynamic>{
          'adId': 6,
        }),
      ]);

      await manager.loadRewardedAd(rewarded);
      expect(manager.adFor(6), isNull);
    });

    test('load interstitial', () async {
      log.clear();

      final InterstitialAd interstitial = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        listener: AdListener(),
        request: AdRequest(),
      );

      await interstitial.load();

      expect(log, <Matcher>[
        isMethodCall('loadInterstitialAd', arguments: <String, dynamic>{
          'adId': 8,
          'adUnitId': InterstitialAd.testAdUnitId,
          'request': interstitial.request,
        })
      ]);

      await manager.loadInterstitialAd(interstitial);
      expect(manager.adFor(9), isNotNull);
    });

    test('dispose interstitial', () async {
      log.clear();

      final InterstitialAd interstitial = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        listener: AdListener(),
        request: AdRequest(),
      );

      await interstitial.load();
      await interstitial.dispose();

      expect(log, <Matcher>[
        isMethodCall('loadInterstitialAd', arguments: <String, dynamic>{
          'adId': 10,
          'adUnitId': InterstitialAd.testAdUnitId,
          'request': interstitial.request,
        }),
        isMethodCall('disposeAd', arguments: <String, dynamic>{
          'adId': 10,
        })
      ]);
    });

    test('test onAdLoaded', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener:
            AdListener(onAdLoaded: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 11, 'eventName': 'onAdLoaded'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('test onAdFailedToLoad', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(
            onAdFailedToLoad: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 12, 'eventName': 'onAdFailedToLoad'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('test onNativeAdClicked', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: NativeAd.testAdUnitId,
        listener: AdListener(
            onNativeAdClicked: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await native.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 13, 'eventName': 'onNativeAdClicked'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(native));
    });

    test('test onNativeAdImpression', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: NativeAd.testAdUnitId,
        listener: AdListener(
            onNativeAdImpression: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await native.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 14, 'eventName': 'onNativeAdImpression'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(native));
    });

    test('test onAdOpened', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener:
            AdListener(onAdOpened: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 15, 'eventName': 'onAdOpened'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('test onApplicationExit', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(
            onApplicationExit: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 16, 'eventName': 'onApplicationExit'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('test onAdClosed', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener:
            AdListener(onAdClosed: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 17, 'eventName': 'onAdClosed'});

      final ByteData data = manager.channel.codec.encodeMethodCall(methodCall);

      await manager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('encode/decode AdSize', () async {
      log.clear();

      final ByteData byteData = messageCodec.encodeMessage(AdSize.banner);
      expect(messageCodec.decodeMessage(byteData), AdSize.banner);
    });

    test('encode/decode AdRequest', () async {
      log.clear();

      final AdRequest adRequest = AdRequest(
          keywords: ['1', '2', '3'],
          contentUrl: 'contentUrl',
          birthday: DateTime(2020),
          gender: MobileAdGender.unknown,
          designedForFamilies: true,
          childDirected: true,
          testDevices: ['Android', 'iOS'],
          nonPersonalizedAds: false);

      final ByteData byteData = messageCodec.encodeMessage(adRequest);
      expect(messageCodec.decodeMessage(byteData), adRequest);
    });

    test('encode/decode DateTime', () async {
      log.clear();

      final ByteData byteData = messageCodec.encodeMessage(DateTime(2020));
      expect(messageCodec.decodeMessage(byteData), DateTime(2020));
    });

    test('encode/decode MobileAdGender', () async {
      log.clear();

      final ByteData byteData =
          messageCodec.encodeMessage(MobileAdGender.unknown);
      expect(messageCodec.decodeMessage(byteData), MobileAdGender.unknown);
    });
  });
}
