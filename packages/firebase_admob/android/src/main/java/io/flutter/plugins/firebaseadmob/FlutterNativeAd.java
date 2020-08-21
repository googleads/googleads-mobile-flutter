package io.flutter.plugins.firebaseadmob;

import android.view.View;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin.NativeAdFactory;
import java.util.Map;

public class FlutterNativeAd extends FlutterAd implements PlatformView {
  private UnifiedNativeAdView ad;
  final NativeAdFactory adFactory;
  public Map<String, Object> customOptions;

  public FlutterNativeAd(
      AdInstanceManager manager,
      String adUnitId,
      FlutterAdRequest request,
      io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin.NativeAdFactory adFactory,
      Map<String, Object> customOptions) {
    super(manager, adUnitId, request);
    this.adFactory = adFactory;
    this.customOptions = customOptions;
  }

  @Override
  void load() {
    final AdLoader adLoader =
        new AdLoader.Builder(manager.activity, adUnitId)
            .forUnifiedNativeAd(
                new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
                  @Override
                  public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                    ad = adFactory.createNativeAd(unifiedNativeAd, customOptions);
                    manager.onAdLoaded(FlutterNativeAd.this);
                  }
                })
            .withNativeAdOptions(new NativeAdOptions.Builder().build())
            .withAdListener(
                new FlutterAdListener(manager, this) {
                  @Override
                  public void onAdClicked() {
                    manager.onNativeAdClicked(FlutterNativeAd.this);
                  }

                  @Override
                  public void onAdImpression() {
                    manager.onNativeAdImpression(FlutterNativeAd.this);
                  }
                })
            .build();
    adLoader.loadAd(request.asAdRequest());
  }

  @Override
  public View getView() {
    return ad;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
