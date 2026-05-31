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

class InterstitialAdPreloaderExample extends StatefulWidget {
  @override
  _InterstitialAdPreloaderExampleState createState() =>
      _InterstitialAdPreloaderExampleState();
}

class _InterstitialAdPreloaderExampleState
    extends State<InterstitialAdPreloaderExample> {
  late final TextEditingController _adUnitIdController;
  late final TextEditingController _preloadIdController;
  late final TextEditingController _bufferSizeController;

  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  bool? _isAdAvailable;
  InterstitialAd? _loadedAd;

  @override
  void initState() {
    super.initState();
    _adUnitIdController = TextEditingController(
      text: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',
    );
    _preloadIdController = TextEditingController(text: 'test_preload_id');
    _bufferSizeController = TextEditingController(text: '2');
  }

  @override
  void dispose() {
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
      final available = await InterstitialAdPreloader.isAdAvailable(preloadId);
      setState(() {
        _isAdAvailable = available;
      });
      _log('Ad availability for "$preloadId": $available');
    } catch (e) {
      _log('Error checking availability: $e');
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

    final bufferSize = int.tryParse(bufferSizeText);

    _log('Starting preloader with ID: "$preloadId"');
    try {
      await InterstitialAdPreloader.start(
        preloadId: preloadId,
        preloadConfiguration: PreloadConfiguration(
          adUnitId: adUnitId,
          bufferSize: bufferSize,
        ),
        callback: PreloadCallback(
          onAdPreloaded: (pId, responseInfo) {
            _log('Callback: Ad preloaded successfully for ID "$pId"!');
            _log('Response Info: ${responseInfo.responseId}');
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
        ),
      );
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
    _log('Destroying preloader with ID: "$preloadId"');
    try {
      await InterstitialAdPreloader.destroy(preloadId);
      _log('Preloader "$preloadId" destroyed.');
      setState(() {
        _isAdAvailable = null;
      });
    } catch (e) {
      _log('Error destroying preloader: $e');
    }
  }

  Future<void> _destroyAllPreloaders() async {
    _log('Destroying all preloaders...');
    try {
      await InterstitialAdPreloader.destroyAll();
      _log('All preloaders destroyed.');
      setState(() {
        _isAdAvailable = null;
      });
    } catch (e) {
      _log('Error destroying all preloaders: $e');
    }
  }

  Future<void> _loadAdFromPreloader() async {
    final preloadId = _preloadIdController.text.trim();
    final adUnitId = _adUnitIdController.text.trim();

    if (preloadId.isEmpty || adUnitId.isEmpty) {
      _log('Error: Preload ID and Ad Unit ID cannot be empty.');
      return;
    }

    _log('Requesting/loading InterstitialAd from preloader (Preload ID: "$preloadId")...');
    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        preloadId: preloadId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _log('InterstitialAd loaded successfully from preloader!');
            setState(() {
              _loadedAd = ad;
            });
            _checkAdAvailability();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _log('Failed to load InterstitialAd from preloader: ${error.message}');
            _checkAdAvailability();
          },
        ),
      );
    } catch (e) {
      _log('Error loading ad from preloader: $e');
    }
  }

  void _showAd() {
    if (_loadedAd == null) {
      _log('Error: No loaded ad available to show. Load one first.');
      return;
    }

    _log('Showing InterstitialAd...');
    _loadedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        _log('Ad event: onAdShowedFullScreenContent');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        _log('Ad event: onAdDismissedFullScreenContent');
        ad.dispose();
        setState(() {
          _loadedAd = null;
        });
        _checkAdAvailability();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        _log('Ad event: onAdFailedToShowFullScreenContent: ${error.message}');
        ad.dispose();
        setState(() {
          _loadedAd = null;
        });
        _checkAdAvailability();
      },
    );

    _loadedAd!.show();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interstitial Ad Preloader'),
      ),
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
                    TextField(
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
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
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
                      'Preloader Operations',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          'Preload Available: ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        _buildAvailabilityStatus(),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _checkAdAvailability,
                          tooltip: 'Check Availability',
                        ),
                      ],
                    ),
                    const Divider(height: 24.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loadAdFromPreloader,
                            icon: const Icon(Icons.cloud_download),
                            label: const Text('Request Ad'),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loadedAd != null ? _showAd : null,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Show Ad'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              disabledForegroundColor: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
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
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(
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
