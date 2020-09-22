// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdSize;

class FlutterAdSize {
  @NonNull final AdSize size;
  final int width;
  final int height;

  FlutterAdSize(int width, int height) {
    this.width = width;
    this.height = height;

    // These values must remain consistent with `AdSize.smartBanner` in Dart.
    if (width == -1 && height == -1) {
      this.size = AdSize.SMART_BANNER;
    } else {
      this.size = new AdSize(width, height);
    }
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof FlutterAdSize)) return false;

    final FlutterAdSize that = (FlutterAdSize) o;

    if (width != that.width) return false;
    return height == that.height;
  }

  @Override
  public int hashCode() {
    int result = width;
    result = 31 * result + height;
    return result;
  }
}
