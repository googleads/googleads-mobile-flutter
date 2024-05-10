import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'consent_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: NativeExample(),
  ));
}

/// A simple app that loads a native ad.
class NativeExample extends StatefulWidget {
  const NativeExample({super.key});

  @override
  NativeExampleState createState() => NativeExampleState();
}

class NativeExampleState extends State<NativeExample> {
  static const privacySettingsText = 'Privacy Settings';

  final _consentManager = ConsentManager();
  final double _nativeAdHeight = Platform.isAndroid ? 320 : 300;
  var _isMobileAdsInitializeCalled = false;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Native Example',
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Native Example'),
                actions: _isMobileAdsInitializeCalled
                    ? _privacySettingsAppBarAction()
                    : null),
            body: Center(
              child: Column(
                children: [
                  Stack(children: [
                    SizedBox(
                        height: _nativeAdHeight,
                        width: MediaQuery.of(context).size.width),
                    if (_nativeAdIsLoaded && _nativeAd != null)
                      SizedBox(
                          height: _nativeAdHeight,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _nativeAd!))
                  ]),
                  TextButton(
                      onPressed: _loadAd, child: const Text("Refresh Ad")),
                  FutureBuilder(
                      future: MobileAds.instance.getVersionString(),
                      builder: (context, snapshot) {
                        var versionString = snapshot.data ?? "";
                        return Text(versionString);
                      })
                ],
              ),
            )));
  }

  List<Widget> _privacySettingsAppBarAction() {
    return <Widget>[
      // Regenerate the options menu to include a privacy setting.
      FutureBuilder(
          future: _consentManager.isPrivacyOptionsRequired(),
          builder: (context, snapshot) {
            final bool visibility = snapshot.data ?? false;
            return Visibility(
                visible: visibility,
                child: PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == privacySettingsText) {
                      _consentManager.showPrivacyOptionsForm((formError) {
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

  /// Loads a native ad.
  void _loadAd() async {
    // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // the app's configured messages.
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    setState(() {
      _nativeAdIsLoaded = false;
    });

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          // ignore: avoid_print
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // ignore: avoid_print
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {},
        onAdImpression: (ad) {},
        onAdClosed: (ad) {},
        onAdOpened: (ad) {},
        onAdWillDismissScreen: (ad) {},
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
    )..load();
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    var canRequestAds = await _consentManager.canRequestAds();
    if (canRequestAds) {
      setState(() {
        _isMobileAdsInitializeCalled = true;
      });

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();
      // Load an ad.
      _loadAd();
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
