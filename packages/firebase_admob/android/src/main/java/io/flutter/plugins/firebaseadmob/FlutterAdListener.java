package io.flutter.plugins.firebaseadmob;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdListener;

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
  public void onAdFailedToLoad(int var1) {
    manager.onAdFailedToLoad(ad);
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
