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

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdapterResponseInfo;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;
import io.flutter.plugin.platform.PlatformView;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

abstract class FlutterAd {

  protected final int adId;

  FlutterAd(int adId) {
    this.adId = adId;
  }

  /** A {@link FlutterAd} that is overlaid on top of a running application. */
  abstract static class FlutterOverlayAd extends FlutterAd {
    abstract void show();

    FlutterOverlayAd(int adId) {
      super(adId);
    }
  }

  /** A wrapper around {@link ResponseInfo}. */
  static class FlutterResponseInfo {

    @Nullable private final String responseId;
    @Nullable private final String mediationAdapterClassName;
    @NonNull private final List<FlutterAdapterResponseInfo> adapterResponses;

    FlutterResponseInfo(@NonNull ResponseInfo responseInfo) {
      this.responseId = responseInfo.getResponseId();
      this.mediationAdapterClassName = responseInfo.getMediationAdapterClassName();
      final List<FlutterAdapterResponseInfo> adapterResponseInfos = new ArrayList<>();
      for (AdapterResponseInfo adapterInfo : responseInfo.getAdapterResponses()) {
        adapterResponseInfos.add(new FlutterAdapterResponseInfo(adapterInfo));
      }
      this.adapterResponses = adapterResponseInfos;
    }

    FlutterResponseInfo(
        @Nullable String responseId,
        @Nullable String mediationAdapterClassName,
        @NonNull List<FlutterAdapterResponseInfo> adapterResponseInfos) {
      this.responseId = responseId;
      this.mediationAdapterClassName = mediationAdapterClassName;
      this.adapterResponses = adapterResponseInfos;
    }

    @Nullable
    String getResponseId() {
      return responseId;
    }

    @Nullable
    String getMediationAdapterClassName() {
      return mediationAdapterClassName;
    }

    @NonNull
    List<FlutterAdapterResponseInfo> getAdapterResponses() {
      return adapterResponses;
    }

    @Override
    public boolean equals(@Nullable Object obj) {
      if (obj == this) {
        return true;
      } else if (!(obj instanceof FlutterResponseInfo)) {
        return false;
      }

      FlutterResponseInfo that = (FlutterResponseInfo) obj;
      return Objects.equals(responseId, that.responseId)
          && Objects.equals(mediationAdapterClassName, that.mediationAdapterClassName)
          && Objects.equals(adapterResponses, that.adapterResponses);
    }

    @Override
    public int hashCode() {
      return Objects.hash(responseId, mediationAdapterClassName);
    }
  }

  /** A wrapper for {@link AdapterResponseInfo}. */
  static class FlutterAdapterResponseInfo {

    @NonNull private final String adapterClassName;
    private final long latencyMillis;
    @NonNull private final String description;
    @NonNull private final String credentials;
    @Nullable private FlutterAdError error;

    FlutterAdapterResponseInfo(@NonNull AdapterResponseInfo responseInfo) {
      this.adapterClassName = responseInfo.getAdapterClassName();
      this.latencyMillis = responseInfo.getLatencyMillis();
      this.description = responseInfo.toString();
      if (responseInfo.getCredentials() != null) {
        this.credentials = responseInfo.getCredentials().toString();
      } else {
        credentials = "unknown credentials";
      }
      if (responseInfo.getAdError() != null) {
        this.error = new FlutterAdError(responseInfo.getAdError());
      }
    }

    FlutterAdapterResponseInfo(
        @NonNull String adapterClassName,
        long latencyMillis,
        @NonNull String description,
        @Nullable String credentials,
        @Nullable FlutterAdError error) {
      this.adapterClassName = adapterClassName;
      this.latencyMillis = latencyMillis;
      this.description = description;
      this.credentials = credentials;
      this.error = error;
    }

    @NonNull
    public String getAdapterClassName() {
      return adapterClassName;
    }

    public long getLatencyMillis() {
      return latencyMillis;
    }

    @NonNull
    public String getDescription() {
      return description;
    }

    @NonNull
    public String getCredentials() {
      return credentials;
    }

    @Nullable
    public FlutterAdError getError() {
      return error;
    }

    @Override
    public boolean equals(@Nullable Object obj) {
      if (obj == this) {
        return true;
      } else if (!(obj instanceof FlutterAdapterResponseInfo)) {
        return false;
      }

      final FlutterAdapterResponseInfo that = (FlutterAdapterResponseInfo) obj;
      return Objects.equals(adapterClassName, that.adapterClassName)
          && latencyMillis == that.latencyMillis
          && Objects.equals(description, that.description)
          && Objects.equals(credentials, that.credentials)
          && Objects.equals(error, that.error);
    }

    @Override
    public int hashCode() {
      return Objects.hash(adapterClassName, latencyMillis, description, credentials, error);
    }
  }

  /** Wrapper for {@link AdError}. */
  static class FlutterAdError {
    final int code;
    @NonNull final String domain;
    @NonNull final String message;

    FlutterAdError(@NonNull AdError error) {
      code = error.getCode();
      domain = error.getDomain();
      message = error.getMessage();
    }

    FlutterAdError(int code, @NonNull String domain, @NonNull String message) {
      this.code = code;
      this.domain = domain;
      this.message = message;
    }

    @Override
    public boolean equals(Object object) {
      if (this == object) {
        return true;
      } else if (!(object instanceof FlutterAdError)) {
        return false;
      }

      final FlutterAdError that = (FlutterAdError) object;

      if (code != that.code) {
        return false;
      } else if (!domain.equals(that.domain)) {
        return false;
      }
      return message.equals(that.message);
    }

    @Override
    public int hashCode() {
      return Objects.hash(code, domain, message);
    }
  }

  /** Wrapper for {@link LoadAdError}. */
  static class FlutterLoadAdError {
    final int code;
    @NonNull final String domain;
    @NonNull final String message;
    @Nullable FlutterResponseInfo responseInfo;

    FlutterLoadAdError(@NonNull LoadAdError error) {
      code = error.getCode();
      domain = error.getDomain();
      message = error.getMessage();

      if (error.getResponseInfo() != null) {
        responseInfo = new FlutterResponseInfo(error.getResponseInfo());
      }
    }

    FlutterLoadAdError(
        int code,
        @NonNull String domain,
        @NonNull String message,
        @Nullable FlutterResponseInfo responseInfo) {
      this.code = code;
      this.domain = domain;
      this.message = message;
      this.responseInfo = responseInfo;
    }

    @Override
    public boolean equals(Object object) {
      if (this == object) {
        return true;
      } else if (!(object instanceof FlutterLoadAdError)) {
        return false;
      }

      final FlutterLoadAdError that = (FlutterLoadAdError) object;

      if (code != that.code) {
        return false;
      } else if (!domain.equals(that.domain)) {
        return false;
      } else if (!Objects.equals(responseInfo, that.responseInfo)) {
        return false;
      }
      return message.equals(that.message);
    }

    @Override
    public int hashCode() {
      return Objects.hash(code, domain, message, responseInfo);
    }
  }

  abstract void load();

  /**
   * Gets the PlatformView for the ad. Default behavior is to return null. Should be overridden by
   * ads with platform views, such as banner and native ads.
   */
  @Nullable
  PlatformView getPlatformView() {
    return null;
  };

  /**
   * Invoked when dispose() is called on the corresponding Flutter ad object. This perform any
   * necessary cleanup.
   */
  abstract void dispose();
}
