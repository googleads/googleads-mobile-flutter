// Copyright 2026 Google LLC
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

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdPreloaderExample extends StatefulWidget {
  @override
  _AdPreloaderExampleState createState() => _AdPreloaderExampleState();
}

class _AdPreloaderExampleState extends State<AdPreloaderExample> {
  String _selectedFormat = 'Interstitial';

  late final TextEditingController _adUnitIdController;
  late final TextEditingController _preloadIdController;
  late final TextEditingController _bufferSizeController;

  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  bool? _isAdAvailable;
  int? _numAdsAvailable;
  AdWithoutView? _loadedAd;

  final Map<String, Map<String, String>> _defaultAdUnits = {
    'Interstitial': {
      'android': 'ca-app-pub-3940256099942544/1033173712',
      'ios': 'ca-app-pub-3940256099942544/4411468910',
    },
    'Rewarded': {
      'android': 'ca-app-pub-3940256099942544/5224354917',
      'ios': 'ca-app-pub-3940256099942544/1712485313',
    },
    'App Open': {
      'android': 'ca-app-pub-3940256099942544/9257395921',
      'ios': 'ca-app-pub-3940256099942544/5575463023',
    },
  };

  @override
  void initState() {
    super.initState();
    _adUnitIdController = TextEditingController(
      text: _getAdUnitFor('Interstitial'),
    );
    _preloadIdController = TextEditingController(
      text: 'interstitial_preload_id',
    );
    _bufferSizeController = TextEditingController(text: '2');
    _preloadIdController.addListener(_onPreloadIdChanged);
  }

  void _onPreloadIdChanged() {
    setState(() {});
  }

  String _getAdUnitFor(String format) {
    final platformKey = Platform.isAndroid ? 'android' : 'ios';
    return _defaultAdUnits[format]?[platformKey] ?? '';
  }

  String _getDefaultPreloadIdFor(String format) {
    switch (format) {
      case 'Interstitial':
        return 'interstitial_preload_id';
      case 'Rewarded':
        return 'rewarded_preload_id';
      case 'App Open':
        return 'app_open_preload_id';
      default:
        return 'preload_id';
    }
  }

  void _onFormatChanged(String? newFormat) {
    if (newFormat == null) return;
    setState(() {
      _selectedFormat = newFormat;
      _adUnitIdController.text = _getAdUnitFor(newFormat);
      _preloadIdController.text = _getDefaultPreloadIdFor(newFormat);
      _isAdAvailable = null;
      _loadedAd?.dispose();
      _loadedAd = null;
    });
    _log('Switched format to: $newFormat');
  }

  @override
  void dispose() {
    _preloadIdController.removeListener(_onPreloadIdChanged);
    _adUnitIdController.dispose();
    _preloadIdController.dispose();
    _bufferSizeController.dispose();
    _scrollController.dispose();
    _loadedAd?.dispose();
    super.dispose();
  }

