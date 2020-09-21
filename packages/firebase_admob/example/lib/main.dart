// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = 'YOUR_DEVICE_ID';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final AdRequest request = AdRequest(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd _bannerAd;
  bool _bannerReady = false;

  NativeAd _nativeAd;
  bool _nativeReady = false;

  InterstitialAd _interstitialAd;
  bool _interstitialReady = false;

  RewardedAd _rewardedAd;
  bool _rewardedReady = false;

  void createBannerAd() {
    _bannerAd ??= BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      request: request,
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          setState(() => _bannerReady = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error');
          setState(() {
            _bannerAd.dispose();
            _bannerAd = null;
          });
        },
        onAdOpened: onAdOpened,
        onAdClosed: onAdClosed,
        onApplicationExit: onApplicationExit,
      ),
    )..load();
  }

  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          setState(() => _interstitialReady = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) => setState(() {
          print('${ad.runtimeType} failed to load: $error');
          _interstitialAd.dispose();
          _interstitialAd = null;
        }),
        onAdOpened: onAdOpened,
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          setState(() {
            _interstitialAd.dispose();
            _interstitialAd = null;
          });
        },
        onApplicationExit: onApplicationExit,
      ),
    )..load();
  }

  void createNativeAd() {
    _nativeAd ??= NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      request: request,
      factoryId: 'adFactoryExample',
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          setState(() => _nativeReady = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) => setState(() {
          print('${ad.runtimeType} failed to load: $error');
          _nativeAd.dispose();
          _nativeAd = null;
        }),
        onAdOpened: onAdOpened,
        onAdClosed: onAdClosed,
        onApplicationExit: onApplicationExit,
        onNativeAdClicked: onNativeAdClicked,
        onNativeAdImpression: onNativeAdImpression,
      ),
    )..load();
  }

  void createRewardedAd() {
    _rewardedAd ??= RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          setState(() => _rewardedReady = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) => setState(() {
          print('${ad.runtimeType} failed to load: error');
          _rewardedAd.dispose();
          _rewardedAd = null;
        }),
        onAdOpened: onAdOpened,
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          setState(() {
            _rewardedAd.dispose();
            _rewardedAd = null;
          });
        },
        onApplicationExit: onApplicationExit,
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) =>
            onRewardedAdUserEarnedReward(ad, reward),
      ),
    )..load();
  }

  void onAdOpened(Ad ad) => print('${ad.runtimeType} opened.');

  void onAdClosed(Ad ad) => print('${ad.runtimeType} closed.');

  void onApplicationExit(Ad ad) =>
      print('${ad.runtimeType} leaving application.');

  void onNativeAdClicked(NativeAd ad) => print('${ad.runtimeType} clicked.');

  void onNativeAdImpression(NativeAd ad) =>
      print('${ad.runtimeType} impression.');

  void onRewardedAdUserEarnedReward(RewardedAd ad, RewardItem reward) => print(
        '${ad.runtimeType} with reward: $RewardItem(${reward.amount}, ${reward.type})',
      );

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AdMob Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  child: Text('Load $BannerAd'),
                  onPressed: _bannerAd == null ? createBannerAd : null,
                ),
                Container(
                  alignment: Alignment.center,
                  child: _bannerReady ? AdWidget(ad: _bannerAd) : Container(),
                  width: _bannerReady ? _bannerAd.size.width.toDouble() : 0,
                  height: _bannerReady ? _bannerAd.size.height.toDouble() : 0,
                ),
                RaisedButton(
                  child: Text('Load $NativeAd'),
                  onPressed: _nativeAd == null ? createNativeAd : null,
                ),
                Container(
                  alignment: Alignment.center,
                  child: _nativeReady ? AdWidget(ad: _nativeAd) : Container(),
                  width: _nativeReady ? 300 : 0,
                  height: _nativeReady ? 300 : 0,
                ),
                RaisedButton(
                  child: Text('Load $InterstitialAd'),
                  onPressed: _interstitialAd == null
                      ? () => setState(() => createInterstitialAd())
                      : null,
                ),
                RaisedButton(
                  child: Text('Show $InterstitialAd'),
                  onPressed: _interstitialReady
                      ? () {
                          setState(() {
                            _interstitialAd.show();
                            _interstitialReady = false;
                          });
                        }
                      : null,
                ),
                RaisedButton(
                  child: Text('Load $RewardedAd'),
                  onPressed: _rewardedAd == null
                      ? () => setState(() => createRewardedAd())
                      : null,
                ),
                RaisedButton(
                  child: Text('Show $RewardedAd'),
                  onPressed: _rewardedReady
                      ? () {
                          setState(() {
                            _rewardedAd.show();
                            _rewardedReady = false;
                          });
                        }
                      : null,
                ),
              ].map((Widget button) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: button,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
