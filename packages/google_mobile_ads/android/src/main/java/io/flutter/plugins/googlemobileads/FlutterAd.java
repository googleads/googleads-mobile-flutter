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
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;
import java.util.Objects;

abstract class FlutterAd {
  /** A {@link FlutterAd} that is overlaid on top of a running application. */
  abstract static class FlutterOverlayAd extends FlutterAd {
    abstract void show();
  }

  /** A wrapper around {@link ResponseInfo}. */
  static class FlutterResponseInfo {

    @Nullable private final String responseId;
    @Nullable private final String mediationAdapterClassName;

    FlutterResponseInfo(@Nullable String responseId, @Nullable String mediationAdapterClassName) {
      this.responseId = responseId;
      this.mediationAdapterClassName = mediationAdapterClassName;
    }

    @Nullable
    String getResponseId() {
      return responseId;
    }

    @Nullable
    String getMediationAdapterClassName() {
      return mediationAdapterClassName;
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
        && Objects.equals(mediationAdapterClassName, that.mediationAdapterClassName);
    }

    @Override
    public int hashCode() {
      return Objects.hash(responseId, mediationAdapterClassName);
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
        responseInfo = new FlutterResponseInfo(
            error.getResponseInfo().getResponseId(),
            error.getResponseInfo().getMediationAdapterClassName());
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
}
