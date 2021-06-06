package io.flutter.plugins.googlemobileads.mobileads;

import com.google.android.gms.ads.RequestConfiguration;

import java.util.List;

public class RequestConfigurationProxy implements MobileAdsChannelLibrary.$RequestConfiguration {
  public final RequestConfiguration.Builder requestConfiguration;

  public RequestConfigurationProxy(String maxAdContentRating,
                                   Integer tagForChildDirectedTreatment,
                                   Integer tagForUnderAgeOfConsent,
                                   List<String> testDeviceIds) {
    this(new RequestConfiguration.Builder(), maxAdContentRating, tagForChildDirectedTreatment, tagForUnderAgeOfConsent, testDeviceIds);
  }

  public RequestConfigurationProxy(RequestConfiguration.Builder requestConfiguration,
                                   String maxAdContentRating,
                                   Integer tagForChildDirectedTreatment,
                                   Integer tagForUnderAgeOfConsent,
                                   List<String> testDeviceIds) {
    this.requestConfiguration = requestConfiguration;
    if (maxAdContentRating != null) requestConfiguration.setMaxAdContentRating(maxAdContentRating);
    if (tagForChildDirectedTreatment != null) {
      requestConfiguration.setTagForChildDirectedTreatment(tagForChildDirectedTreatment);
    }
    if (tagForUnderAgeOfConsent != null) {
      requestConfiguration.setTagForUnderAgeOfConsent(tagForUnderAgeOfConsent);
    }
    if (testDeviceIds != null) requestConfiguration.setTestDeviceIds(testDeviceIds);
  }
}
