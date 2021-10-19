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
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import java.util.List;
import java.util.Map;
import java.util.Objects;

class FlutterAdRequest {
  @Nullable private final List<String> keywords;
  @Nullable private final String contentUrl;
  @Nullable private final Boolean nonPersonalizedAds;
  @Nullable private final List<String> neighboringContentUrls;
  @Nullable private final Integer httpTimeoutMillis;
  @Nullable private final Location location;
  @Nullable private final String mediationExtrasIdentifier;
  @Nullable private final MediationNetworkExtrasProvider mediationNetworkExtrasProvider;

  protected static class Builder {
    @Nullable private List<String> keywords;
    @Nullable private String contentUrl;
    @Nullable private Boolean nonPersonalizedAds;
    @Nullable private List<String> neighboringContentUrls;
    @Nullable private Integer httpTimeoutMillis;
    @Nullable private Location location;
    @Nullable private String mediationExtrasIdentifier;
    @Nullable private MediationNetworkExtrasProvider mediationNetworkExtrasProvider;

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

    Builder setMediationNetworkExtrasIdentifier(@Nullable String mediationExtrasIdentifier) {
      this.mediationExtrasIdentifier = mediationExtrasIdentifier;
      return this;
    }

    Builder setMediationNetworkExtrasProvider(
        @Nullable MediationNetworkExtrasProvider mediationNetworkExtrasProvider) {
      this.mediationNetworkExtrasProvider = mediationNetworkExtrasProvider;
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

    @Nullable
    protected String getMediationExtrasIdentifier() {
      return mediationExtrasIdentifier;
    }

    @Nullable
    protected MediationNetworkExtrasProvider getMediationNetworkExtrasProvider() {
      return mediationNetworkExtrasProvider;
    }

    FlutterAdRequest build() {
      return new FlutterAdRequest(
          keywords,
          contentUrl,
          nonPersonalizedAds,
          neighboringContentUrls,
          httpTimeoutMillis,
          location,
          mediationExtrasIdentifier,
          mediationNetworkExtrasProvider);
    }
  }

  protected FlutterAdRequest(
      @Nullable List<String> keywords,
      @Nullable String contentUrl,
      @Nullable Boolean nonPersonalizedAds,
      @Nullable List<String> neighboringContentUrls,
      @Nullable Integer httpTimeoutMillis,
      @Nullable Location location,
      @Nullable String mediationExtrasIdentifier,
      @Nullable MediationNetworkExtrasProvider mediationNetworkExtrasProvider) {
    this.keywords = keywords;
    this.contentUrl = contentUrl;
    this.nonPersonalizedAds = nonPersonalizedAds;
    this.neighboringContentUrls = neighboringContentUrls;
    this.httpTimeoutMillis = httpTimeoutMillis;
    this.location = location;
    this.mediationExtrasIdentifier = mediationExtrasIdentifier;
    this.mediationNetworkExtrasProvider = mediationNetworkExtrasProvider;
  }

  /** Updates the {@link AdRequest.Builder} with the properties in this {@link FlutterAdRequest}. */
  protected AdRequest.Builder updateAdRequestBuilder(AdRequest.Builder builder, String adUnitId) {
    if (keywords != null) {
      for (final String keyword : keywords) {
        builder.addKeyword(keyword);
      }
    }
    if (contentUrl != null) {
      builder.setContentUrl(contentUrl);
    }

    Map<Class<? extends MediationExtrasReceiver>, Bundle> mediationNetworkExtras =
        mediationNetworkExtrasProvider == null
            ? null
            : mediationNetworkExtrasProvider.getMediationExtras(
                adUnitId, mediationExtrasIdentifier);
    if (mediationNetworkExtras != null) {
      // Handle npa here so we don't override any admob extras.
      if (nonPersonalizedAds != null && nonPersonalizedAds) {
        Bundle extras = mediationNetworkExtras.get(AdMobAdapter.class);
        if (extras == null) {
          extras = new Bundle();
        }
        extras.putString("npa", "1");
        mediationNetworkExtras.put(AdMobAdapter.class, extras);
      }
      for (Map.Entry<Class<? extends MediationExtrasReceiver>, Bundle> entry :
          mediationNetworkExtras.entrySet()) {
        builder.addNetworkExtrasBundle(entry.getKey(), entry.getValue());
      }
    } else if (nonPersonalizedAds != null && nonPersonalizedAds) {
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
    return builder;
  }

  AdRequest asAdRequest(String adUnitId) {
    return updateAdRequestBuilder(new AdRequest.Builder(), adUnitId).build();
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

  @Nullable
  protected String getMediationExtrasIdentifier() {
    return mediationExtrasIdentifier;
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
                && location.getTime() == request.location.getTime()))
        && Objects.equals(mediationExtrasIdentifier, request.mediationExtrasIdentifier)
        && Objects.equals(mediationNetworkExtrasProvider, request.mediationNetworkExtrasProvider);
  }

  @Override
  public int hashCode() {
    return Objects.hash(
        keywords,
        contentUrl,
        nonPersonalizedAds,
        neighboringContentUrls,
        httpTimeoutMillis,
        location,
        mediationExtrasIdentifier,
        mediationNetworkExtrasProvider);
  }
}
