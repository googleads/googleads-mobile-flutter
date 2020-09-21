package io.flutter.plugins.firebaseadmob;

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
