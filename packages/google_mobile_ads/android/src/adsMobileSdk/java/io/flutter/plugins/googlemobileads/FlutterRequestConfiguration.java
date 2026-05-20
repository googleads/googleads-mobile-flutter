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

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.MobileAds;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration.MaxAdContentRating;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration.TagForChildDirectedTreatment;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration.TagForUnderAgeOfConsent;
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
    RequestConfiguration currentRequestConfiguration = MobileAds.getRequestConfiguration();
    RequestConfiguration.Builder builder =
        new RequestConfiguration.Builder()
            .setMaxAdContentRating(currentRequestConfiguration.getMaxAdContentRating())
            .setTagForChildDirectedTreatment(
                currentRequestConfiguration.getTagForChildDirectedTreatment())
            .setTagForUnderAgeOfConsent(currentRequestConfiguration.getTagForUnderAgeOfConsent())
            .setTestDeviceIds(currentRequestConfiguration.getTestDeviceIds());

    String maxAdContentRating = call.argument("maxAdContentRating");
    Integer tagForChildDirectedTreatment = call.argument("tagForChildDirectedTreatment");
    Integer tagForUnderAgeOfConsent = call.argument("tagForUnderAgeOfConsent");
    List<String> testDeviceIds = call.argument("testDeviceIds");
    if (maxAdContentRating != null) {
      if (maxAdContentRating == MaxAdContentRating.MAX_AD_CONTENT_RATING_G.getValue()) {
        builder.setMaxAdContentRating(MaxAdContentRating.MAX_AD_CONTENT_RATING_G);
      } else if (maxAdContentRating == MaxAdContentRating.MAX_AD_CONTENT_RATING_PG.getValue()) {
        builder.setMaxAdContentRating(MaxAdContentRating.MAX_AD_CONTENT_RATING_PG);
      } else if (maxAdContentRating == MaxAdContentRating.MAX_AD_CONTENT_RATING_T.getValue()) {
        builder.setMaxAdContentRating(MaxAdContentRating.MAX_AD_CONTENT_RATING_T);
      } else if (maxAdContentRating == MaxAdContentRating.MAX_AD_CONTENT_RATING_MA.getValue()) {
        builder.setMaxAdContentRating(MaxAdContentRating.MAX_AD_CONTENT_RATING_MA);
      } else {
        builder.setMaxAdContentRating(MaxAdContentRating.MAX_AD_CONTENT_RATING_UNSPECIFIED);
      }
    }
    if (tagForChildDirectedTreatment != null) {
      if (tagForChildDirectedTreatment
          == TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE.getValue()) {
        builder.setTagForChildDirectedTreatment(
            TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE);
      } else if (tagForChildDirectedTreatment
          == TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_FALSE.getValue()) {
        builder.setTagForChildDirectedTreatment(
            TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_FALSE);
      } else {
        builder.setTagForChildDirectedTreatment(
            TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_UNSPECIFIED);
      }
    }
    if (tagForUnderAgeOfConsent != null) {
      if (tagForUnderAgeOfConsent
          == TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE.getValue()) {
        builder.setTagForUnderAgeOfConsent(
            TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE);
      } else if (tagForUnderAgeOfConsent
          == TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_FALSE.getValue()) {
        builder.setTagForUnderAgeOfConsent(
            TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_FALSE);
      } else {
        builder.setTagForUnderAgeOfConsent(
            TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED);
      }
    }
    if (testDeviceIds != null) {
      builder.setTestDeviceIds(testDeviceIds);
    }
    RequestConfiguration rc = builder.build();
    MobileAds.setRequestConfiguration(rc);
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
        maxAdContentRating, tagForChildDirectedTreatment, tagForUnderAgeOfConsent, testDeviceIds);
  }
}
