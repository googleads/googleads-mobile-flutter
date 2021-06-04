package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.admanager.AdManagerAdRequest;

import java.util.List;

public class AdManagerAdRequestProxy extends AdRequestProxy implements AdContainersChannelLibrary.$AdManagerAdRequest {
  public AdManagerAdRequestProxy() {
    this(new AdManagerAdRequest.Builder());
  }
  
  public AdManagerAdRequestProxy(AdManagerAdRequest.Builder adManagerAdRequest) {
    super(adManagerAdRequest);
  }

  @Override
  public Void addCustomTargeting(String key, String value) {
    ((AdManagerAdRequest.Builder) adRequest).addCustomTargeting(key, value);
    return null;
  }

  @Override
  public Void addCustomTargetingList(String key, List<String> values) {
    ((AdManagerAdRequest.Builder) adRequest).addCustomTargeting(key, values);
    return null;
  }
}
