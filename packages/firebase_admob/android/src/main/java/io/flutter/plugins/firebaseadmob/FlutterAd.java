// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

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
