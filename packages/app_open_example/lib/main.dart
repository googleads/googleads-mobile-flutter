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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Open Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  final Duration maxCacheDuration = Duration(hours: 4);

  int _counter = 0;

  DateTime? _appOpenLoadTime;
  AppOpenAd? _appOpenAd;
  bool _isShowingAppOpenAd = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _loadAppOpenAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Try to show an app open ad if the app is being resumed, and
    // we're not already showing an app open ad.
    if (state == AppLifecycleState.resumed
        && _appOpenAd != null
        && !_isShowingAppOpenAd) {
      _showAppOpenAd();
    }
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/3419835294',
      orientation: 1,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded');
            _appOpenLoadTime = DateTime.now();
            _appOpenAd = ad;
          },
          onAdFailedToLoad: (error) {
            print('AppOpenAd failed to load: $error');
          }),);
  }

  void _showAppOpenAd() {
    if (_appOpenAd == null || _appOpenLoadTime == null) {
      print('Tried to show app open ad before it was loaded!');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      _loadAppOpenAd();
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdImpression: (ad) {
        print('$ad onAdImpression');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        print('$ad onAdFailedToShowFullScreenContent: $error');
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        print('$ad onAdDismissedFullScreenContent');
        ad.dispose();
        _appOpenAd = null;
        _loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
