// Copyright 2021 Google LLC
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

import android.os.Bundle;
import androidx.annotation.Nullable;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Instantiates and serializes {@link com.google.android.gms.ads.admanager.AdManagerAdRequest} for
 * the Google Mobile Ads Plugin.
 */
class FlutterAdManagerAdRequest {
  @Nullable private List<String> keywords;
  @Nullable private String contentUrl;
  @Nullable private Map<String, String> customTargeting;
  @Nullable private Map<String, List<String>> customTargetingLists;
  @Nullable private Boolean nonPersonalizedAds;

  public static class Builder {
    @Nullable private List<String> keywords;
    @Nullable private String contentUrl;
    @Nullable private Map<String, String> customTargeting;
    @Nullable private Map<String, List<String>> customTargetingLists;
    @Nullable private Boolean nonPersonalizedAds;

    public Builder setKeywords(@Nullable List<String> keywords) {
      this.keywords = keywords;
      return this;
    }

    public Builder setContentUrl(@Nullable String contentUrl) {
      this.contentUrl = contentUrl;
      return this;
    }

    public Builder setCustomTargeting(@Nullable Map<String, String> customTargeting) {
      this.customTargeting = customTargeting;
      return this;
    }

    public Builder setCustomTargetingLists(
        @Nullable Map<String, List<String>> customTargetingLists) {
      this.customTargetingLists = customTargetingLists;
      return this;
    }

    public Builder setNonPersonalizedAds(@Nullable Boolean nonPersonalizedAds) {
      this.nonPersonalizedAds = nonPersonalizedAds;
      return this;
    }

    FlutterAdManagerAdRequest build() {
      final FlutterAdManagerAdRequest request = new FlutterAdManagerAdRequest();
      request.keywords = keywords;
      request.contentUrl = contentUrl;
      request.customTargeting = customTargeting;
      request.customTargetingLists = customTargetingLists;
      request.nonPersonalizedAds = nonPersonalizedAds;
      return request;
    }
  }

  private FlutterAdManagerAdRequest() {}

  AdManagerAdRequest asAdManagerAdRequest() {
    final AdManagerAdRequest.Builder builder = new AdManagerAdRequest.Builder();
    if (keywords != null) {
      for (final String keyword : keywords) {
        builder.addKeyword(keyword);
      }
    }

    if (contentUrl != null) {
      builder.setContentUrl(contentUrl);
    }
    if (customTargeting != null) {
      for (final Map.Entry<String, String> entry : customTargeting.entrySet()) {
        builder.addCustomTargeting(entry.getKey(), entry.getValue());
      }
    }
    if (customTargetingLists != null) {
      for (final Map.Entry<String, List<String>> entry : customTargetingLists.entrySet()) {
        builder.addCustomTargeting(entry.getKey(), entry.getValue());
      }
    }
    if (nonPersonalizedAds != null && nonPersonalizedAds) {
      final Bundle extras = new Bundle();
      extras.putString("npa", "1");
      builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    }
    builder.setRequestAgent(Constants.REQUEST_AGENT_PREFIX_VERSIONED);
    return builder.build();
  }

  @Nullable
  public List<String> getKeywords() {
    return keywords;
  }

  @Nullable
  public String getContentUrl() {
    return contentUrl;
  }

  @Nullable
  public Map<String, String> getCustomTargeting() {
    return customTargeting;
  }

  @Nullable
  public Map<String, List<String>> getCustomTargetingLists() {
    return customTargetingLists;
  }

  @Nullable
  public Boolean getNonPersonalizedAds() {
    return nonPersonalizedAds;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterAdManagerAdRequest)) {
      return false;
    }

    FlutterAdManagerAdRequest request = (FlutterAdManagerAdRequest) o;

    return Objects.equals(keywords, request.keywords)
        && Objects.equals(contentUrl, request.contentUrl)
        && Objects.equals(customTargeting, request.customTargeting)
        && Objects.equals(nonPersonalizedAds, request.nonPersonalizedAds)
        && Objects.equals(customTargetingLists, request.customTargetingLists);
  }

  @Override
  public int hashCode() {
    int result = keywords != null ? keywords.hashCode() : 0;
    result = 31 * result + (contentUrl != null ? contentUrl.hashCode() : 0);
    result = 31 * result + (customTargeting != null ? customTargeting.hashCode() : 0);
    result = 31 * result + (customTargetingLists != null ? customTargetingLists.hashCode() : 0);
    return result;
  }
}
