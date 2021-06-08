package io.flutter.plugins.googlemobileads;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.appopen.AppOpenAd;

import java.util.Date;

class FlutterAppOpenAd extends FlutterAd.FlutterOverlayAd implements LifecycleObserver {
  private static final String TAG = "FlutterAppOpenAd";

  private long loadTime = 0;

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  private final int adOrientation;
  private FlutterAdRequest request;
  private FlutterAdManagerAdRequest adManagerAdRequest;
  @Nullable private AppOpenAd appOpenAd;
  @NonNull private final FlutterAdLoader flutterAdLoader;
  private final FlutterAppOpenAdLifecycleCallbacks lifecycleManager;

  /**
   * This method will be fired every time the app comes to foreground.
   * <p>
   * The ad would not be shown when the app comes into foreground from a
   * cold start as it might have been disposed by the platform & that old ad won't earn any revenue.
   *
   * @see <a href="https://developers.google.com/admob/ios/app-open-ads#consider_ad_expiration">Ad Expiration</a>
   */
  @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
  private void onResume() {
    if (isAdAvailable()) show();
  }

  public FlutterAppOpenAd(
          @NonNull AdInstanceManager manager,
          @NonNull String adUnitId,
          @NonNull FlutterAdRequest request,
          int adOrientation,
          @NonNull FlutterAdLoader flutterAdLoader) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.adOrientation = adOrientation;
    this.flutterAdLoader = flutterAdLoader;

    this.lifecycleManager = new FlutterAppOpenAdLifecycleCallbacks(manager.activity.getApplication());
    ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
  }

  public FlutterAppOpenAd(
          @NonNull AdInstanceManager manager,
          @NonNull String adUnitId,
          @NonNull FlutterAdManagerAdRequest adManagerAdRequest,
          int adOrientation,
          @NonNull FlutterAdLoader flutterAdLoader) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adManagerAdRequest = adManagerAdRequest;
    this.adOrientation = adOrientation;
    this.flutterAdLoader = flutterAdLoader;

    this.lifecycleManager = new FlutterAppOpenAdLifecycleCallbacks(manager.activity.getApplication());
    ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
  }

  @Override
  void load() {
    if (isAdAvailable()) {
      Log.e(TAG, "The app open ad exists & is under 4 hours");
      return;
    }

    if (manager != null && adUnitId != null) {
      if (request != null)
        flutterAdLoader.loadAppOpenAd(
                manager.activity,
                adUnitId,
                request.asAdRequest(),
                adOrientation,
                getAppOpenAdLoadCallback());
      else if (adManagerAdRequest != null)
        flutterAdLoader.loadAdManagerAppOpenAd(
                manager.activity,
                adUnitId,
                adManagerAdRequest.asAdManagerAdRequest(),
                adOrientation,
                getAppOpenAdLoadCallback()
        );
    }
  }

  /**
   *  Not to be used directly.
   *  Should only be called after the Ad is dismissed.
   *
   *  This method is required to set the
   *  appOpenAd variable null, so that we can load the ad again.
   */
  public void reload() {
    FlutterAppOpenAd.this.appOpenAd = null;
    FlutterAppOpenAd.this.load();
  }

  private AppOpenAd.AppOpenAdLoadCallback getAppOpenAdLoadCallback() {
    return new AppOpenAd.AppOpenAdLoadCallback() {
      @Override
      public void onAdLoaded(@NonNull AppOpenAd appOpenAd) {
        FlutterAppOpenAd.this.appOpenAd = appOpenAd;
        FlutterAppOpenAd.this.loadTime = (new Date()).getTime();
        FlutterAppOpenAd.this.manager.onAdLoaded(
                FlutterAppOpenAd.this, appOpenAd.getResponseInfo());
      }

      @Override
      public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
        FlutterAppOpenAd.this.manager.onAdFailedToLoad(
                FlutterAppOpenAd.this, new FlutterAd.FlutterLoadAdError(loadAdError));
      }
    };
  }

  private boolean isAdAvailable() {
    return appOpenAd != null && wasLoadTimeLessThanNHoursAgo();
  }

  private boolean wasLoadTimeLessThanNHoursAgo() {
    long dateDifference = (new Date()).getTime() - this.loadTime;
    long numMilliSecondsPerHour = 3600000;
    return (dateDifference < (numMilliSecondsPerHour * (long) 4));
  }

  @Override
  public void show() {
    if (appOpenAd == null) {
      Log.e(TAG, "The app open ad wasn't loaded yet.");
      return;
    }

    // Although this shouldn't happen but anyways.
    if (lifecycleManager.currentActivity == null) {
      Log.e(TAG, "The current activity is null.");
      return;
    }

    appOpenAd.setFullScreenContentCallback(new FlutterFullScreenContentCallback(manager, FlutterAppOpenAd.this));
    appOpenAd.show(lifecycleManager.currentActivity);
  }
}