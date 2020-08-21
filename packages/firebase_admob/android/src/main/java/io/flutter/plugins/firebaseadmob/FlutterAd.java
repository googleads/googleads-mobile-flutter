package io.flutter.plugins.firebaseadmob;

import androidx.annotation.NonNull;

abstract class FlutterAd {
  @NonNull final AdInstanceManager manager;
  @NonNull final String adUnitId;
  @NonNull final FlutterAdRequest request;

  interface FlutterAdWithoutView {
    void show();
  }

  public FlutterAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
  }

  abstract void load();
}
