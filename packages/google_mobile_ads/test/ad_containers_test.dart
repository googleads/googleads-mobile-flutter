// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

// ignore_for_file: deprecated_member_use_from_same_package
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleMobileAds', () {
    final List<MethodCall> log = <MethodCall>[];
    final AdMessageCodec codec = AdMessageCodec();

    setUp(() async {
      log.clear();
      instanceManager =
          AdInstanceManager('plugins.flutter.io/google_mobile_ads');
      instanceManager.channel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'MobileAds#updateRequestConfiguration':
          case 'MobileAds#setSameAppKeyEnabled':
          case 'loadBannerAd':
          case 'loadNativeAd':
          case 'showAdWithoutView':
          case 'disposeAd':
          case 'loadRewardedAd':
          case 'loadInterstitialAd':
          case 'loadAdManagerInterstitialAd':
          case 'loadAdManagerBannerAd':
            return Future<void>.value();
          default:
            assert(false);
            return null;
        }
      });
    });

    test('updateRequestConfiguration', () async {
      final RequestConfiguration requestConfiguration = RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.ma,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
        testDeviceIds: <String>['test-device-id'],
      );
      await instanceManager.updateRequestConfiguration(requestConfiguration);
      expect(log, <Matcher>[
        isMethodCall('MobileAds#updateRequestConfiguration',
            arguments: <String, dynamic>{
              'maxAdContentRating': MaxAdContentRating.ma,
              'tagForChildDirectedTreatment': TagForChildDirectedTreatment.yes,
              'tagForUnderAgeOfConsent': TagForUnderAgeOfConsent.yes,
              'testDeviceIds': <String>['test-device-id'],
            })
      ]);
    });

    test('setSameAppKeyEnabled', () async {
      await instanceManager.setSameAppKeyEnabled(true);

      expect(log, <Matcher>[
        isMethodCall('MobileAds#setSameAppKeyEnabled',
            arguments: <String, dynamic>{
              'isEnabled': true,
            })
      ]);

      await instanceManager.setSameAppKeyEnabled(false);

      expect(log, <Matcher>[
        isMethodCall('MobileAds#setSameAppKeyEnabled',
            arguments: <String, dynamic>{
              'isEnabled': true,
            }),
        isMethodCall('MobileAds#setSameAppKeyEnabled',
            arguments: <String, dynamic>{
              'isEnabled': false,
            })
      ]);
    });

    test('load banner', () async {
      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(),
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
        listener: BannerAdListener(),
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
        listener: BannerAdListener(),
        request: AdRequest(),
      );

      banner.load();
      banner.dispose();
      expect(instanceManager.adFor(0), isNull);
      expect(instanceManager.adIdFor(banner), isNull);
    });

    test('load native', () async {
      final Map<String, Object> options = <String, Object>{'a': 1, 'b': 2};
      final NativeAdOptions nativeAdOptions = NativeAdOptions(
          adChoicesPlacement: AdChoicesPlacement.bottomLeftCorner,
          mediaAspectRatio: MediaAspectRatio.any,
          videoOptions: VideoOptions(
            clickToExpandRequested: true,
            customControlsRequested: true,
            startMuted: true,
          ),
          requestCustomMuteThisAd: false,
          shouldRequestMultipleImages: true,
          shouldReturnUrlsForImageAssets: false);
      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        customOptions: options,
        listener: NativeAdListener(),
        request: AdRequest(),
        nativeAdOptions: nativeAdOptions,
      );

      await native.load();
      expect(log, <Matcher>[
        isMethodCall('loadNativeAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': NativeAd.testAdUnitId,
          'request': native.request,
          'adManagerRequest': null,
          'factoryId': '0',
          'nativeAdOptions': nativeAdOptions,
          'customOptions': options,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);
    });

    test('load native with $AdManagerAdRequest', () async {
      final Map<String, Object> options = <String, Object>{'a': 1, 'b': 2};

      final NativeAd native = NativeAd.fromAdManagerRequest(
        adUnitId: 'test-id',
        factoryId: '0',
        customOptions: options,
        listener: NativeAdListener(),
        adManagerRequest: AdManagerAdRequest(),
      );

      await native.load();
      expect(log, <Matcher>[
        isMethodCall('loadNativeAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': 'test-id',
          'request': null,
          'adManagerRequest': native.adManagerRequest,
          'factoryId': '0',
          'nativeAdOptions': null,
          'customOptions': options,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);
    });

    testWidgets('build ad widget', (WidgetTester tester) async {
      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        listener: NativeAdListener(),
        request: AdRequest(),
      );

      await native.load();

      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            AdWidget widget = AdWidget(ad: native);
            Widget buildWidget = widget.createElement().build();
            expect(buildWidget, isA<PlatformViewLink>());
            return widget;
          },
        ),
      );

      await native.dispose();
    });

    testWidgets('build ad widget', (WidgetTester tester) async {
      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        listener: NativeAdListener(),
        request: AdRequest(),
      );

      await native.load();

      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            AdWidget widget = AdWidget(ad: native);
            Widget buildWidget = widget.createElement().build();
            expect(buildWidget, isA<PlatformViewLink>());
            return widget;
          },
        ),
      );

      await native.dispose();
    });

    testWidgets('warns when ad has not been loaded',
        (WidgetTester tester) async {
      final NativeAd ad = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        listener: NativeAdListener(),
        request: AdRequest(),
      );

      try {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: <Widget>[
                  AdWidget(ad: ad),
                ],
              ),
            ),
          ),
        );
      } finally {
        dynamic exception = tester.takeException();
        expect(exception, isA<FlutterError>());
        expect(
            (exception as FlutterError).toStringDeep(),
            'FlutterError\n'
            '   AdWidget requires Ad.load to be called before AdWidget is\n'
            '   inserted into the tree\n'
            '   Parameter ad is not loaded. Call Ad.load before AdWidget is\n'
            '   inserted into the tree.\n');
      }
    });

    testWidgets('warns when ad object is reused', (WidgetTester tester) async {
      final NativeAd ad = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        listener: NativeAdListener(),
        request: AdRequest(),
      );

      await ad.load();

      try {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: <Widget>[
                  AdWidget(ad: ad),
                  AdWidget(ad: ad),
                ],
              ),
            ),
          ),
        );
      } finally {
        dynamic exception = tester.takeException();
        expect(exception, isA<FlutterError>());
        expect(
            (exception as FlutterError).toStringDeep(),
            'FlutterError\n'
            '   This AdWidget is already in the Widget tree\n'
            '   If you placed this AdWidget in a list, make sure you create a new\n'
            '   instance in the builder function with a unique ad object.\n'
            '   Make sure you are not using the same ad object in more than one\n'
            '   AdWidget.\n'
            '');
      }
    });

    testWidgets('warns when the widget is reused', (WidgetTester tester) async {
      final NativeAd ad = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        listener: NativeAdListener(),
        request: AdRequest(),
      );

      await ad.load();

      final AdWidget widget = AdWidget(ad: ad);
      try {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: <Widget>[
                  widget,
                  widget,
                ],
              ),
            ),
          ),
        );
      } finally {
        dynamic exception = tester.takeException();
        expect(exception, isA<FlutterError>());
        expect(
            (exception as FlutterError).toStringDeep(),
            'FlutterError\n'
            '   This AdWidget is already in the Widget tree\n'
            '   If you placed this AdWidget in a list, make sure you create a new\n'
            '   instance in the builder function with a unique ad object.\n'
            '   Make sure you are not using the same ad object in more than one\n'
            '   AdWidget.\n'
            '');
      }
    });

    testWidgets(
        'ad objects can be reused if the widget holding the object is disposed',
        (WidgetTester tester) async {
      final NativeAd ad = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: '0',
        listener: NativeAdListener(),
        request: AdRequest(),
      );
      await ad.load();
      final AdWidget widget = AdWidget(ad: ad);
      try {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              height: 100,
              child: widget,
            ),
          ),
        );

        await tester.pumpWidget(Container());

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              height: 100,
              child: widget,
            ),
          ),
        );
      } finally {
        expect(tester.takeException(), isNull);
      }
    });

    test('load show rewarded', () async {
      RewardedAd? rewarded;
      AdRequest request = AdRequest();
      await RewardedAd.load(
          adUnitId: RewardedAd.testAdUnitId,
          request: request,
          rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (ad) {
                rewarded = ad;
              },
              onAdFailedToLoad: (error) => null),
          serverSideVerificationOptions: ServerSideVerificationOptions(
            userId: 'test-user-id',
            customData: 'test-custom-data',
          ));

      RewardedAd createdAd = instanceManager.adFor(0) as RewardedAd;
      (createdAd).rewardedAdLoadCallback.onAdLoaded(createdAd);

      expect(log, <Matcher>[
        isMethodCall('loadRewardedAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': RewardedAd.testAdUnitId,
          'request': request,
          'adManagerRequest': null,
          'serverSideVerificationOptions':
              rewarded!.serverSideVerificationOptions,
        }),
      ]);

      expect(instanceManager.adFor(0), isNotNull);
      expect(rewarded, createdAd);

      log.clear();
      await rewarded!.show(onUserEarnedReward: (ad, reward) => null);
      expect(log, <Matcher>[
        isMethodCall('showAdWithoutView', arguments: <dynamic, dynamic>{
          'adId': 0,
        })
      ]);
    });

    test('load show rewarded with $AdManagerAdRequest', () async {
      RewardedAd? rewarded;
      AdManagerAdRequest request = AdManagerAdRequest();
      await RewardedAd.loadWithAdManagerAdRequest(
          adUnitId: RewardedAd.testAdUnitId,
          adManagerRequest: request,
          rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (ad) {
                rewarded = ad;
              },
              onAdFailedToLoad: (error) => null),
          serverSideVerificationOptions: ServerSideVerificationOptions(
            userId: 'test-user-id',
            customData: 'test-custom-data',
          ));

      RewardedAd createdAd = instanceManager.adFor(0) as RewardedAd;
      (createdAd).rewardedAdLoadCallback.onAdLoaded(createdAd);

      expect(log, <Matcher>[
        isMethodCall('loadRewardedAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': RewardedAd.testAdUnitId,
          'request': null,
          'adManagerRequest': request,
          'serverSideVerificationOptions':
              rewarded!.serverSideVerificationOptions,
        }),
      ]);

      expect(instanceManager.adFor(0), isNotNull);

      log.clear();
      await rewarded!.show(onUserEarnedReward: (ad, reward) => null);
      expect(log, <Matcher>[
        isMethodCall('showAdWithoutView', arguments: <dynamic, dynamic>{
          'adId': 0,
        })
      ]);
    });

    test('load show interstitial', () async {
      InterstitialAd? interstitial;
      await InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              interstitial = ad;
            },
            onAdFailedToLoad: (error) => null),
      );

      InterstitialAd createdAd = (instanceManager.adFor(0) as InterstitialAd);
      (createdAd).adLoadCallback.onAdLoaded(createdAd);

      expect(log, <Matcher>[
        isMethodCall('loadInterstitialAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': InterstitialAd.testAdUnitId,
          'request': interstitial!.request,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);

      log.clear();
      await interstitial!.show();
      expect(log, <Matcher>[
        isMethodCall('showAdWithoutView', arguments: <dynamic, dynamic>{
          'adId': 0,
        })
      ]);
    });

    test('load show ad manager interstitial', () async {
      AdManagerInterstitialAd? interstitial;
      await AdManagerInterstitialAd.load(
        adUnitId: 'test-id',
        request: AdManagerAdRequest(),
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              interstitial = ad;
            },
            onAdFailedToLoad: (error) => null),
      );

      AdManagerInterstitialAd createdAd =
          (instanceManager.adFor(0) as AdManagerInterstitialAd);
      (createdAd).adLoadCallback.onAdLoaded(createdAd);

      expect(log, <Matcher>[
        isMethodCall('loadAdManagerInterstitialAd',
            arguments: <String, dynamic>{
              'adId': 0,
              'adUnitId': 'test-id',
              'request': interstitial!.request,
            })
      ]);

      expect(instanceManager.adFor(0), isNotNull);

      log.clear();
      await interstitial!.show();
      expect(log, <Matcher>[
        isMethodCall('showAdWithoutView', arguments: <dynamic, dynamic>{
          'adId': 0,
        })
      ]);
    });

    test('load ad manager banner', () async {
      final AdManagerBannerAd banner = AdManagerBannerAd(
        adUnitId: 'testId',
        sizes: <AdSize>[AdSize.largeBanner],
        listener: AdManagerBannerAdListener(),
        request: AdManagerAdRequest(),
      );

      await banner.load();
      expect(log, <Matcher>[
        isMethodCall('loadAdManagerBannerAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': 'testId',
          'sizes': <AdSize>[AdSize.largeBanner],
          'request': AdManagerAdRequest(),
        })
      ]);

      expect(instanceManager.adFor(0), banner);
      expect(instanceManager.adIdFor(banner), 0);
    });

    test('onAdLoaded', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(
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
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onAdFailedToLoad banner', () async {
      final Completer<List<dynamic>> resultsCompleter =
          Completer<List<dynamic>>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(
            onAdFailedToLoad: (Ad ad, LoadAdError error) =>
                resultsCompleter.complete(<dynamic>[ad, error])),
        request: AdRequest(),
      );

      await banner.load();
      AdError adError = AdError(1, 'domain', 'error-message');
      AdapterResponseInfo adapterResponseInfo = AdapterResponseInfo(
          adapterClassName: 'adapter-name',
          latencyMillis: 500,
          description: 'message',
          credentials: 'credentials',
          adError: adError);

      List<AdapterResponseInfo> adapterResponses = [adapterResponseInfo];
      ResponseInfo responseInfo = ResponseInfo(
        responseId: 'id',
        mediationAdapterClassName: 'className',
        adapterResponses: adapterResponses,
      );

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onAdFailedToLoad',
        'loadAdError': LoadAdError(1, 'domain', 'message', responseInfo),
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      final List<dynamic> results = await resultsCompleter.future;
      expect(results[0], banner);
      expect(results[1].code, 1);
      expect(results[1].domain, 'domain');
      expect(results[1].message, 'message');
      expect(results[1].responseInfo.responseId, responseInfo.responseId);
      expect(results[1].responseInfo.mediationAdapterClassName,
          responseInfo.mediationAdapterClassName);
      List<AdapterResponseInfo> responses =
          results[1].responseInfo.adapterResponses;
      expect(responses.first.adapterClassName, 'adapter-name');
      expect(responses.first.latencyMillis, 500);
      expect(responses.first.description, 'message');
      expect(responses.first.credentials, 'credentials');
      expect(responses.first.adError!.code, 1);
      expect(responses.first.adError!.message, 'error-message');
      expect(responses.first.adError!.domain, 'domain');
    });

    test('onAdFailedToLoad interstitial', () async {
      final Completer<LoadAdError> resultsCompleter = Completer<LoadAdError>();
      final AdRequest request = AdRequest();
      await InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => null,
            onAdFailedToLoad: (error) => resultsCompleter.complete(error)),
      );

      expect(log, <Matcher>[
        isMethodCall('loadInterstitialAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': InterstitialAd.testAdUnitId,
          'request': request,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);

      // Simulate onAdFailedToLoad.
      AdError adError = AdError(1, 'domain', 'error-message');
      AdapterResponseInfo adapterResponseInfo = AdapterResponseInfo(
          adapterClassName: 'adapter-name',
          latencyMillis: 500,
          description: 'message',
          credentials: 'credentials',
          adError: adError);

      List<AdapterResponseInfo> adapterResponses = [adapterResponseInfo];
      ResponseInfo responseInfo = ResponseInfo(
        responseId: 'id',
        mediationAdapterClassName: 'className',
        adapterResponses: adapterResponses,
      );

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onAdFailedToLoad',
        'loadAdError': LoadAdError(1, 'domain', 'message', responseInfo),
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      // The ad reference should be freed when load failure occurs.
      expect(instanceManager.adFor(0), isNull);

      // Check that load error matches.
      final LoadAdError result = await resultsCompleter.future;
      expect(result.code, 1);
      expect(result.domain, 'domain');
      expect(result.message, 'message');
      expect(result.responseInfo!.responseId, responseInfo.responseId);
      expect(result.responseInfo!.mediationAdapterClassName,
          responseInfo.mediationAdapterClassName);
      List<AdapterResponseInfo> responses =
          result.responseInfo!.adapterResponses!;
      expect(responses.first.adapterClassName, 'adapter-name');
      expect(responses.first.latencyMillis, 500);
      expect(responses.first.description, 'message');
      expect(responses.first.credentials, 'credentials');
      expect(responses.first.adError!.code, 1);
      expect(responses.first.adError!.message, 'error-message');
      expect(responses.first.adError!.domain, 'domain');
    });

    test('onAdFailedToLoad ad manager interstitial', () async {
      final Completer<LoadAdError> resultsCompleter = Completer<LoadAdError>();
      final AdManagerAdRequest request = AdManagerAdRequest();
      await AdManagerInterstitialAd.load(
        adUnitId: 'test-ad-unit',
        request: request,
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
            onAdLoaded: (ad) => null,
            onAdFailedToLoad: (error) => resultsCompleter.complete(error)),
      );

      expect(log, <Matcher>[
        isMethodCall('loadAdManagerInterstitialAd',
            arguments: <String, dynamic>{
              'adId': 0,
              'adUnitId': 'test-ad-unit',
              'request': request,
            })
      ]);

      expect(instanceManager.adFor(0), isNotNull);

      // Simulate onAdFailedToLoad.
      AdError adError = AdError(1, 'domain', 'error-message');
      AdapterResponseInfo adapterResponseInfo = AdapterResponseInfo(
          adapterClassName: 'adapter-name',
          latencyMillis: 500,
          description: 'message',
          credentials: 'credentials',
          adError: adError);

      List<AdapterResponseInfo> adapterResponses = [adapterResponseInfo];
      ResponseInfo responseInfo = ResponseInfo(
        responseId: 'id',
        mediationAdapterClassName: 'className',
        adapterResponses: adapterResponses,
      );

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onAdFailedToLoad',
        'loadAdError': LoadAdError(1, 'domain', 'message', responseInfo),
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      // The ad reference should be freed when load failure occurs.
      expect(instanceManager.adFor(0), isNull);

      // Check that load error matches.
      final LoadAdError result = await resultsCompleter.future;
      expect(result.code, 1);
      expect(result.domain, 'domain');
      expect(result.message, 'message');
      expect(result.responseInfo!.responseId, responseInfo.responseId);
      expect(result.responseInfo!.mediationAdapterClassName,
          responseInfo.mediationAdapterClassName);
      List<AdapterResponseInfo> responses =
          result.responseInfo!.adapterResponses!;
      expect(responses.first.adapterClassName, 'adapter-name');
      expect(responses.first.latencyMillis, 500);
      expect(responses.first.description, 'message');
      expect(responses.first.credentials, 'credentials');
      expect(responses.first.adError!.code, 1);
      expect(responses.first.adError!.message, 'error-message');
      expect(responses.first.adError!.domain, 'domain');
    });

    test('onAdFailedToLoad rewarded', () async {
      final Completer<LoadAdError> resultsCompleter = Completer<LoadAdError>();
      final AdRequest request = AdRequest();
      await RewardedAd.load(
        adUnitId: 'test-ad-unit',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => null,
            onAdFailedToLoad: (error) => resultsCompleter.complete(error)),
      );

      expect(log, <Matcher>[
        isMethodCall('loadRewardedAd', arguments: <String, dynamic>{
          'adId': 0,
          'adUnitId': 'test-ad-unit',
          'request': request,
          'adManagerRequest': null,
          'serverSideVerificationOptions': null,
        })
      ]);

      expect(instanceManager.adFor(0), isNotNull);

      // Simulate onAdFailedToLoad.
      AdError adError = AdError(1, 'domain', 'error-message');
      AdapterResponseInfo adapterResponseInfo = AdapterResponseInfo(
          adapterClassName: 'adapter-name',
          latencyMillis: 500,
          description: 'message',
          credentials: 'credentials',
          adError: adError);

      List<AdapterResponseInfo> adapterResponses = [adapterResponseInfo];
      ResponseInfo responseInfo = ResponseInfo(
        responseId: 'id',
        mediationAdapterClassName: 'className',
        adapterResponses: adapterResponses,
      );

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onAdFailedToLoad',
        'loadAdError': LoadAdError(1, 'domain', 'message', responseInfo),
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      // The ad reference should be freed when load failure occurs.
      expect(instanceManager.adFor(0), isNull);

      // Check that load error matches.
      final LoadAdError result = await resultsCompleter.future;
      expect(result.code, 1);
      expect(result.domain, 'domain');
      expect(result.message, 'message');
      expect(result.responseInfo!.responseId, responseInfo.responseId);
      expect(result.responseInfo!.mediationAdapterClassName,
          responseInfo.mediationAdapterClassName);
      List<AdapterResponseInfo> responses =
          result.responseInfo!.adapterResponses!;
      expect(responses.first.adapterClassName, 'adapter-name');
      expect(responses.first.latencyMillis, 500);
      expect(responses.first.description, 'message');
      expect(responses.first.credentials, 'credentials');
      expect(responses.first.adError!.code, 1);
      expect(responses.first.adError!.message, 'error-message');
      expect(responses.first.adError!.domain, 'domain');
    });

    test('onNativeAdClicked', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: 'testId',
        listener: NativeAdListener(
            onNativeAdClicked: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await native.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onNativeAdClicked'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      expect(adEventCompleter.future, completion(native));
    });

    test('onNativeAdImpression', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final NativeAd native = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: 'testId',
        listener: NativeAdListener(
            onAdImpression: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await native.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onAdImpression'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      expect(adEventCompleter.future, completion(native));
    });

    test('onAdOpened', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(
            onAdOpened: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onAdOpened'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onAdClosed', () async {
      final Completer<Ad> adEventCompleter = Completer<Ad>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(
            onAdClosed: (Ad ad) => adEventCompleter.complete(ad)),
        request: AdRequest(),
      );

      await banner.load();

      final MethodCall methodCall = MethodCall('onAdEvent',
          <dynamic, dynamic>{'adId': 0, 'eventName': 'onAdClosed'});

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      expect(adEventCompleter.future, completion(banner));
    });

    test('onRewardedAdUserEarnedReward', () async {
      final Completer<List<dynamic>> resultCompleter =
          Completer<List<dynamic>>();

      RewardedAd? rewarded;
      await RewardedAd.load(
          adUnitId: RewardedAd.testAdUnitId,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (ad) {
                rewarded = ad;
              },
              onAdFailedToLoad: (error) => null),
          serverSideVerificationOptions: ServerSideVerificationOptions(
            userId: 'test-user-id',
            customData: 'test-custom-data',
          ));

      RewardedAd createdAd = instanceManager.adFor(0) as RewardedAd;
      createdAd.rewardedAdLoadCallback.onAdLoaded(createdAd);
      // Reward callback is now set when you call show.
      await rewarded!.show(
          onUserEarnedReward: (ad, item) =>
              resultCompleter.complete(<Object>[ad, item]));

      final MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onRewardedAdUserEarnedReward',
        'rewardItem': RewardItem(1, 'one'),
      });

      final ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      final List<dynamic> result = await resultCompleter.future;
      expect(result[0], rewarded!);
      expect(result[1].amount, 1);
      expect(result[1].type, 'one');
    });

    test('onPaidEvent', () async {
      Completer<List<dynamic>> resultCompleter = Completer<List<dynamic>>();

      final BannerAd banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(
          onPaidEvent: (Ad ad, double value, precision, String currencyCode) =>
              resultCompleter
                  .complete(<Object>[ad, value, precision, currencyCode]),
        ),
        request: AdRequest(),
      );

      await banner.load();

      // Check precision type: unknown
      MethodCall methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onPaidEvent',
        'valueMicros': 1.2345,
        'precision': 0,
        'currencyCode': 'USD',
      });

      ByteData data =
          instanceManager.channel.codec.encodeMethodCall(methodCall);

      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        data,
        (ByteData? data) {},
      );

      List<dynamic> result = await resultCompleter.future;
      expect(result[0], banner);
      expect(result[1], 1.2345);
      expect(result[2], PrecisionType.unknown);
      expect(result[3], 'USD');

      // Unknown precision outside 0-3 range.
      resultCompleter = Completer<List<dynamic>>();
      methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onPaidEvent',
        'valueMicros': 1.2345,
        'precision': 9999,
        'currencyCode': 'USD',
      });
      data = instanceManager.channel.codec.encodeMethodCall(methodCall);
      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        instanceManager.channel.codec.encodeMethodCall(methodCall),
        (ByteData? data) {},
      );
      result = await resultCompleter.future;
      expect(result[2], PrecisionType.unknown);

      // Check precision type: estimated.
      // Also check that callback is invoked successfully for int valueMicros.
      resultCompleter = Completer<List<dynamic>>();
      methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onPaidEvent',
        'valueMicros': 12345, // int
        'precision': 1,
        'currencyCode': 'USD',
      });
      data = instanceManager.channel.codec.encodeMethodCall(methodCall);
      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        instanceManager.channel.codec.encodeMethodCall(methodCall),
        (ByteData? data) {},
      );
      result = await resultCompleter.future;
      expect(result[1], 12345);
      expect(result[2], PrecisionType.estimated);

      // Check precision type: publisherProvided.
      resultCompleter = Completer<List<dynamic>>();
      methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onPaidEvent',
        'valueMicros': 1.2345,
        'precision': 2,
        'currencyCode': 'USD',
      });
      data = instanceManager.channel.codec.encodeMethodCall(methodCall);
      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        instanceManager.channel.codec.encodeMethodCall(methodCall),
        (ByteData? data) {},
      );
      result = await resultCompleter.future;
      expect(result[2], PrecisionType.publisherProvided);

      // Check precision type: precise.
      resultCompleter = Completer<List<dynamic>>();
      methodCall = MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': 0,
        'eventName': 'onPaidEvent',
        'valueMicros': 1.2345,
        'precision': 3,
        'currencyCode': 'USD',
      });
      data = instanceManager.channel.codec.encodeMethodCall(methodCall);
      await instanceManager.channel.binaryMessenger.handlePlatformMessage(
        'plugins.flutter.io/google_mobile_ads',
        instanceManager.channel.codec.encodeMethodCall(methodCall),
        (ByteData? data) {},
      );
      result = await resultCompleter.future;
      expect(result[2], PrecisionType.precise);
    });

    test('encode/decode AdSize', () async {
      final ByteData byteData = codec.encodeMessage(AdSize.banner)!;
      expect(codec.decodeMessage(byteData), AdSize.banner);
    });

    test('encode/decode AdRequest', () async {
      final AdRequest adRequest = AdRequest(
          keywords: <String>['1', '2', '3'],
          contentUrl: 'contentUrl',
          nonPersonalizedAds: false);

      final ByteData byteData = codec.encodeMessage(adRequest)!;
      expect(codec.decodeMessage(byteData), adRequest);
    });

    test('encode/decode $LoadAdError', () async {
      final ResponseInfo responseInfo = ResponseInfo(
          responseId: 'id',
          mediationAdapterClassName: 'class',
          adapterResponses: null);
      final ByteData byteData = codec.encodeMessage(
        LoadAdError(1, 'domain', 'message', responseInfo),
      )!;
      final LoadAdError error = codec.decodeMessage(byteData);
      expect(error.code, 1);
      expect(error.domain, 'domain');
      expect(error.message, 'message');
      expect(error.responseInfo?.responseId, responseInfo.responseId);
      expect(error.responseInfo?.mediationAdapterClassName,
          responseInfo.mediationAdapterClassName);
      expect(error.responseInfo?.adapterResponses, null);
    });

    test('encode/decode $RewardItem', () async {
      final ByteData byteData = codec.encodeMessage(RewardItem(1, 'type'))!;

      final RewardItem result = codec.decodeMessage(byteData);
      expect(result.amount, 1);
      expect(result.type, 'type');
    });

    test('encode/decode $AnchoredAdaptiveBannerAdSize', () async {
      final ByteData byteData = codec.encodeMessage(
          AnchoredAdaptiveBannerAdSize(Orientation.landscape,
              width: 23, height: 34))!;

      final AnchoredAdaptiveBannerAdSize result = codec.decodeMessage(byteData);
      expect(result.orientation, Orientation.landscape);
      expect(result.width, 23);
      expect(result.height, -1);
    });

    test('encode/decode $SmartBannerAdSize', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final ByteData byteData =
          codec.encodeMessage(SmartBannerAdSize(Orientation.portrait))!;

      final SmartBannerAdSize result = codec.decodeMessage(byteData);
      expect(result.orientation, Orientation.portrait);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final WriteBuffer expectedBuffer = WriteBuffer();
      expectedBuffer.putUint8(143);

      final WriteBuffer actualBuffer = WriteBuffer();
      codec.writeAdSize(actualBuffer, SmartBannerAdSize(Orientation.portrait));
      expect(
        expectedBuffer.done().buffer.asInt8List(),
        actualBuffer.done().buffer.asInt8List(),
      );
    });

    test('encode/decode $AdManagerAdRequest', () async {
      final ByteData byteData = codec.encodeMessage(AdManagerAdRequest(
        keywords: <String>['who'],
        contentUrl: 'dat',
        customTargeting: <String, String>{'boy': 'who'},
        customTargetingLists: <String, List<String>>{
          'him': <String>['is']
        },
        nonPersonalizedAds: true,
      ))!;

      expect(
        codec.decodeMessage(byteData),
        AdManagerAdRequest(
          keywords: <String>['who'],
          contentUrl: 'dat',
          customTargeting: <String, String>{'boy': 'who'},
          customTargetingLists: <String, List<String>>{
            'him': <String>['is'],
          },
          nonPersonalizedAds: true,
        ),
      );
    });
  });
}
