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

import androidx.annotation.Nullable;
import com.google.android.gms.ads.doubleclick.PublisherAdRequest;
import java.util.List;
import java.util.Map;

/**
 * Instantiates and serializes {@link com.google.android.gms.ads.doubleclick.PublisherAdRequest} for
 * the Google Mobile Ads Plugin.
 */
class FlutterPublisherAdRequest {
  @Nullable private List<String> keywords;
  @Nullable private String contentUrl;
  @Nullable private Map<String, String> customTargeting;
  @Nullable private Map<String, List<String>> customTargetingLists;

  static class Builder {
    @Nullable private List<String> keywords;
    @Nullable private String contentUrl;
    @Nullable private Map<String, String> customTargeting;
    @Nullable private Map<String, List<String>> customTargetingLists;

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

    FlutterPublisherAdRequest build() {
      final FlutterPublisherAdRequest request = new FlutterPublisherAdRequest();
      request.keywords = keywords;
      request.contentUrl = contentUrl;
      request.customTargeting = customTargeting;
      request.customTargetingLists = customTargetingLists;
      return request;
    }
  }

  private FlutterPublisherAdRequest() {}

  PublisherAdRequest asPublisherAdRequest() {
    final PublisherAdRequest.Builder builder = new PublisherAdRequest.Builder();
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

    builder.setRequestAgent("Flutter");
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

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof FlutterPublisherAdRequest)) return false;

    FlutterPublisherAdRequest request = (FlutterPublisherAdRequest) o;

    if (keywords != null ? !keywords.equals(request.keywords) : request.keywords != null) {
      return false;
    }
    if (contentUrl != null ? !contentUrl.equals(request.contentUrl) : request.contentUrl != null) {
      return false;
    }
    if (customTargeting != null
        ? !customTargeting.equals(request.customTargeting)
        : request.customTargeting != null) {
      return false;
    }
    return customTargetingLists != null
        ? customTargetingLists.equals(request.customTargetingLists)
        : request.customTargetingLists == null;
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
