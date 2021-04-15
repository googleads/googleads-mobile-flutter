package io.flutter.plugins.googlemobileads;

import android.content.Context;
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
 * This exists mainly to make the android code more testable.
 */
public class FlutterAdLoader {

  public FlutterAdLoader() {}

  /** Load an interstitial ad. */
  public void loadInterstitial(
    Context context,
    String adUnitId,
    AdRequest adRequest,
    InterstitialAdLoadCallback loadCallback) {
    InterstitialAd.load(context, adUnitId, adRequest, loadCallback);
  }


  /** Load an ad manager interstitial ad. */
  public void loadAdManagerInterstitial(
    Context context,
    String adUnitId,
    AdManagerAdRequest adRequest,
    AdManagerInterstitialAdLoadCallback loadCallback) {
    AdManagerInterstitialAd.load(context, adUnitId, adRequest, loadCallback);
  }

  /** Load a rewarded ad. */
  public void loadRewarded(
    Context context,
    String adUnitId,
    AdRequest adRequest,
    RewardedAdLoadCallback loadCallback) {
    RewardedAd.load(context, adUnitId, adRequest, loadCallback);
  }

  /** Load an ad manager rewarded ad. */
  public void loadAdManagerRewarded(
    Context context,
    String adUnitId,
    AdManagerAdRequest adRequest,
    RewardedAdLoadCallback loadCallback) {
    RewardedAd.load(context, adUnitId, adRequest, loadCallback);
  }

  /** Load a native ad. */
  public void loadNativeAd(
    Context context,
    String adUnitId,
    OnNativeAdLoadedListener onNativeAdLoadedListener,
    NativeAdOptions nativeAdOptions,
    AdListener adListener,
    AdRequest adRequest) {
    new AdLoader.Builder(context, adUnitId)
      .forNativeAd(onNativeAdLoadedListener)
      .withNativeAdOptions(nativeAdOptions)
      .withAdListener(adListener)
      .build()
      .loadAd(adRequest);
  }

  /** Load an ad manager native ad. */
  public void loadAdManagerNativeAd(
    Context context,
    String adUnitId,
    OnNativeAdLoadedListener onNativeAdLoadedListener,
    NativeAdOptions nativeAdOptions,
    AdListener adListener,
    AdManagerAdRequest adManagerAdRequest) {
    new AdLoader.Builder(context, adUnitId)
      .forNativeAd(onNativeAdLoadedListener)
      .withNativeAdOptions(nativeAdOptions)
      .withAdListener(adListener)
      .build()
      .loadAd(adManagerAdRequest);
  }
}
