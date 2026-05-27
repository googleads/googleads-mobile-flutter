// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package io.flutter.plugins.googlemobileads;

import static com.google.android.gms.ads.RequestConfiguration.TAG_FOR_CHILD_DIRECTED_TREATMENT_UNSPECIFIED;
import static com.google.android.gms.ads.RequestConfiguration.TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.RequestConfiguration;
import com.google.errorprone.annotations.CanIgnoreReturnValue;
import io.flutter.plugin.common.MethodCall;
import java.util.List;
import java.util.Objects;

class FlutterRequestConfiguration {

  @Nullable private final String maxAdContentRating;
  private final Integer tagForChildDirectedTreatment;
  private final Integer tagForUnderAgeOfConsent;
  @Nullable private final List<String> testDeviceIds;

  public static void updateRequestConfiguration(@NonNull MethodCall call) {
    RequestConfiguration.Builder builder = MobileAds.getRequestConfiguration().toBuilder();
    String maxAdContentRating = call.argument("maxAdContentRating");
    Integer tagForChildDirectedTreatment = call.argument("tagForChildDirectedTreatment");
    Integer tagForUnderAgeOfConsent = call.argument("tagForUnderAgeOfConsent");
    List<String> testDeviceIds = call.argument("testDeviceIds");
    if (maxAdContentRating != null) {
      builder.setMaxAdContentRating(maxAdContentRating);
    }
    if (tagForChildDirectedTreatment != null) {
      builder.setTagForChildDirectedTreatment(tagForChildDirectedTreatment);
    }
    if (tagForUnderAgeOfConsent != null) {
      builder.setTagForUnderAgeOfConsent(tagForUnderAgeOfConsent);
    }
    if (testDeviceIds != null) {
      builder.setTestDeviceIds(testDeviceIds);
    }
    MobileAds.setRequestConfiguration(builder.build());
  }

  protected static class Builder {
    @Nullable private String maxAdContentRating;
    private Integer tagForChildDirectedTreatment = TAG_FOR_CHILD_DIRECTED_TREATMENT_UNSPECIFIED;
    private Integer tagForUnderAgeOfConsent = TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED;
    @Nullable private List<String> testDeviceIds;

    @CanIgnoreReturnValue
    Builder setMaxAdContentRating(String maxAdContentRating) {
      this.maxAdContentRating = maxAdContentRating;
      return this;
    }

    @CanIgnoreReturnValue
    Builder setTagForChildDirectedTreatment(Integer tagForChildDirectedTreatment) {
      this.tagForChildDirectedTreatment = tagForChildDirectedTreatment;
      return this;
    }

    @CanIgnoreReturnValue
    Builder setTagForUnderAgeOfConsent(Integer tagForUnderAgeOfConsent) {
      this.tagForUnderAgeOfConsent = tagForUnderAgeOfConsent;
      return this;
    }

    @CanIgnoreReturnValue
    Builder setTestDeviceIds(List<String> testDeviceIds) {
      this.testDeviceIds = testDeviceIds;
      return this;
    }

    @Nullable
    protected String getMaxAdContentRating() {
      return maxAdContentRating;
    }

    protected Integer getTagForChildDirectedTreatment() {
      return tagForChildDirectedTreatment;
    }

    protected Integer getTagForUnderAgeOfConsent() {
      return tagForUnderAgeOfConsent;
    }

    @Nullable
    protected List<String> getTestDeviceIds() {
      return testDeviceIds;
    }

    FlutterRequestConfiguration build() {
      return new FlutterRequestConfiguration(
          maxAdContentRating, tagForChildDirectedTreatment, tagForUnderAgeOfConsent, testDeviceIds);
    }
  }

  public FlutterRequestConfiguration(
      @Nullable String maxAdContentRating,
      Integer tagForChildDirectedTreatment,
      Integer tagForUnderAgeOfConsent,
      @Nullable List<String> testDeviceIds) {
    this.maxAdContentRating = maxAdContentRating;
    this.tagForChildDirectedTreatment = tagForChildDirectedTreatment;
    this.tagForUnderAgeOfConsent = tagForUnderAgeOfConsent;
    this.testDeviceIds = testDeviceIds;
  }

  @Nullable
  protected String getMaxAdContentRating() {
    return maxAdContentRating;
  }

  protected Integer getTagForChildDirectedTreatment() {
    return tagForChildDirectedTreatment;
  }

  protected Integer getTagForUnderAgeOfConsent() {
    return tagForUnderAgeOfConsent;
  }

  @Nullable
  protected List<String> getTestDeviceIds() {
    return testDeviceIds;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterRequestConfiguration)) {
      return false;
    }

    FlutterRequestConfiguration config = (FlutterRequestConfiguration) o;
    return Objects.equals(maxAdContentRating, config.maxAdContentRating)
        && Objects.equals(tagForChildDirectedTreatment, config.tagForChildDirectedTreatment)
        && Objects.equals(tagForUnderAgeOfConsent, config.tagForUnderAgeOfConsent)
        && Objects.equals(testDeviceIds, config.testDeviceIds);
  }

  @Override
  public int hashCode() {
    return Objects.hash(
        maxAdContentRating,
        tagForChildDirectedTreatment,
        tagForUnderAgeOfConsent,
        testDeviceIds);
  }
}
