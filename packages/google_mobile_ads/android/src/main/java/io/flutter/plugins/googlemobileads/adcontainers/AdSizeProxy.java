package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.Nullable;

import com.google.android.gms.ads.AdSize;

import java.util.ArrayList;
import java.util.List;

public class AdSizeProxy implements AdContainersChannelLibrary.$AdSize {
  public final AdSize adSize;
  
  public static List<AdSize> fromList(List<AdContainersChannelLibrary.$AdSize> adSizes) {
    final List<AdSize> newSizeList = new ArrayList<>();
    for (AdContainersChannelLibrary.$AdSize adSize : adSizes) {
      newSizeList.add(((AdSizeProxy)adSize).adSize);
    }
    return newSizeList;
  }

  public static AdSizeProxy getPortraitAnchoredAdaptiveBannerAdSize(Integer width, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    return new AdSizeProxy(AdSize.getPortraitAnchoredAdaptiveBannerAdSize(implementations.context, width), implementations);
  }

  public static AdSizeProxy getLandscapeAnchoredAdaptiveBannerAdSize(Integer width, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    return new AdSizeProxy(AdSize.getLandscapeAnchoredAdaptiveBannerAdSize(implementations.context, width), implementations);
  }

  private static AdSize getAdSizeConstant(String constant) {
    switch (constant) {
      case "banner":
        return AdSize.BANNER;
      case "largeBanner":
        return AdSize.LARGE_BANNER;
      case "mediumRectangle":
        return AdSize.MEDIUM_RECTANGLE;
      case "fullBanner":
        return AdSize.FULL_BANNER;
      case "leaderboard":
        return AdSize.LEADERBOARD;
      case "smartBannerPortrait":
      case "smartBannerLandscape":
        return AdSize.SMART_BANNER;
    }

    throw new IllegalArgumentException("No constant found for value: " + constant);
  }
  
  public AdSizeProxy(Integer width, Integer height, String constant) {
    this(constant != null ? getAdSizeConstant(constant) : new AdSize(width, height), null);
  }

  public AdSizeProxy(AdSize adSize, @Nullable AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adSize = adSize;
    if (implementations != null) {
      implementations.getChannelAdSize().$$create(this, false, adSize.getWidth(), adSize.getHeight(), null);
    }
  }
}
