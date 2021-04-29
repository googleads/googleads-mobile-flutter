package io.flutter.plugins.googlemobileads;

import android.content.Context;
import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback;
import com.google.android.gms.ads.interstitial.InterstitialAd;
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback;
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

/**
 * A wrapper around load methods in GMA.
 * This exists mainly to make the Android code more testable.
 */
public class FlutterAdLoader {

  public FlutterAdLoader() {}

  /** Load an interstitial ad. */
  public void loadInterstitial(
    @NonNull Context context,
    @NonNull String adUnitId,
    @NonNull AdRequest adRequest,
    @NonNull InterstitialAdLoadCallback loadCallback) {
    InterstitialAd.load(context, adUnitId, adRequest, loadCallback);
  }


  /** Load an ad manager interstitial ad. */
  public void loadAdManagerInterstitial(
    @NonNull Context context,
    @NonNull String adUnitId,
    @NonNull AdManagerAdRequest adRequest,
    @NonNull AdManagerInterstitialAdLoadCallback loadCallback) {
    AdManagerInterstitialAd.load(context, adUnitId, adRequest, loadCallback);
  }

  /** Load a rewarded ad. */
  public void loadRewarded(
    @NonNull Context context,
    @NonNull String adUnitId,
    @NonNull AdRequest adRequest,
    @NonNull RewardedAdLoadCallback loadCallback) {
    RewardedAd.load(context, adUnitId, adRequest, loadCallback);
  }

  /** Load an ad manager rewarded ad. */
  public void loadAdManagerRewarded(
    @NonNull Context context,
    @NonNull String adUnitId,
    @NonNull AdManagerAdRequest adRequest,
    @NonNull RewardedAdLoadCallback loadCallback) {
    RewardedAd.load(context, adUnitId, adRequest, loadCallback);
  }

  /** Load a native ad. */
  public void loadNativeAd(
    @NonNull Context context,
    @NonNull String adUnitId,
    @NonNull OnNativeAdLoadedListener onNativeAdLoadedListener,
    @NonNull NativeAdOptions nativeAdOptions,
    @NonNull AdListener adListener,
    @NonNull AdRequest adRequest) {
    new AdLoader.Builder(context, adUnitId)
      .forNativeAd(onNativeAdLoadedListener)
      .withNativeAdOptions(nativeAdOptions)
      .withAdListener(adListener)
      .build()
      .loadAd(adRequest);
  }

  /** Load an ad manager native ad. */
  public void loadAdManagerNativeAd(
    @NonNull Context context,
    @NonNull String adUnitId,
    @NonNull OnNativeAdLoadedListener onNativeAdLoadedListener,
    @NonNull NativeAdOptions nativeAdOptions,
    @NonNull AdListener adListener,
    @NonNull AdManagerAdRequest adManagerAdRequest) {
    new AdLoader.Builder(context, adUnitId)
      .forNativeAd(onNativeAdLoadedListener)
      .withNativeAdOptions(nativeAdOptions)
      .withAdListener(adListener)
      .build()
      .loadAd(adManagerAdRequest);
  }
}
