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

// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'reusable_inline_example.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = 'YOUR_DEVICE_ID';
const int maxFailedLoadAttempts = 3;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final InterstitialRetryLoader _interstitialLoader =
      InterstitialRetryLoader((InterstitialAd ad) => _interstitialAd = ad);
  InterstitialAd? _interstitialAd;

  late final RewardedAdRetryLoader _rewardedAdLoader =
      RewardedAdRetryLoader((RewardedAd ad) => _rewardedAd = ad);
  RewardedAd? _rewardedAd;

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;
  bool _anchoredBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _interstitialLoader.load();
    _rewardedAdLoader.load();
  }

  void _showInterstitialAd() {
    final InterstitialAd? interstitialAd = _interstitialAd;
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd.show(_interstitialLoader);
    _interstitialAd = null;
  }

  void _showRewardedAd() {
    final RewardedAd? rewardedAd = _rewardedAd;
    if (rewardedAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    rewardedAd.show(
      onUserEarnedReward: _rewardedAdLoader,
      serverSideVerificationOptions: ServerSideVerificationOptions(
        userId: '23',
        customData: 'hi',
      ),
    );
    _rewardedAd = null;
  }

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AdSize? size = await AdSize.getPortraitAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredBanner = BannerAd(
      size: size,
      request: AdRequest()
        // ignore: unawaited_futures
        ..addKeyword('foo')
        // ignore: unawaited_futures
        ..addKeyword('bar')
        // ignore: unawaited_futures
        ..setContentUrl('http://foo.com/bar.html'),
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: MyAdListener(onAdReadyToShow: () {
        _anchoredBannerAdLoaded = true;
      }),
    );
    return _anchoredBanner!.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        if (!_loadingAnchoredBanner) {
          _loadingAnchoredBanner = true;
          _createAnchoredBanner(context);
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('AdMob Plugin example app'),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case 'InterstitialAd':
                      _showInterstitialAd();
                      break;
                    case 'RewardedAd':
                      _showRewardedAd();
                      break;
                    default:
                      throw AssertionError('unexpected button: $result');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: '$InterstitialAd',
                    child: Text('$InterstitialAd'),
                  ),
                  PopupMenuItem<String>(
                    value: '$RewardedAd',
                    child: Text('$RewardedAd'),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                ReusableInlineExample(),
                if (_anchoredBannerAdLoaded)
                  Container(
                    color: Colors.green,
                    width: _anchoredBanner!.size.width.toDouble(),
                    height: _anchoredBanner!.size.height.toDouble(),
                    child: AdWidget(ad: _anchoredBanner!),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class InterstitialRetryLoader
    implements InterstitialAdLoadCallback, FullScreenContentCallback {
  InterstitialRetryLoader(this.onAdReadyToShow);

  final Function(InterstitialAd ad) onAdReadyToShow;

  int _numLoadAttempts = 0;

  void load() {
    InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest()
        ..addKeyword('foo')
        ..addKeyword('bar')
        ..setContentUrl('http://foo.com/bar.html')
        ..setNonPersonalizedAds(true),
      adLoadCallback: this,
    );
  }

  @override
  void onAdFailedToLoad(covariant LoadAdError error) {
    _numLoadAttempts += 1;
    if (_numLoadAttempts <= maxFailedLoadAttempts) {
      load();
    }
  }

  @override
  void onAdLoaded(covariant InterstitialAd ad) {
    _numLoadAttempts = 0;
    onAdReadyToShow(ad);
  }

  @override
  void onAdDismissedFullScreenContent() {
    print('Ad dismissed full screen content');
    load();
  }

  @override
  void onAdFailedToShowFullScreenContent() {
    print('Ad dismissed full screen content.');
    load();
  }

  @override
  void onAdImpression() {
    print('Ad impression.');
  }

  @override
  void onAdShowedFullScreenContent() {
    print('Ad showed full screen content.');
  }

  @override
  void onAdWillDismissFullScreenContent() {
    print('Ad will dismiss full screen content');
  }
}

class RewardedAdRetryLoader
    implements
        RewardedAdLoadCallback,
        FullScreenContentCallback,
        OnUserEarnedRewardListener {
  RewardedAdRetryLoader(this.onAdReadyToShow);

  final Function(RewardedAd ad) onAdReadyToShow;

  int _numLoadAttempts = 0;

  void load() {
    RewardedAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest()
        ..addKeyword('foo')
        ..addKeyword('bar')
        ..setContentUrl('http://foo.com/bar.html')
        ..setNonPersonalizedAds(true),
      adLoadCallback: this,
    );
  }

  @override
  void onAdFailedToLoad(covariant LoadAdError error) {
    _numLoadAttempts += 1;
    if (_numLoadAttempts <= maxFailedLoadAttempts) {
      load();
    }
  }

  @override
  void onAdLoaded(covariant RewardedAd ad) {
    _numLoadAttempts = 0;
    onAdReadyToShow(ad);
  }

  @override
  void onAdDismissedFullScreenContent() {
    print('Ad dismissed full screen content');
    load();
  }

  @override
  void onAdFailedToShowFullScreenContent() {
    print('Ad dismissed full screen content.');
    load();
  }

  @override
  void onAdImpression() {
    print('Ad impression.');
  }

  @override
  void onAdShowedFullScreenContent() {
    print('Ad showed full screen content.');
  }

  @override
  void onAdWillDismissFullScreenContent() {
    print('Ad will dismiss full screen content');
  }

  @override
  void onUserEarnedRewardCallback(covariant RewardItem reward) {
    print('User earned reward callback: $reward.');
  }
}
