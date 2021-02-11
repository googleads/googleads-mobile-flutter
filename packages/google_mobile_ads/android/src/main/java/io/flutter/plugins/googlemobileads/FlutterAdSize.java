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
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterAdSize)) {
      return false;
    }

    final FlutterAdSize that = (FlutterAdSize) o;

    if (width != that.width) {
      return false;
    }
    return height == that.height;
  }

  @Override
  public int hashCode() {
    int result = width;
    result = 31 * result + height;
    return result;
  }
}
