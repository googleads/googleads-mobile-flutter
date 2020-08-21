package io.flutter.plugins.firebaseadmob;

import android.view.View;
import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import io.flutter.plugin.platform.PlatformView;

class FlutterBannerAd extends FlutterAd implements PlatformView {
  private final FlutterAdSize size;
  private AdView view;

  static class FlutterAdSize {
    @NonNull final AdSize size;
    final int width;
    final int height;

    public FlutterAdSize(int width, int height) {
      this.width = width;
      this.height = height;

      // These values must remain consistent with `AdSize.smartBanner` in Dart.
      if (width == -1 && height == -1) {
        this.size = AdSize.SMART_BANNER;
      } else {
        this.size = new AdSize(width, height);
      }
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (!(o instanceof FlutterAdSize)) return false;

      final FlutterAdSize that = (FlutterAdSize) o;

      if (width != that.width) return false;
      return height == that.height;
    }

    @Override
    public int hashCode() {
      int result = width;
      result = 31 * result + height;
      return result;
    }
  }

  FlutterBannerAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdSize size,
      @NonNull FlutterAdRequest request) {
    super(manager, adUnitId, request);
    this.size = size;
  }

  @Override
  void load() {
    view = new AdView(manager.activity);
    view.setAdUnitId(adUnitId);
    view.setAdSize(size.size);
    view.setAdListener(new FlutterAdListener(manager, this));
    view.loadAd(request.asAdRequest());
  }

  @Override
  public View getView() {
    return view;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
