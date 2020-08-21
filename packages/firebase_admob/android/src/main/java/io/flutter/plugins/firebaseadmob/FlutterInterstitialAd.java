package io.flutter.plugins.firebaseadmob;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.InterstitialAd;

public class FlutterInterstitialAd extends FlutterAd implements FlutterAd.FlutterAdWithoutView {
  @Nullable private InterstitialAd ad;

  private static final String TAG = "FlutterInterstitialAd";

  public FlutterInterstitialAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request) {
    super(manager, adUnitId, request);
  }

  @Override
  void load() {
    ad = new InterstitialAd(manager.activity);
    ad.setAdUnitId(adUnitId);
    ad.setAdListener(new FlutterAdListener(manager, this));
    ad.loadAd(request.asAdRequest());
  }

  @Override
  public void show() {
    if (!ad.isLoaded()) {
      Log.e(TAG, "The interstitial wasn't loaded yet.");
      return;
    }
    ad.show();
  }
}
