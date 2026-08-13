import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// Utility class that manages loading and showing app open ads.
class AppOpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  DateTime? _appOpenLoadTime;
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  VoidCallback? onAdStateChanged;

  final String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-3940256099942544/5575463023';

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _appOpenAd != null;

  /// Load an [AppOpenAd].
  void loadAd({VoidCallback? onLoaded, Function(LoadAdError)? onFailed}) async {
    var canRequestAds = await ConsentManager.instance.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          onLoaded?.call();
          onAdStateChanged?.call();
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          onFailed?.call(error);
          onAdStateChanged?.call();
        },
      ),
    );
  }

  /// Shows the ad, if one exists and is not already being shown.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        onAdStateChanged?.call();
        loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        onAdStateChanged?.call();
        loadAd();
      },
    );
    _appOpenAd!.show();
  }

  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;
  bool isListening = false;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    if (isListening) return;
    isListening = true;
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(
      (state) => _onAppStateChanged(state),
    );
  }

  void _onAppStateChanged(AppState appState) {
    debugPrint('New AppState state: $appState');
    if (isListening && appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}

/// Example page for an App Open ad.
class AppOpenPage extends StatefulWidget {
  const AppOpenPage({super.key});

  @override
  State<AppOpenPage> createState() => _AppOpenPageState();
}

class _AppOpenPageState extends State<AppOpenPage> {
  final _appOpenAdManager = AppOpenAdManager();
  late final AppLifecycleReactor _appLifecycleReactor;
  var _isPrivacyOptionsRequired = false;
  var _listenToForegroundEvents = true;

  @override
  void initState() {
    super.initState();

    _appOpenAdManager.onAdStateChanged = () {
      if (mounted) setState(() {});
    };

    _appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: _appOpenAdManager,
    );
    _appLifecycleReactor.listenToAppStateChanges();

    _getIsPrivacyOptionsRequired();
    _loadAd();
  }

  void _loadAd() {
    _appOpenAdManager.loadAd();
  }

  void _getIsPrivacyOptionsRequired() async {
    if (await ConsentManager.instance.isPrivacyOptionsRequired()) {
      if (mounted) {
        setState(() {
          _isPrivacyOptionsRequired = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _appLifecycleReactor.isListening = false;
    _appOpenAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Open Ad'),
        actions: _appBarActions(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'App Open Ad Demo',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'App open ads are shown when users open or return to your app. Leave and switch back to the app to see the ad.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    _appOpenAdManager.isAdAvailable
                        ? 'Ad is ready to display'
                        : 'Loading ad...',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Show ad on foreground resume'),
                subtitle: const Text('Triggers when returning from another app'),
                value: _listenToForegroundEvents,
                onChanged: (value) {
                  setState(() {
                    _listenToForegroundEvents = value;
                    _appLifecycleReactor.isListening = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _loadAd,
                    child: const Text('Reload Ad'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _appOpenAdManager.isAdAvailable
                        ? () => _appOpenAdManager.showAdIfAvailable()
                        : null,
                    child: const Text('Show Ad Now'),
                  ),
                ],
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
              ConsentManager.instance.showPrivacyOptionsForm((formError) {
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
