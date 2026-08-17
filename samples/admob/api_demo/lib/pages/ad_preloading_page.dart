import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common/app_bar_item.dart';
import '../common/consent_manager.dart';

/// Supported ad formats for preloading demonstration.
enum PreloadAdFormat {
  interstitial(
    title: 'Interstitial ad',
    androidUnitId: 'ca-app-pub-3940256099942544/1033173712',
    iosUnitId: 'ca-app-pub-3940256099942544/4411468910',
  ),
  rewarded(
    title: 'Rewarded ad',
    androidUnitId: 'ca-app-pub-3940256099942544/5224354917',
    iosUnitId: 'ca-app-pub-3940256099942544/1712485313',
  ),
  appOpen(
    title: 'App open ad',
    androidUnitId: 'ca-app-pub-3940256099942544/9257395921',
    iosUnitId: 'ca-app-pub-3940256099942544/5575463023',
  );

  final String title;
  final String androidUnitId;
  final String iosUnitId;

  String get adUnitId => Platform.isAndroid ? androidUnitId : iosUnitId;

  const PreloadAdFormat({
    required this.title,
    required this.androidUnitId,
    required this.iosUnitId,
  });
}

/// Tracks the preloader state and cache count for a specific ad format.
class _FormatPreloadState {
  final PreloadAdFormat format;
  bool isStarted = false;
  bool isAdAvailable = false;
  int cachedAdsCount = 0;

  _FormatPreloadState(this.format);
}

/// An example page demonstrating how the GMA SDK [AdPreloader] APIs work in Dart.
class AdPreloadingPage extends StatefulWidget {
  const AdPreloadingPage({super.key});

  @override
  State<AdPreloadingPage> createState() => _AdPreloadingPageState();
}

class _AdPreloadingPageState extends State<AdPreloadingPage> {
  final _consentManager = ConsentManager.instance;
  var _isPrivacyOptionsRequired = false;

  final int _bufferSize = 2;
  PreloadAdFormat _selectedFormat = PreloadAdFormat.interstitial;

  late final Map<PreloadAdFormat, _FormatPreloadState> _formatStates;

  _FormatPreloadState get _currentState => _formatStates[_selectedFormat]!;