  void _log(String message) {
    final time = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.add('[$time] $message');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _checkAdAvailability() async {
    final preloadId = _preloadIdController.text.trim();
    if (preloadId.isEmpty) {
      _log('Error: Preload ID cannot be empty.');
      return;
    }
    try {
      bool available = false;
      int count = 0;
      switch (_selectedFormat) {
        case 'Interstitial':
          available = await InterstitialAdPreloader.isAdAvailable(preloadId);
          count = await InterstitialAdPreloader.getNumAdsAvailable(preloadId);
          break;
        case 'Rewarded':
          available = await RewardedAdPreloader.isAdAvailable(preloadId);
          count = await RewardedAdPreloader.getNumAdsAvailable(preloadId);
          break;
        case 'App Open':
          available = await AppOpenAdPreloader.isAdAvailable(preloadId);
          count = await AppOpenAdPreloader.getNumAdsAvailable(preloadId);
          break;
      }
      setState(() {
        _isAdAvailable = available;
        _numAdsAvailable = count;
      });
      _log(
        'Ad availability for "$preloadId" ($_selectedFormat): $available, count: $count',
      );
    } catch (e) {
      _log('Error checking availability: $e');
    }
  }

  Future<void> _findConfiguration() async {
    final preloadId = _preloadIdController.text.trim();
    try {
      if (preloadId.isNotEmpty) {
        PreloadConfiguration? config;
        switch (_selectedFormat) {
          case 'Interstitial':
            config = await InterstitialAdPreloader.getConfiguration(preloadId);
            break;
          case 'Rewarded':
            config = await RewardedAdPreloader.getConfiguration(preloadId);
            break;
          case 'App Open':
            config = await AppOpenAdPreloader.getConfiguration(preloadId);
            break;
        }
        if (config != null) {
          setState(() {
            _adUnitIdController.text = config!.adUnitId;
            _bufferSizeController.text = config.bufferSize.toString();
          });
          _log(
            'Found configuration for "$preloadId": Ad Unit ID: ${config.adUnitId}, Buffer Size: ${config.bufferSize}',
          );
        } else {
          _log('No configuration found for preload ID: "$preloadId"');
        }
      } else {
        Map<String, PreloadConfiguration> configs = {};
        switch (_selectedFormat) {
          case 'Interstitial':
            configs = await InterstitialAdPreloader.getConfigurations();
            break;
          case 'Rewarded':
            configs = await RewardedAdPreloader.getConfigurations();
            break;
          case 'App Open':
            configs = await AppOpenAdPreloader.getConfigurations();
            break;
        }
        if (configs.isNotEmpty) {
          final entry = configs.entries.first;
          setState(() {
            _preloadIdController.text = entry.key;
            _adUnitIdController.text = entry.value.adUnitId;
            _bufferSizeController.text = entry.value.bufferSize.toString();
          });
          _log(
            'Found ${configs.length} active configurations. Populated with "${entry.key}": Ad Unit ID: ${entry.value.adUnitId}, Buffer Size: ${entry.value.bufferSize}',
          );
        } else {
          _log('No active configurations found for $_selectedFormat format.');
        }
      }
    } catch (e) {
      _log('Error finding configuration: $e');
    }
  }

  Future<void> _startPreloading() async {
    final preloadId = _preloadIdController.text.trim();
    final adUnitId = _adUnitIdController.text.trim();
    final bufferSizeText = _bufferSizeController.text.trim();

    if (preloadId.isEmpty || adUnitId.isEmpty) {
      _log('Error: Preload ID and Ad Unit ID cannot be empty.');
      return;
    }

    final bufferSize = int.tryParse(bufferSizeText) ?? 2;
    final config = PreloadConfiguration(
      adUnitId: adUnitId,
      request: const AdRequest(),
      bufferSize: bufferSize,
    );
    final callback = PreloadCallback(
      onAdPreloaded: (pId, responseInfo) {
        _log('Callback: Ad preloaded successfully for ID "$pId"!');
        _log(
          'Response Info MEDIATION_ADAPTER: ${responseInfo.mediationAdapterClassName}',
        );
        _checkAdAvailability();
      },
      onAdsExhausted: (pId) {
        _log('Callback: Ads exhausted for ID "$pId".');
        _checkAdAvailability();
      },
      onAdFailedToPreload: (pId, error) {
        _log('Callback: Ad failed to preload for ID "$pId": ${error.message}');
        _checkAdAvailability();
      },
    );

    _log('Starting $_selectedFormat preloader with ID: "$preloadId"');
    try {
      switch (_selectedFormat) {
        case 'Interstitial':
          await InterstitialAdPreloader.start(
            preloadId: preloadId,
            preloadConfiguration: config,
            callback: callback,
          );
          break;
        case 'Rewarded':
          await RewardedAdPreloader.start(
            preloadId: preloadId,
            preloadConfiguration: config,
            callback: callback,
          );
          break;
        case 'App Open':
          await AppOpenAdPreloader.start(
            preloadId: preloadId,
            preloadConfiguration: config,
            callback: callback,
          );
          break;
      }
      _log('Preloader start command invoked successfully.');
    } catch (e) {
      _log('Error starting preloader: $e');
    }
  }

  Future<void> _destroyPreloader() async {
    final preloadId = _preloadIdController.text.trim();
    if (preloadId.isEmpty) {
      _log('Error: Preload ID cannot be empty.');
      return;
    }
    _log('Destroying $_selectedFormat preloader with ID: "$preloadId"');
    try {
      switch (_selectedFormat) {
        case 'Interstitial':
          await InterstitialAdPreloader.destroy(preloadId);
          break;
        case 'Rewarded':
          await RewardedAdPreloader.destroy(preloadId);
          break;
        case 'App Open':
          await AppOpenAdPreloader.destroy(preloadId);
          break;
      }
      _log('Preloader "$preloadId" destroyed.');
      setState(() {
        _isAdAvailable = null;
        _numAdsAvailable = null;
      });
    } catch (e) {
      _log('Error destroying preloader: $e');
    }
  }

  Future<void> _destroyAllPreloaders() async {
    _log('Destroying all $_selectedFormat preloaders...');
    try {
      switch (_selectedFormat) {
        case 'Interstitial':
          await InterstitialAdPreloader.destroyAll();
          break;
        case 'Rewarded':
          await RewardedAdPreloader.destroyAll();
          break;
        case 'App Open':
          await AppOpenAdPreloader.destroyAll();
          break;
      }
      _log('All $_selectedFormat preloaders destroyed.');
      setState(() {
        _isAdAvailable = null;
        _numAdsAvailable = null;
      });
    } catch (e) {
      _log('Error destroying preloaders: $e');
    }
  }

  Future<void> _requestAndShowAd() async {
    final preloadId = _preloadIdController.text.trim();
    final adUnitId = _adUnitIdController.text.trim();

    if (preloadId.isEmpty || adUnitId.isEmpty) {
      _log('Error: Preload ID and Ad Unit ID cannot be empty.');
      return;
    }

    _log(
      'Requesting and Showing $_selectedFormat (Preload ID: "$preloadId")...',
    );
    try {
      AdWithoutView? loadedAd;
      switch (_selectedFormat) {
        case 'Interstitial':
          loadedAd = await InterstitialAdPreloader.pollAd(preloadId);
          break;
        case 'Rewarded':
          loadedAd = await RewardedAdPreloader.pollAd(preloadId);
          break;
        case 'App Open':
          loadedAd = await AppOpenAdPreloader.pollAd(preloadId);
          break;
      }

      if (loadedAd != null) {
        _log('Callback: $_selectedFormat loaded successfully from preloader!');
        setState(() {
          _loadedAd = loadedAd;
        });
        _showAd();
      } else {
        _log(
          'Callback: $_selectedFormat failed to load: Preloaded ad not available',
        );
      }
      await _checkAdAvailability();
    } catch (e) {
      _log('Error requesting/showing ad: $e');
    }
  }

  void _showAd() {
    if (_loadedAd == null) {
      _log('Error: No loaded ad available to show.');
      return;
    }

    _log('Showing $_selectedFormat...');
    if (_loadedAd is InterstitialAd) {
      final ad = _loadedAd as InterstitialAd;
      ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
        onAdShowedFullScreenContent: (ad) {
          _log('Ad event: onAdShowedFullScreenContent');
        },
        onAdDismissedFullScreenContent: (ad) {
          _log('Ad event: onAdDismissedFullScreenContent');
          ad.dispose();
          setState(() {
            _loadedAd = null;
          });
          _checkAdAvailability();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _log('Ad event: onAdFailedToShowFullScreenContent: ${error.message}');
          ad.dispose();
          setState(() {
            _loadedAd = null;
          });
          _checkAdAvailability();
        },
      );
      ad.show();
    } else if (_loadedAd is RewardedAd) {
      final ad = _loadedAd as RewardedAd;
      ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
        onAdShowedFullScreenContent: (ad) {
          _log('Ad event: onAdShowedFullScreenContent');
        },
        onAdDismissedFullScreenContent: (ad) {
          _log('Ad event: onAdDismissedFullScreenContent');
          ad.dispose();
          setState(() {
            _loadedAd = null;
          });
          _checkAdAvailability();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _log('Ad event: onAdFailedToShowFullScreenContent: ${error.message}');
          ad.dispose();
          setState(() {
            _loadedAd = null;
          });
          _checkAdAvailability();
        },
      );
      ad.show(
        onUserEarnedReward: (ad, reward) {
          _log('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
    } else if (_loadedAd is AppOpenAd) {
      final ad = _loadedAd as AppOpenAd;
      ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
        onAdShowedFullScreenContent: (ad) {
          _log('Ad event: onAdShowedFullScreenContent');
        },
        onAdDismissedFullScreenContent: (ad) {
          _log('Ad event: onAdDismissedFullScreenContent');
          ad.dispose();
          setState(() {
            _loadedAd = null;
          });
          _checkAdAvailability();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _log('Ad event: onAdFailedToShowFullScreenContent: ${error.message}');
          ad.dispose();
          setState(() {
            _loadedAd = null;
          });
          _checkAdAvailability();
        },
      );
      ad.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Fullscreen Ad Preloader')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card 1: Configuration
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _preloadIdController,
                            decoration: const InputDecoration(
                              labelText: 'Preload ID',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: const TextStyle(fontSize: 13.0),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton(
                          onPressed: _findConfiguration,
                          child: Text(
                            _preloadIdController.text.trim().isEmpty
                                ? 'Find (any)'
                                : 'Find',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFormat,
                      decoration: const InputDecoration(
                        labelText: 'Fullscreen Ad Format',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: <String>['Interstitial', 'Rewarded', 'App Open']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: _onFormatChanged,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _adUnitIdController,
                            decoration: const InputDecoration(
                              labelText: 'Ad Unit ID',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: const TextStyle(fontSize: 13.0),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _bufferSizeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Buffer Size',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: const TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Card 2: Preloader Actions
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preloader Operations ($_selectedFormat)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _startPreloading,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primaryContainer,
                              foregroundColor: colors.onPrimaryContainer,
                            ),
                            child: const Text('Start'),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _destroyPreloader,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.error,
                              side: BorderSide(color: colors.error),
                            ),
                            child: const Text('Destroy'),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _destroyAllPreloaders,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.error,
                              side: BorderSide(color: colors.error),
                            ),
                            child: const Text('Destroy All'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Card 3: Ad Operations
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ad Request & Showcase',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        const Text(
                          'Preload Available: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        _buildAvailabilityStatus(),
                        const Spacer(),
                        if (_numAdsAvailable != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Count: $_numAdsAvailable',
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _checkAdAvailability,
                          tooltip: 'Check Availability',
                        ),
                      ],
                    ),
                    const Divider(height: 24.0),
                    ElevatedButton.icon(
                      onPressed: _requestAndShowAd,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show Ad'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card 4: Live Log Console
            Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Console Logs',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                        ),
                        TextButton.icon(
                          onPressed: () => setState(() => _logs.clear()),
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('Clear'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: _logs.isEmpty
                          ? const Center(
                              child: Text(
                                'No logs yet. Perform an operation.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _logs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: SelectableText(
                                    _logs[index],
                                    style: const TextStyle(
                                      color: Colors.lightGreenAccent,
                                      fontFamily: 'monospace',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityStatus() {
    if (_isAdAvailable == null) {
      return const Text(
        'UNKNOWN',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      );
    }
    return Text(
      _isAdAvailable! ? 'YES' : 'NO',
      style: TextStyle(
        color: _isAdAvailable! ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
