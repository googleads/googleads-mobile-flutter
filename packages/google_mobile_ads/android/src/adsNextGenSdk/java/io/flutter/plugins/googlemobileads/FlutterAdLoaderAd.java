package io.flutter.plugins.googlemobileads;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoaderCallback;

class FlutterAdLoaderAd extends FlutterAd implements FlutterAdLoadedListener, NativeAdLoaderCallback {
  private static final String TAG = "FlutterAdLoaderAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdLoader adLoader;
  @Nullable private FlutterAdRequest request;
  @Nullable private FlutterAdManagerAdRequest adManagerRequest;
  @Nullable private AdLoaderAdType type;
  @Nullable private String formatId;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdRequest request;
    @Nullable private FlutterAdManagerAdRequest adManagerRequest;
    @Nullable private Integer id;
    @Nullable private FlutterAdLoader adLoader;

    public Builder setId(int id) {
      this.id = id;
      return this;
    }

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setRequest(@NonNull FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    public Builder setAdManagerRequest(@NonNull FlutterAdManagerAdRequest adManagerRequest) {
      this.adManagerRequest = adManagerRequest;
      return this;
    }

    public Builder setFlutterAdLoader(@NonNull FlutterAdLoader adLoader) {
      this.adLoader = adLoader;
      return this;
    }

    FlutterAdLoaderAd build() {
      if (manager == null) {
        throw new IllegalStateException("manager must be provided");
      }

      if (adUnitId == null) {
        throw new IllegalStateException("adUnitId must be provided");
      }

      if (request == null && adManagerRequest == null) {
        throw new IllegalStateException("Either request or adManagerRequest must be provided");
      }

      final FlutterAdLoaderAd adLoaderAd;

      if (request == null) {
        adLoaderAd = new FlutterAdLoaderAd(id, manager, adUnitId, adManagerRequest, adLoader);
      } else {
        adLoaderAd = new FlutterAdLoaderAd(id, manager, adUnitId, request, adLoader);
      }
      return adLoaderAd;
    }
  }

  protected FlutterAdLoaderAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdLoader adLoader) {
    super(adId);

    this.type = AdLoaderAdType.UNKNOWN;
    this.formatId = null;

    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.adLoader = adLoader;
  }

  protected FlutterAdLoaderAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdManagerAdRequest adManagerRequest,
      @NonNull FlutterAdLoader adLoader) {
    super(adId);

    this.type = AdLoaderAdType.UNKNOWN;
    this.formatId = null;

    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adManagerRequest = adManagerRequest;
    this.adLoader = adLoader;
  }

  @Override
  void load() {
    final NativeAdLoaderCallback loadedListener = new FlutterAdLoaderAdLoadedListener(this);
    // Note we delegate loading the ad to FlutterAdLoader mainly for testing purposes.
    // As of 20.0.0 of GMA, mockito is unable to mock AdLoader.
    if (request != null) {
      adLoader.loadAdLoaderAd(adUnitId, loadedListener);
    } else if (adManagerRequest != null) {
      adLoader.loadAdManagerAdLoaderAd(adUnitId, loadedListener);
    } else {
      Log.e(TAG, "A null or invalid ad request was provided.");
    }
  }

  @Nullable
  AdLoaderAdType getAdLoaderAdType() {
    return type;
  }

  @Nullable
  FlutterAdSize getAdSize() {
    return null;
  }

  @Nullable
  String getFormatId() {
    return formatId;
  }

  @Override
  public void onAdLoaded() {}

  @Override
  public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterAd.FlutterLoadAdError(loadAdError));
  }

  @Override
  void dispose() {}
}
