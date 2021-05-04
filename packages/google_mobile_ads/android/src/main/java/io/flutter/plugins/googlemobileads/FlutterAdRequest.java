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
import com.google.android.gms.ads.AdRequest;
import java.util.List;

class FlutterAdRequest {
  @Nullable private List<String> keywords;
  @Nullable private String contentUrl;
  @Nullable private Boolean nonPersonalizedAds;

  static class Builder {
    @Nullable private List<String> keywords;
    @Nullable private String contentUrl;
    @Nullable private Boolean nonPersonalizedAds;

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

    FlutterAdRequest build() {
      final FlutterAdRequest request = new FlutterAdRequest();
      request.keywords = keywords;
      request.contentUrl = contentUrl;
      request.nonPersonalizedAds = nonPersonalizedAds;
      return request;
    }
  }

  private FlutterAdRequest() {}

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
  public Boolean getNonPersonalizedAds() {
    return nonPersonalizedAds;
  }
}
