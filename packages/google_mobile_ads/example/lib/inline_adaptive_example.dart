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
import 'constants.dart';

/// This example demonstrates inline adaptive banner ads.
class InlineAdaptiveExample extends StatefulWidget {
  @override
  _InlineAdaptiveExampleState createState() => _InlineAdaptiveExampleState();
}

class _InlineAdaptiveExampleState extends State<InlineAdaptiveExample> {
  static const _insets = 16.0;
  AdManagerBannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() async {
    // Create the ad object and load an ad.
    AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        _adWidth.truncate());

    _inlineAdaptiveAd = AdManagerBannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      sizes: [size],
      request: AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _inlineAdaptiveAd = ad as AdManagerBannerAd;
            _isLoaded = true;
            _inlineAdaptiveAd?.getPlatformAdSize().then((size) => setState(() {
                  _adSize = size;
                }));
          });
          print('Inline adaptive banner loaded: ${ad.responseInfo}');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Inline adaptive banner example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _insets),
          child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 40,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              if (index == 1 &&
                  _inlineAdaptiveAd != null &&
                  _isLoaded &&
                  _adSize != null) {
                return Align(
                    child: Container(
                  width: _adWidth,
                  height: _adSize!.height.toDouble(),
                  child: AdWidget(
                    ad: _inlineAdaptiveAd!,
                  ),
                ));
              }
              return Text(
                Constants.placeholderText,
                style: TextStyle(fontSize: 24),
              );
            },
          ),
        ),
      ));

  @override
  void dispose() {
    super.dispose();
    _inlineAdaptiveAd?.dispose();
  }
}
