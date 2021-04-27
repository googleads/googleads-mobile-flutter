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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final AdRequest request = AdRequest(
    testDevices: <String>[testDevice],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  late InterstitialAd _interstitialAd;
  bool _interstitialReady = false;

  late RewardedAd _rewardedAd;
  bool _rewardedReady = false;

  @override
  void initState() {
    super.initState();
  }

  void createInterstitialAd() {
    _interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$InterstitialAd loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$InterstitialAd failed to load: $error.');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$InterstitialAd onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('$InterstitialAd closed.');
          ad.dispose();
          createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('$InterstitialAd onApplicationExit.'),
      ),
    )..load();
  }

  void createRewardedAd() {
    _rewardedAd = RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: request,
      listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('$RewardedAd loaded.');
            _rewardedReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$RewardedAd failed to load: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$RewardedAd onAdOpened.'),
          onAdClosed: (Ad ad) {
            print('$RewardedAd closed.');
            ad.dispose();
            createRewardedAd();
          },
          onApplicationExit: (Ad ad) => print('$RewardedAd onApplicationExit.'),
          onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
            print(
              '$RewardedAd with reward $RewardItem(${reward.amount}, ${reward.type})',
            );
          }),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();

    _interstitialAd.dispose();
    _rewardedAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text('AdMob Plugin example app'),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case 'InterstitialAd':
                      if (!_interstitialReady) return;
                      _interstitialAd.show();
                      _interstitialReady = false;
                      break;
                    case 'RewardedAd':
                      if (!_rewardedReady) return;
                      _rewardedAd.show();
                      _rewardedReady = false;
                      break;
                    case 'ReusableInlineExample':
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ReusableInlineExample()),
                      );
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
                  PopupMenuItem<String>(
                    value: '$ReusableInlineExample',
                    child: Text('Reusable Inline Ads Object Example'),
                  ),
                ],
              ),
            ],
          ),
          body: ReusableInlineExample(),
        ),
      ),
    );
  }
}
