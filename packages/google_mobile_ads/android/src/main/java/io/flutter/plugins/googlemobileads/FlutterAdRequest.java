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
import com.google.android.gms.ads.AdRequest;
import java.util.List;
import java.util.Objects;

class FlutterAdRequest {
  @Nullable private final List<String> keywords;
  @Nullable private final String contentUrl;
  @Nullable private final Boolean nonPersonalizedAds;
  @Nullable private final List<String> neighboringContentUrls;
  @Nullable private final Integer httpTimeoutMillis;
  @Nullable private final Location location;

  protected static class Builder {
    @Nullable private List<String> keywords;
    @Nullable private String contentUrl;
    @Nullable private Boolean nonPersonalizedAds;
    @Nullable private List<String> neighboringContentUrls;
    @Nullable private Integer httpTimeoutMillis;
    @Nullable private Location location;

    Builder setKeywords(@Nullable List<String> keywords) {
      this.keywords = keywords;
      return this;
    }

    Builder setContentUrl(@Nullable String contentUrl) {
      this.contentUrl = contentUrl;
      return this;
    }

    Builder setNonPersonalizedAds(@Nullable Boolean nonPersonalizedAds) {
      this.nonPersonalizedAds = nonPersonalizedAds;
      return this;
    }

    Builder setNeighboringContentUrls(@Nullable List<String> neighboringContentUrls) {
      this.neighboringContentUrls = neighboringContentUrls;
      return this;
    }

    Builder setHttpTimeoutMillis(@Nullable Integer httpTimeoutMillis) {
      this.httpTimeoutMillis = httpTimeoutMillis;
      return this;
    }

    Builder setLocation(@Nullable Location location) {
      this.location = location;
      return this;
    }

    @Nullable
    protected List<String> getKeywords() {
      return keywords;
    }

    @Nullable
    protected String getContentUrl() {
      return contentUrl;
    }

    @Nullable
    protected Boolean getNonPersonalizedAds() {
      return nonPersonalizedAds;
    }

    @Nullable
    protected List<String> getNeighboringContentUrls() {
      return neighboringContentUrls;
    }

    @Nullable
    protected Integer getHttpTimeoutMillis() {
      return httpTimeoutMillis;
    }

    @Nullable
    protected Location getLocation() {
      return location;
    }

    FlutterAdRequest build() {
      return new FlutterAdRequest(
          keywords,
          contentUrl,
          nonPersonalizedAds,
          neighboringContentUrls,
          httpTimeoutMillis,
          location);
    }
  }

  protected FlutterAdRequest(
      @Nullable List<String> keywords,
      @Nullable String contentUrl,
      @Nullable Boolean nonPersonalizedAds,
      @Nullable List<String> neighboringContentUrls,
      @Nullable Integer httpTimeoutMillis,
      @Nullable Location location) {
    this.keywords = keywords;
    this.contentUrl = contentUrl;
    this.nonPersonalizedAds = nonPersonalizedAds;
    this.neighboringContentUrls = neighboringContentUrls;
    this.httpTimeoutMillis = httpTimeoutMillis;
    this.location = location;
  }

  AdRequest asAdRequest() {
    final AdRequest.Builder builder = new AdRequest.Builder();

    if (keywords != null) {
      for (final String keyword : keywords) {
        builder.addKeyword(keyword);
      }
    }
    if (contentUrl != null) {
      builder.setContentUrl(contentUrl);
    }
    if (nonPersonalizedAds != null && nonPersonalizedAds) {
      final Bundle extras = new Bundle();
      extras.putString("npa", "1");
      builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    }
    if (neighboringContentUrls != null) {
      builder.setNeighboringContentUrls(neighboringContentUrls);
    }
    if (httpTimeoutMillis != null) {
      builder.setHttpTimeoutMillis(httpTimeoutMillis);
    }
    if (location != null) {
      builder.setLocation(location);
    }
    builder.setRequestAgent(Constants.REQUEST_AGENT_PREFIX_VERSIONED);
    return builder.build();
  }

  @Nullable
  protected List<String> getKeywords() {
    return keywords;
  }

  @Nullable
  protected String getContentUrl() {
    return contentUrl;
  }

  @Nullable
  protected Boolean getNonPersonalizedAds() {
    return nonPersonalizedAds;
  }

  @Nullable
  protected List<String> getNeighboringContentUrls() {
    return neighboringContentUrls;
  }

  @Nullable
  protected Integer getHttpTimeoutMillis() {
    return httpTimeoutMillis;
  }

  @Nullable
  protected Location getLocation() {
    return location;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterAdRequest)) {
      return false;
    }

    FlutterAdRequest request = (FlutterAdRequest) o;
    return Objects.equals(keywords, request.keywords)
        && Objects.equals(contentUrl, request.contentUrl)
        && Objects.equals(nonPersonalizedAds, request.nonPersonalizedAds)
        && Objects.equals(neighboringContentUrls, request.neighboringContentUrls)
        && Objects.equals(httpTimeoutMillis, request.httpTimeoutMillis)
        && (location == null) == (request.location == null)
        && (location == null
            // We only care about these properties which are guaranteed by the Location API.
            || (location.getAccuracy() == request.location.getAccuracy()
                && location.getLongitude() == request.location.getLongitude()
                && location.getLatitude() == request.location.getLatitude()
                && location.getTime() == request.location.getTime()));
  }

  @Override
  public int hashCode() {
    return Objects.hash(
        keywords,
        contentUrl,
        nonPersonalizedAds,
        neighboringContentUrls,
        httpTimeoutMillis,
        location);
  }
}
