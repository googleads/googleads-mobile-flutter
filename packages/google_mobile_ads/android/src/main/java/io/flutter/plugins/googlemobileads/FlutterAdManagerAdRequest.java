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

import android.location.Location;
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
class FlutterAdManagerAdRequest extends FlutterAdRequest {

  @Nullable private Map<String, String> customTargeting;
  @Nullable private Map<String, List<String>> customTargetingLists;

  static class Builder extends FlutterAdRequest.Builder {

    @Nullable private Map<String, String> customTargeting;
    @Nullable private Map<String, List<String>> customTargetingLists;

    public Builder setCustomTargeting(@Nullable Map<String, String> customTargeting) {
      this.customTargeting = customTargeting;
      return this;
    }

    public Builder setCustomTargetingLists(
        @Nullable Map<String, List<String>> customTargetingLists) {
      this.customTargetingLists = customTargetingLists;
      return this;
    }

    FlutterAdManagerAdRequest build() {
      return new FlutterAdManagerAdRequest(
          getKeywords(),
          getContentUrl(),
          customTargeting,
          customTargetingLists,
          getNonPersonalizedAds(),
          getNeighboringContentUrls(),
          getHttpTimeoutMillis(),
          getLocation());
    }
  }

  private FlutterAdManagerAdRequest(
      @Nullable List<String> keywords,
      @Nullable String contentUrl,
      @Nullable Map<String, String> customTargeting,
      @Nullable Map<String, List<String>> customTargetingLists,
      @Nullable Boolean nonPersonalizedAds,
      @Nullable List<String> neighboringContentUrls,
      @Nullable Integer httpTimeoutMillis,
      @Nullable Location location) {
    super(
        keywords,
        contentUrl,
        nonPersonalizedAds,
        neighboringContentUrls,
        httpTimeoutMillis,
        location);
    this.customTargeting = customTargeting;
    this.customTargetingLists = customTargetingLists;
  }

  AdManagerAdRequest asAdManagerAdRequest() {
    final AdManagerAdRequest.Builder builder = new AdManagerAdRequest.Builder();
    if (getKeywords() != null) {
      for (final String keyword : getKeywords()) {
        builder.addKeyword(keyword);
      }
    }

    if (getContentUrl() != null) {
      builder.setContentUrl(getContentUrl());
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
    if (getNonPersonalizedAds() != null && getNonPersonalizedAds()) {
      final Bundle extras = new Bundle();
      extras.putString("npa", "1");
      builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    }
    if (getLocation() != null) {
      builder.setLocation(getLocation());
    }
    builder.setRequestAgent(Constants.REQUEST_AGENT_PREFIX_VERSIONED);
    return builder.build();
  }

  @Nullable
  protected Map<String, String> getCustomTargeting() {
    return customTargeting;
  }

  @Nullable
  protected Map<String, List<String>> getCustomTargetingLists() {
    return customTargetingLists;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterAdManagerAdRequest)) {
      return false;
    }

    FlutterAdManagerAdRequest request = (FlutterAdManagerAdRequest) o;
    return super.equals(o)
        && Objects.equals(customTargeting, request.customTargeting)
        && Objects.equals(customTargetingLists, request.customTargetingLists);
  }

  @Override
  public int hashCode() {
    return Objects.hash(super.hashCode(), customTargeting, customTargetingLists);
  }
}
