package io.flutter.plugins.googlemobileads.adcontainers;

import android.os.Bundle;

import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;

public class AdRequestProxy implements AdContainersChannelLibrary.$AdRequest {
  public final AdRequest.Builder adRequest;

  public AdRequestProxy() {
    this(new AdRequest.Builder());
  }

  public AdRequestProxy(AdRequest.Builder adRequest) {
    this.adRequest = adRequest;
  }

  @Override
  public Void addKeyword(String keyword) {
    adRequest.addKeyword(keyword);
    return null;
  }

  @Override
  public Void setContentUrl(String url) {
    adRequest.setContentUrl(url);
    return null;
  }

  @Override
  public Void setNonPersonalizedAds(Boolean nonPersonalizedAds) {
    final Bundle extras = new Bundle();
    extras.putString("npa", nonPersonalizedAds ? "1" : "0");
    adRequest.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    return null;
  }
}
