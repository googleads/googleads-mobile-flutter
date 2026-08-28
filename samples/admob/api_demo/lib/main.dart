import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'common/app_bar_item.dart';
import 'common/consent_manager.dart';
import 'pages/ad_preloading_page.dart';
import 'pages/app_open_page.dart';
import 'pages/banner_page.dart';
import 'pages/interstitial_page.dart';
import 'pages/native_platform_page.dart';
import 'pages/native_template_page.dart';
import 'pages/rewarded_page.dart';
import 'pages/rewarded_interstitial_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ApiDemoApp());
}

/// The root application widget.
class ApiDemoApp extends StatelessWidget {
  const ApiDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Mobile Ads API Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LandingPage(),
    );
  }
}

/// A format item model for building the menu.
class _AdFormatItem {
  final String title;
  final String description;
  final Widget Function(BuildContext) builder;

  const _AdFormatItem({
    required this.title,
    required this.description,
    required this.builder,
  });
}

/// The landing page presenting a menu of all available ad formats.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _consentManager = ConsentManager.instance;
  var _isMobileAdsInitializeCalled = false;
  var _isPrivacyOptionsRequired = false;
  String _sdkVersion = '';

  final List<_AdFormatItem> _formats = [
    _AdFormatItem(
      title: 'App Open Ad',
      description: 'Full-screen ads shown on app open or when returning from foreground.',
      builder: (context) => const AppOpenPage(),
    ),
    _AdFormatItem(
      title: 'Banner Ad',
      description: 'Anchored adaptive banner resizing automatically with screen orientation.',
      builder: (context) => const BannerPage(),
    ),
    _AdFormatItem(
      title: 'Interstitial Ad',
      description:
          'Full-screen overlay ads shown at natural transition points.',
      builder: (context) => const InterstitialPage(),
    ),
    _AdFormatItem(
      title: 'Native Platform Ad',
      description: 'Custom native ad layouts using platform-specific Android XML / iOS XIB.',
      builder: (context) => const NativePlatformPage(),
    ),
    _AdFormatItem(
      title: 'Native Template Ad',
      description:
          'Native ads styled directly in Flutter using NativeTemplateStyle.',
      builder: (context) => const NativeTemplatePage(),
    ),
    _AdFormatItem(
      title: 'Rewarded Ad',
      description:
          'Full-screen video ads where users opt in to earn in-app rewards.',
      builder: (context) => const RewardedPage(),
    ),
    _AdFormatItem(
      title: 'Rewarded Interstitial Ad',
      description:
          'Full-screen rewarded ads with an introductory countdown dialog.',
      builder: (context) => const RewardedInterstitialPage(),
    ),
    _AdFormatItem(
      title: 'Ad Preloader',
      description: 'Preloads ads into a cache buffer with automatic background replenishment.',
      builder: (context) => const AdPreloadingPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        debugPrint(
          '${consentGatheringError.errorCode}: ${consentGatheringError.message}',
        );
      }

      _getIsPrivacyOptionsRequired();
      _initializeMobileAdsSDK();
    });

    _initializeMobileAdsSDK();
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

  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await _consentManager.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;
      await MobileAds.instance.initialize();
      var version = await MobileAds.instance.getVersionString();
      if (mounted) {
        setState(() {
          _sdkVersion = version;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Mobile Ads API Demo'),
        actions: _appBarActions(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AdMob Flutter SDK Samples',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select an ad format below to view its implementation and interactive demo.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  if (_sdkVersion.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'GMA SDK Version: $_sdkVersion',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ..._formats.map(
            (format) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  format.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    format.description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: format.builder),
                  );
                },
              ),
            ),
          ),
        ],
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
}
