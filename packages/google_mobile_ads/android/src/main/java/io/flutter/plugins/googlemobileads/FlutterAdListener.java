// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.LoadAdError;

class FlutterAdListener extends AdListener {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final FlutterAd ad;

  FlutterAdListener(@NonNull AdInstanceManager manager, @NonNull FlutterAd ad) {
    this.manager = manager;
    this.ad = ad;
  }

  @Override
  public void onAdClosed() {
    manager.onAdClosed(ad);
  }

  @Override
  public void onAdFailedToLoad(LoadAdError loadAdError) {
    manager.onAdFailedToLoad(ad, new FlutterAd.FlutterLoadAdError(loadAdError));
  }

  @Override
  public void onAdLeftApplication() {
    manager.onApplicationExit(ad);
  }

  @Override
  public void onAdOpened() {
    manager.onAdOpened(ad);
  }

  @Override
  public void onAdLoaded() {
    manager.onAdLoaded(ad);
  }
}
