package io.flutter.plugins.firebaseadmob;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdView;
import io.flutter.plugin.platform.PlatformView;

class FlutterBannerAd extends FlutterAd implements PlatformView {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdSize size;
  @Nullable private FlutterAdRequest request;
  @Nullable private AdView view;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdSize size;
    @Nullable private FlutterAdRequest request;

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setSize(@NonNull FlutterAdSize size) {
      this.size = size;
      return this;
    }

    public Builder setRequest(@Nullable FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    FlutterBannerAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      } else if (size == null) {
        throw new IllegalStateException("Size cannot not be null.");
      }

      final FlutterBannerAd bannerAd = new FlutterBannerAd(manager, adUnitId, size);
      bannerAd.request = request;
      return bannerAd;
    }
  }

  private FlutterBannerAd(
      @NonNull AdInstanceManager manager, @NonNull String adUnitId, @NonNull FlutterAdSize size) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.size = size;
  }

  @Override
  void load() {
    view = new AdView(manager.activity);
    view.setAdUnitId(adUnitId);
    view.setAdSize(size.size);
    view.setAdListener(new FlutterAdListener(manager, this));

    if (request != null) {
      view.loadAd(request.asAdRequest());
    } else {
      view.loadAd(new FlutterAdRequest.Builder().build().asAdRequest());
    }
  }

  @Override
  @Nullable
  public View getView() {
    return view;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
