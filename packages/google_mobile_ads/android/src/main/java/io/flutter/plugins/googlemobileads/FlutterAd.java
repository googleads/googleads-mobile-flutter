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
import com.google.android.gms.ads.LoadAdError;

abstract class FlutterAd {
  /** A {@link FlutterAd} that is overlaid on top of a running application. */
  abstract static class FlutterOverlayAd extends FlutterAd {
    abstract void show();
  }

  static class FlutterLoadAdError {
    final int code;
    @NonNull final String domain;
    @NonNull final String message;

    FlutterLoadAdError(@NonNull LoadAdError error) {
      code = error.getCode();
      domain = error.getDomain();
      message = error.getMessage();
    }

    FlutterLoadAdError(int code, @NonNull String domain, @NonNull String message) {
      this.code = code;
      this.domain = domain;
      this.message = message;
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
      }
      return message.equals(that.message);
    }

    @Override
    public int hashCode() {
      int result = code;
      result = 31 * result + domain.hashCode();
      result = 31 * result + message.hashCode();
      return result;
    }
  }

  abstract void load();
}
