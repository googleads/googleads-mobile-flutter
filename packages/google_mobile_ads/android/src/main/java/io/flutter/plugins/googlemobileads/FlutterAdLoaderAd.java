// Copyright 2022 Google LLC
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

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdListener;

/**
 * A central wrapper for {@link AdManagerAdView}, {@link NativeCustomFormatAd} and {@link NativeAd}
 * instances served for a single {@link AdRequest} or {@link AdManagerAdRequest}
 */
class FlutterAdLoaderAd extends FlutterAd {
  private static final String TAG = "FlutterAdLoaderAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdLoader adLoader;
  @Nullable private FlutterAdRequest request;
  @Nullable private FlutterAdManagerAdRequest adManagerRequest;
  @Nullable private AdLoaderAdType type;
  @Nullable private String formatId;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdRequest request;
    @Nullable private FlutterAdManagerAdRequest adManagerRequest;
    @Nullable private Integer id;
    @Nullable private FlutterAdLoader adLoader;

    public Builder setId(int id) {
      this.id = id;
      return this;
    }

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setRequest(@NonNull FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    public Builder setAdManagerRequest(@NonNull FlutterAdManagerAdRequest adManagerRequest) {
      this.adManagerRequest = adManagerRequest;
      return this;
    }

    public Builder setFlutterAdLoader(@NonNull FlutterAdLoader adLoader) {
      this.adLoader = adLoader;
      return this;
    }

    FlutterAdLoaderAd build() {
      if (manager == null) {
        throw new IllegalStateException("manager must be provided");
      }

      if (adUnitId == null) {
        throw new IllegalStateException("adUnitId must be provided");
      }

      if (request == null && adManagerRequest == null) {
        throw new IllegalStateException("Either request or adManagerRequest must be provided");
      }

      final FlutterAdLoaderAd adLoaderAd;

      if (request == null) {
        adLoaderAd = new FlutterAdLoaderAd(id, manager, adUnitId, adManagerRequest, adLoader);
      } else {
        adLoaderAd = new FlutterAdLoaderAd(id, manager, adUnitId, request, adLoader);
      }
      return adLoaderAd;
    }
  }

  enum AdLoaderAdType {
    UNKNOWN,
  }

  protected FlutterAdLoaderAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdLoader adLoader) {
    super(adId);

    this.type = AdLoaderAdType.UNKNOWN;
    this.formatId = null;

    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.adLoader = adLoader;
  }

  protected FlutterAdLoaderAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdManagerAdRequest adManagerRequest,
      @NonNull FlutterAdLoader adLoader) {
    super(adId);

    this.type = AdLoaderAdType.UNKNOWN;
    this.formatId = null;

    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adManagerRequest = adManagerRequest;
    this.adLoader = adLoader;
  }

  @Override
  void load() {
    final AdListener adListener = new FlutterAdLoaderAdListener(adId, manager);
    // Note we delegate loading the ad to FlutterAdLoader mainly for testing purposes.
    // As of 20.0.0 of GMA, mockito is unable to mock AdLoader.
    if (request != null) {
      adLoader.loadAdLoaderAd(adUnitId, adListener, request.asAdRequest(adUnitId));
      return;
    }

    if (adManagerRequest != null) {
      adLoader.loadAdManagerAdLoaderAd(
          adUnitId, adListener, adManagerRequest.asAdManagerAdRequest(adUnitId));
      return;
    }

    Log.e(TAG, "A null or invalid ad request was provided.");
  }

  @Nullable
  AdLoaderAdType getAdLoaderAdType() {
    return type;
  }

  @Nullable
  FlutterAdSize getAdSize() {
    return null;
  }

  @Nullable
  String getFormatId() {
    return formatId;
  }

  @Override
  void dispose() {}
}
