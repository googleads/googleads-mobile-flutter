// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This example demonstrates fluid ads, where the ad objects
/// live for the lifetime of this widget.
class FluidExample extends StatefulWidget {
  @override
  _FluidExampleExampleState createState() => _FluidExampleExampleState();
}

class _FluidExampleExampleState extends State<FluidExample> {
  AdManagerBannerAd? _adManagerBannerAd;
  double _adManagerBannerAdWidth = 200;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 500,
                        width: _adManagerBannerAdWidth,
                        child: AdWidget(ad: _adManagerBannerAd!))),
                ElevatedButton(
                    onPressed: () {
                      double newWidth;
                      if (_adManagerBannerAdWidth == 200) {
                        newWidth = 100;
                      } else if (_adManagerBannerAdWidth == 100) {
                        newWidth = 150;
                      } else {
                        newWidth = 200;
                      }
                      setState(() {
                        _adManagerBannerAdWidth = newWidth;
                      });
                    },
                    child: Text('Change size'))
              ]),
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: '/6499/example/APIDemo/Fluid',
      request: AdManagerAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[AdSize.fluid],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$AdManagerBannerAd loaded.');
          setState(() {});
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$AdManagerBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$AdManagerBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$AdManagerBannerAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _adManagerBannerAd?.dispose();
  }
}