  @override
  void initState() {
    super.initState();
    _formatStates = {
      for (final format in PreloadAdFormat.values)
        format: _FormatPreloadState(format),
    };

    _getIsPrivacyOptionsRequired();
    _startAllPreloaders();
  }

  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      if (mounted) {
        setState(() => _isPrivacyOptionsRequired = true);
      }
    }
  }

  /// Starts preloaders for all supported formats.
  void _startAllPreloaders() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) return;

    for (final format in PreloadAdFormat.values) {
      _startPreloaderForFormat(format);
    }
  }

  /// Starts the preloader for a specific ad format.
  void _startPreloaderForFormat(PreloadAdFormat format) async {
    var canRequestAds = await _consentManager.canRequestAds();
    final state = _formatStates[format]!;

    if (!canRequestAds || state.isStarted) return;

    state.isStarted = true;

    final config = PreloadConfiguration(
      adUnitId: format.adUnitId,
      request: const AdRequest(),
      bufferSize: _bufferSize,
    );

    final callback = PreloadCallback(
      onAdPreloaded: (String id, ResponseInfo responseInfo) {
        debugPrint('Preloader onAdPreloaded: $id');
        if (!mounted) return;

        setState(() {
          state.cachedAdsCount = (state.cachedAdsCount + 1).clamp(
            0,
            _bufferSize,
          );
          state.isAdAvailable = true;
        });
        _checkAvailability(format);
      },
      onAdFailedToPreload: (String id, AdError error) {
        debugPrint('Preloader onAdFailedToPreload: $id, error: $error');
        if (!mounted) return;
        _checkAvailability(format);
      },
      onAdsExhausted: (String id) {
        debugPrint('Preloader onAdsExhausted: $id');
        if (!mounted) return;

        setState(() {
          state.cachedAdsCount = 0;
          state.isAdAvailable = false;
        });
      },
    );

    switch (format) {
      case PreloadAdFormat.interstitial:
        await InterstitialAdPreloader.start(
          preloadId: format.adUnitId,
          preloadConfiguration: config,
          callback: callback,
        );
      case PreloadAdFormat.rewarded:
        await RewardedAdPreloader.start(
          preloadId: format.adUnitId,
          preloadConfiguration: config,
          callback: callback,
        );
      case PreloadAdFormat.appOpen:
        await AppOpenAdPreloader.start(
          preloadId: format.adUnitId,
          preloadConfiguration: config,
          callback: callback,
        );
    }

    await _checkAvailability(format);
  }

  /// Checks whether an ad is currently available in the preloader cache buffer.
  Future<bool> _checkAvailability(PreloadAdFormat format) async {
    final state = _formatStates[format]!;
    final available = switch (format) {
      PreloadAdFormat.interstitial =>
        await InterstitialAdPreloader.isAdAvailable(format.adUnitId),
      PreloadAdFormat.rewarded =>
        await RewardedAdPreloader.isAdAvailable(format.adUnitId),
      PreloadAdFormat.appOpen =>
        await AppOpenAdPreloader.isAdAvailable(format.adUnitId),
    };

    if (mounted) {
      setState(() => state.isAdAvailable = available);
    }
    return available;
  }

  /// Pulls an ad from the cache and displays it immediately.
  /// Pulling an ad automatically triggers background preloading of a replacement.
  void _pollAndShowAd() async {
    final state = _currentState;

    switch (state.format) {
      case PreloadAdFormat.interstitial:
        final ad = await InterstitialAdPreloader.pollAd(state.format.adUnitId);
        if (ad == null) {
          debugPrint('No interstitial ad ready in cache.');
          _checkAvailability(state.format);
          return;
        }
        _onAdPolled(state);
        _showInterstitial(ad);

      case PreloadAdFormat.rewarded:
        final ad = await RewardedAdPreloader.pollAd(state.format.adUnitId);
        if (ad == null) {
          debugPrint('No rewarded ad ready in cache.');
          _checkAvailability(state.format);
          return;
        }
        _onAdPolled(state);
        _showRewarded(ad);

      case PreloadAdFormat.appOpen:
        final ad = await AppOpenAdPreloader.pollAd(state.format.adUnitId);
        if (ad == null) {
          debugPrint('No app open ad ready in cache.');
          _checkAvailability(state.format);
          return;
        }
        _onAdPolled(state);
        _showAppOpen(ad);
    }
  }

  void _onAdPolled(_FormatPreloadState state) {
    setState(() {
      state.cachedAdsCount = (state.cachedAdsCount - 1).clamp(0, _bufferSize);
    });
  }

  void _showInterstitial(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (ad) =>
          debugPrint('Interstitial ad showed full screen.'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Interstitial ad dismissed.');
        ad.dispose();
        _checkAvailability(PreloadAdFormat.interstitial);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial ad failed to show: $error');
        ad.dispose();
        _checkAvailability(PreloadAdFormat.interstitial);
      },
    );
    ad.show();
  }

  void _showRewarded(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (ad) =>
          debugPrint('Rewarded ad showed full screen.'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Rewarded ad dismissed.');
        ad.dispose();
        _checkAvailability(PreloadAdFormat.rewarded);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded ad failed to show: $error');
        ad.dispose();
        _checkAvailability(PreloadAdFormat.rewarded);
      },
    );
    ad.show(
      onUserEarnedReward: (ad, reward) =>
          debugPrint('Reward earned: ${reward.amount} ${reward.type}'),
    );
  }

  void _showAppOpen(AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdShowedFullScreenContent: (ad) =>
          debugPrint('App open ad showed full screen.'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('App open ad dismissed.');
        ad.dispose();
        _checkAvailability(PreloadAdFormat.appOpen);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App open ad failed to show: $error');
        ad.dispose();
        _checkAvailability(PreloadAdFormat.appOpen);
      },
    );
    ad.show();
  }

  Future<void> _destroyPreloader(PreloadAdFormat format) async {
    final state = _formatStates[format]!;
    if (!state.isStarted) return;

    switch (format) {
      case PreloadAdFormat.interstitial:
        await InterstitialAdPreloader.destroy(format.adUnitId);
      case PreloadAdFormat.rewarded:
        await RewardedAdPreloader.destroy(format.adUnitId);
      case PreloadAdFormat.appOpen:
        await AppOpenAdPreloader.destroy(format.adUnitId);
    }
    state.isStarted = false;
  }

  @override
  void dispose() {
    for (final format in PreloadAdFormat.values) {
      _destroyPreloader(format);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad preloader'),
        actions: _appBarActions(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCacheOverviewCard(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheOverviewCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ads in cache',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Buffer size: $_bufferSize',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...PreloadAdFormat.values.map((format) {
              final state = _formatStates[format]!;
              final isSelected = format == _selectedFormat;
              final isAvailable =
                  state.isAdAvailable && state.cachedAdsCount > 0;

              return InkWell(
                onTap: () => setState(() => _selectedFormat = format),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withAlpha(80)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        format.title,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${state.cachedAdsCount} / $_bufferSize cached',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isAvailable
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final state = _currentState;
    final isAvailable = state.isStarted && state.cachedAdsCount > 0;

    return FilledButton(
      onPressed: isAvailable ? _pollAndShowAd : null,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text('Poll and show ${state.format.title.toLowerCase()}'),
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
