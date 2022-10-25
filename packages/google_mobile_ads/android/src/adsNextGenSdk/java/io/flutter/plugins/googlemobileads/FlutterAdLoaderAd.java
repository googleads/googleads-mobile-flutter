package io.flutter.plugins.googlemobileads;

import android.util.Log;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize;
import com.google.android.libraries.ads.mobile.sdk.banner.AdView;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAd;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoaderCallback;
import io.flutter.plugin.platform.PlatformView;
import java.util.List;

class FlutterAdLoaderAd extends FlutterAd implements FlutterAdLoadedListener, NativeAdLoaderCallback {
  private static final String TAG = "FlutterAdLoaderAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdLoader adLoader;
  @Nullable private FlutterAdRequest request;
  @Nullable private FlutterAdManagerAdRequest adManagerRequest;
  @Nullable private AdLoaderAdType type;
  @Nullable private String formatId;
  @Nullable private View view;
  @Nullable protected BannerParameters bannerParameters;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdRequest request;
    @Nullable private FlutterAdManagerAdRequest adManagerRequest;
    @Nullable private Integer id;
    @Nullable private FlutterAdLoader adLoader;
    @Nullable private FlutterBannerParameters bannerParameters;

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

    public Builder setBanner(@Nullable FlutterBannerParameters bannerParameters) {
      this.bannerParameters = bannerParameters;
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

      if (bannerParameters != null) {
        adLoaderAd.bannerParameters = bannerParameters.asBannerParameters();
      }

      return adLoaderAd;
    }
  }

  static class BannerParameters {
    @NonNull final List<AdSize> adSizes;
    @Nullable final FlutterAdManagerAdViewOptions adManagerAdViewOptions;

    BannerParameters(
        @NonNull List<AdSize> adSizes,
        @Nullable FlutterAdManagerAdViewOptions adManagerAdViewOptions) {
      this.adSizes = adSizes;
      this.adManagerAdViewOptions = adManagerAdViewOptions;
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
      adLoader.loadAdLoaderAd(adUnitId, loadedListener, bannerParameters);
    } else if (adManagerRequest != null) {
      adLoader.loadAdManagerAdLoaderAd(adUnitId, loadedListener, bannerParameters);
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
  @Nullable
  public PlatformView getPlatformView() {
    if (view == null) {
      return null;
    }

    return new FlutterPlatformView(view);
  }

  @Override
  public void onAdLoaded() {
    //  handled by onBannerAdLoaded
  }

  @Override
  public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterAd.FlutterLoadAdError(loadAdError));
  }

  @Override
  public void onBannerAdLoaded(@NonNull BannerAd bannerAd) {
    AdView adView = new AdView(manager.getActivity());
    adView.registerBannerAd(bannerAd, manager.getActivity());

    view = adView;
    type = AdLoaderAdType.BANNER;

    bannerAd.setAdEventCallback(new FlutterBannerAdListener(adId, manager, this));

    manager.onAdLoaded(adId, bannerAd.getResponseInfo());
  }

  @Override
  void dispose() {
    if (view == null) {
      return;
    }

    if (view instanceof AdView) {
      ((AdView) view).destroy();
    }

    view = null;
  }
}
