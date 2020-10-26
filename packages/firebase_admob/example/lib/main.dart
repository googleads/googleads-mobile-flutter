// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

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

  final List<String> _article = <String>[
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'
        ' tempor incididunt ut labore et dolore magna aliqua. Faucibus purus in'
        ' massa tempor. Quis enim lobortis scelerisque fermentum dui faucibus'
        ' in. Nibh praesent tristique magna sit amet purus gravida quis.'
        ' Magna sit amet purus gravida quis blandit turpis cursus in. Sed'
        ' adipiscing diam donec adipiscing tristique. Urna porttitor rhoncus'
        ' dolor purus non enim praesent. Pellentesque habitant morbi tristique'
        ' senectus et netus. Risus ultricies tristique nulla aliquet enim tortor'
        ' at.',
    'Eget dolor morbi non arcu. Nec sagittis aliquam malesuada bibendum. Nec'
        ' feugiat nisl pretium fusce id velit ut. Volutpat commodo sed egestas'
        ' egestas. Ultrices neque ornare aenean euismod elementum. Consequat'
        ' semper viverra nam libero justo laoreet sit amet cursus. Fusce ut'
        ' placerat orci nulla pellentesque dignissim. Justo donec enim diam'
        ' vulputate ut pharetra sit amet.',
    'Et malesuada fames ac turpis egestas maecenas. Augue ut lectus arcu'
        ' bibendum at varius. Mauris rhoncus aenean vel elit scelerisque mauris'
        ' pellentesque pulvinar. Faucibus a pellentesque sit amet porttitor'
        ' eget dolor.'
  ];

  InterstitialAd _interstitialAd;
  bool _interstitialReady = false;

  RewardedAd _rewardedAd;
  bool _rewardedReady = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      createInterstitialAd();
      createRewardedAd();
    });
  }

  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
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
            _rewardedReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('${ad.runtimeType} failed to load: $error');
            ad.dispose();
            _rewardedAd = null;
            createRewardedAd();
          },
          onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
          onAdClosed: (Ad ad) {
            print('${ad.runtimeType} closed.');
            ad.dispose();
            createRewardedAd();
          },
          onApplicationExit: (Ad ad) =>
              print('${ad.runtimeType} onApplicationExit.'),
          onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
            print(
              '$RewardedAd with reward $RewardItem(${reward.amount}, ${reward.type})',
            );
          }),
    )..load();
  }

  @override
  void dispose() {
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
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String result) {
                assert(result == 'InterstitialAd' || result == 'RewardedAd');
                switch (result) {
                  case 'InterstitialAd':
                    if (!_interstitialReady) return;
                    _interstitialAd.show();
                    _interstitialReady = false;
                    _interstitialAd = null;
                    break;
                  case 'RewardedAd':
                    if (!_rewardedReady) return;
                    _rewardedAd.show();
                    _rewardedReady = false;
                    _rewardedAd = null;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: Text('$InterstitialAd'),
                  value: '$InterstitialAd',
                ),
                PopupMenuItem<String>(
                  child: Text('$RewardedAd'),
                  value: '$RewardedAd',
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            cacheExtent: 500,
            itemCount: 100,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 40,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              if (index % 2 == 0) {
                return Text(
                  _article[(index / 2).ceil() % 3],
                  style: TextStyle(fontSize: 24),
                );
              }

              final int adIndex = (index / 2).floor();
              Widget adWidget;
              if (adIndex % 3 == 0) {
                adWidget = BannerAdWidget(AdSize.banner);
              } else if (adIndex % 3 == 1) {
                adWidget = BannerAdWidget(AdSize.largeBanner);
              } else {
                adWidget = NativeAdWidget();
              }
              return Center(child: adWidget);
            },
          ),
        ),
      ),
    );
  }
}

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget(this.size);

  final AdSize size;

  @override
  State<StatefulWidget> createState() => BannerAdState();
}

class BannerAdState extends State<BannerAdWidget> {
  BannerAd _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      request: AdRequest(),
      size: widget.size,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(null);
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    Future<void>.delayed(Duration(seconds: 1), () => _bannerAd?.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd);
            } else {
              child = Text('Error loading $BannerAd');
            }
        }

        return Container(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
          child: child,
          color: Colors.blueGrey,
        );
      },
    );
  }
}

class NativeAdWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NativeAdState();
}

class NativeAdState extends State<NativeAdWidget> {
  NativeAd _nativeAd;
  final Completer<NativeAd> nativeAdCompleter = Completer<NativeAd>();

  @override
  void initState() {
    super.initState();
    _nativeAd = NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          nativeAdCompleter.complete(ad as NativeAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          nativeAdCompleter.completeError(null);
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$NativeAd onApplicationExit.'),
      ),
    );
    Future<void>.delayed(Duration(seconds: 1), () => _nativeAd?.load());
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
    _nativeAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NativeAd>(
      future: nativeAdCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<NativeAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _nativeAd);
            } else {
              child = Text('Error loading $NativeAd');
            }
        }

        return Container(
          width: 250,
          height: 350,
          child: child,
          color: Colors.blueGrey,
        );
      },
    );
  }
}

void main() {
  runApp(MyApp());
}
