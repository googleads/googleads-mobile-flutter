// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:firebase_admob/src/ad_instance_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirebaseAdMob', () {
    final List<MethodCall> log = <MethodCall>[];
    final MessageCodec codec = AdMessageCodec();

    setUp(() async {
      log.clear();
      instanceManager = AdInstanceManager('plugins.flutter.io/firebase_admob');
      instanceManager.channel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'loadBannerAd':
          case 'loadNativeAd':
          case 'showAdWithoutView':
          case 'disposeAd':
          case 'loadRewardedAd':
          case 'loadInterstitialAd':
            return Future<void>.value();
          default:
            assert(false);
            return null;
        }
      });
    });

    test('load banner', () async {
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
          'size': AdSize.banner,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);
    });

    test('dispose banner', () async {
      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(),
        request: AdRequest(),
      );

      await banner.load();
      log.clear();
      await banner.dispose();
      expect(log, <Matcher>[
        isMethodCall('disposeAd', arguments: <String, dynamic>{
          'adId': 0,
        })
      ]);

      expect(instanceManager.adFor(0), isNull);
      expect(instanceManager.adIdFor(banner), isNull);
    });

    test('calling dispose without awaiting load', () {
      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(),
        request: AdRequest(),
      );

      banner.load();
      banner.dispose();
      expect(instanceManager.adFor(0), isNull);
      expect(instanceManager.adIdFor(banner), isNull);
    });

    test('load native', () async {
      final Map<String, Object> options = <String, Object>{'a': 1, 'b': 2};

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        customOptions: options,
        listener: AdListener(),
        request: AdRequest(),
      );

      await native.load();
      expect(log, <Matcher>[
        isMethodCall('loadNativeAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': NativeAd.testAdUnitId,
          'request': native.request,
          'factoryId': '0',
          'customOptions': options,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);
    });

    testWidgets('build ad widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            final NativeAd native = NativeAd(
              adUnitId: NativeAd.testAdUnitId,
              factoryId: '0',
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

    test('load rewarded', () async {
      final RewardedAd rewarded = RewardedAd(
        adUnitId: RewardedAd.testAdUnitId,
        listener: AdListener(),
        request: AdRequest(),
      );

      await rewarded.load();

      expect(log, <Matcher>[
        isMethodCall('loadRewardedAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': RewardedAd.testAdUnitId,
          'request': rewarded.request,
        }),
      ]);

      expect(instanceManager.adFor(0), isNotNull);
    });

    test('load interstitial', () async {
      final InterstitialAd interstitial = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        listener: AdListener(),
        request: AdRequest(),
      );

      await interstitial.load();
      expect(log, <Matcher>[
        isMethodCall('loadInterstitialAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': InterstitialAd.testAdUnitId,
          'request': interstitial.request,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);
    });

    test('onAdLoaded', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(
          onAdLoaded: (Ad ad) => adEventCompleter.complete(ad),
        ),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onAdLoaded',
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onAdFailedToLoad', () async {
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
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onAdFailedToLoad'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onNativeAdClicked', () async {
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
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onNativeAdClicked'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(native));
    });

    test('onNativeAdImpression', () async {
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
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onNativeAdImpression'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(native));
    });

    test('onAdOpened', () async {
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
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onAdOpened'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onApplicationExit', () async {
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
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onApplicationExit'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onAdClosed', () async {
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
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onAdClosed'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onRewardedAdUserEarnedReward', () async {
      final Completer<List<dynamic>> resultCompleter =
          Completer<List<dynamic>>();

      final RewardedAd rewardedAd = RewardedAd(
        adUnitId: BannerAd.testAdUnitId,
        listener: AdListener(
          onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem item) =>
              resultCompleter.complete(<Object>[ad, item]),
        ),
        request: AdRequest(),
      );

      await rewardedAd.load();

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onRewardedAdUserEarnedReward',
        'rewardItem': RewardItem(1, 'one'),
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      final List<dynamic> result = await resultCompleter.future;
      expect(result[0], rewardedAd);
      expect(result[1].amount, 1);
      expect(result[1].type, 'one');
    });

    test('show $AdWithoutView', () {
      final InterstitialAd ad = InterstitialAd(
        adUnitId: 'testId',
        request: AdRequest(),
        listener: AdListener(),
      );

      ad.load();
      log.clear();
      ad.show();
      expect(log, <Matcher>[
        isMethodCall('showAdWithoutView', arguments: <dynamic, dynamic>{
          'adId': 0,
        })
      ]);
    });

    test('show $AdWithoutView throws $AssertionError', () {
      final InterstitialAd ad = InterstitialAd(
        adUnitId: 'testId',
        request: AdRequest(),
        listener: AdListener(),
      );

      expect(() => instanceManager.showAdWithoutView(ad), throwsAssertionError);
    });

    test('encode/decode AdSize', () async {
      final ByteData byteData = codec.encodeMessage(AdSize.banner);
      expect(codec.decodeMessage(byteData), AdSize.banner);
    });

    test('encode/decode AdRequest', () async {
      final AdRequest adRequest = AdRequest(
          keywords: ['1', '2', '3'],
          contentUrl: 'contentUrl',
          birthday: DateTime(2020),
          gender: MobileAdGender.unknown,
          designedForFamilies: true,
          childDirected: true,
          testDevices: ['Android', 'iOS'],
          nonPersonalizedAds: false);

      final ByteData byteData = codec.encodeMessage(adRequest);
      expect(codec.decodeMessage(byteData), adRequest);
    });

    test('encode/decode DateTime', () async {
      final ByteData byteData = codec.encodeMessage(DateTime(2020));
      expect(codec.decodeMessage(byteData), DateTime(2020));
    });

    test('encode/decode MobileAdGender', () async {
      final ByteData byteData = codec.encodeMessage(MobileAdGender.unknown);
      expect(codec.decodeMessage(byteData), MobileAdGender.unknown);
    });

    test('encode/decode $RewardItem', () async {
      final ByteData byteData = codec.encodeMessage(RewardItem(1, 'type'));

      final RewardItem result = codec.decodeMessage(byteData);
      expect(result.amount, 1);
      expect(result.type, 'type');
    });

    test('isLoaded', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: AdListener(
          onAdLoaded: (Ad ad) => adEventCompleter.complete(ad),
        ),
        request: AdRequest(),
      );

      await banner.load();

      expect(banner.isLoaded(), completion(false));

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onAdLoaded',
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/firebase_admob',
        data,
        (ByteData data) {},
      );

      expect(banner.isLoaded(), completion(true));

      await banner.dispose();
      expect(banner.isLoaded(), completion(false));
    });
  });
}
