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
import 'app_lifecycle_reactor.dart';
import 'app_open_ad_manager.dart';

import 'consent_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Example home page for an app open ad.
class _HomePageState extends State<HomePage> {
  static const privacySettingsText = 'Privacy Settings';

  final _appOpenAdManager = AppOpenAdManager();
  var _isMobileAdsInitializeCalled = false;
  int _counter = 0;
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();

    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: _appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();

    ConsentManager.instance.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint(
            "${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();
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
        title: const Text('App Open Demo Home Page'),
        actions: _isMobileAdsInitializeCalled
            ? _privacySettingsAppBarAction()
            : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> _privacySettingsAppBarAction() {
    return <Widget>[
      // Regenerate the options menu to include a privacy setting.
      FutureBuilder(
          future: ConsentManager.instance.isPrivacyOptionsRequired(),
          builder: (context, snapshot) {
            final bool visibility = snapshot.data ?? false;
            return Visibility(
                visible: visibility,
                child: PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == privacySettingsText) {
                      ConsentManager.instance
                          .showPrivacyOptionsForm((formError) {
                        if (formError != null) {
                          debugPrint(
                              "${formError.errorCode}: ${formError.message}");
                        }
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        value: privacySettingsText,
                        child: Text(privacySettingsText))
                  ],
                ));
          })
    ];
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    var canRequestAds = await ConsentManager.instance.canRequestAds();
    if (canRequestAds) {
      setState(() {
        _isMobileAdsInitializeCalled = true;
      });

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();
      // Load an ad.
      _appOpenAdManager.loadAd();
    }
  }
}
