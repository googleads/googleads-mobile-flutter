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

import 'app_bar_item.dart';
import 'my_method_channel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the SDK before making an ad request.
  // You can check each adapter's initialization status in the callback.
  MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
  runApp(MyApp());
}

/// An example app that loads an ad and shows a button which increments a counter.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mediation Example',
      theme: ThemeData(primarySwatch: Colors.blue),
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

class _MyHomePageState extends State<MyHomePage> {
  BannerAd? _bannerAd;
  bool _bannerIsLoaded = false;
  int _counter = 0;
  static MyMethodChannel platform = MyMethodChannel();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    platform.setAppLovinIsAgeRestrictedUser(true);
    platform.setHasUserConsent(false);
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: '<your-ad-unit>',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint(
            '$ad loaded: ${ad.responseInfo?.mediationAdapterClassName}',
          );
          setState(() {
            _bannerIsLoaded = true;
          });
        },
        onAdFailedToLoad:
            (ad, error) => debugPrint('$ad failed to load: ${error.message}'),
      ),
      request: AdRequest(nonPersonalizedAds: true),
    )..load();
  }

  List<Widget> _appBarActions() {
    final adInspectorMenuItem = AppBarItem(AppBarItem.adInpsectorText, 0);

    return <Widget>[
      PopupMenuButton<AppBarItem>(
        itemBuilder:
            (BuildContext context) => <PopupMenuEntry<AppBarItem>>[
              PopupMenuItem<AppBarItem>(
                value: adInspectorMenuItem,
                child: Text(adInspectorMenuItem.label),
              ),
            ],
        onSelected: (item) {
          MobileAds.instance.openAdInspector((error) {
            // Error will be non-null if ad inspector closed due to an error.
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: _appBarActions()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            _bannerIsLoaded && _bannerAd != null
                ? Container(
                  height: _bannerAd!.size.height.toDouble(),
                  width: _bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
                : Text('ad is not loaded'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
