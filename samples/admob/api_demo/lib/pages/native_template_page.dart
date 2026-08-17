import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// An example page that loads a native ad using Native Templates.
class NativeTemplatePage extends StatefulWidget {
  const NativeTemplatePage({super.key});

  @override
  State<NativeTemplatePage> createState() => _NativeTemplatePageState();
}

class _NativeTemplatePageState extends State<NativeTemplatePage> {
  final _consentManager = ConsentManager.instance;
  var _isPrivacyOptionsRequired = false;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final double _adAspectRatioMedium = (370 / 355);

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();
    _getIsPrivacyOptionsRequired();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final adHeight = MediaQuery.of(context).size.width * _adAspectRatioMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Template Ad'),
        actions: _appBarActions(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              const Text(
                'Native Template Ad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Rendered directly in Flutter using the NativeTemplateStyle API without platform-specific UI code.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: adHeight,
                      width: MediaQuery.of(context).size.width,
                      child: !_nativeAdIsLoaded
                          ? const Center(child: CircularProgressIndicator())
                          : null,
                    ),
                    if (_nativeAdIsLoaded && _nativeAd != null)
                      SizedBox(
                        height: adHeight,
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _nativeAd!),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAd,
                child: const Text('Refresh Ad'),
              ),
              const SizedBox(height: 12),
              FutureBuilder<String>(
                future: MobileAds.instance.getVersionString(),
                builder: (context, snapshot) {
                  var versionString = snapshot.data ?? '';
                  return Text(
                    'GMA SDK: $versionString',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    var array = [AppBarItem(AppBarItem.adInpsectorText, 0)];

    if (_isPrivacyOptionsRequired) {
      array.add(AppBarItem(AppBarItem.privacySettingsText, 1));
    }

    return <Widget>[
      PopupMenuButton<AppBarItem>(
        itemBuilder: (context) => array
            .map(
              (item) => PopupMenuItem<AppBarItem>(
                value: item,
                child: Text(item.label),
              ),
            )
            .toList(),
        onSelected: (item) {
          switch (item.value) {
            case 0:
              MobileAds.instance.openAdInspector((error) {});
            case 1:
              _consentManager.showPrivacyOptionsForm((formError) {
                if (formError != null) {
                  debugPrint('${formError.errorCode}: ${formError.message}');
                }
              });
          }
        },
      ),
    ];
  }

  /// Loads a native template ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    setState(() {
      _nativeAdIsLoaded = false;
    });
    _nativeAd?.dispose();
    _nativeAd = null;

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeTemplateAd loaded.');
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeTemplateAd failedToLoad: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = false;
            });
          }
        },
        onAdClicked: (ad) => debugPrint('NativeTemplateAd clicked.'),
        onAdImpression: (ad) =>
            debugPrint('NativeTemplateAd recorded impression.'),
        onAdClosed: (ad) => debugPrint('NativeTemplateAd closed.'),
        onAdOpened: (ad) => debugPrint('NativeTemplateAd opened.'),
        onAdWillDismissScreen: (ad) =>
            debugPrint('NativeTemplateAd will dismiss.'),
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: const Color(0xfffffbed),
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.italic,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
    )..load();
  }

  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      if (mounted) {
        setState(() {
          _isPrivacyOptionsRequired = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
