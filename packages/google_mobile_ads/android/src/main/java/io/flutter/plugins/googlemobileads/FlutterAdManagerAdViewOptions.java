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
// limitations under the License.c language governing permissions and
//   limitations under the License.

package io.flutter.plugins.googlemobileads;

import androidx.annotation.Nullable;
import com.google.android.gms.ads.formats.AdManagerAdViewOptions;

/** A wrapper for {@link com.google.android.gms.ads.formats.AdManagerAdViewOptions}. */
class FlutterAdManagerAdViewOptions {

  @Nullable final Boolean manualImpressionsEnabled;

  FlutterAdManagerAdViewOptions(@Nullable Boolean manualImpressionsEnabled) {
    this.manualImpressionsEnabled = manualImpressionsEnabled;
  }

  AdManagerAdViewOptions asAdManagerAdViewOptions() {
    AdManagerAdViewOptions.Builder builder = new AdManagerAdViewOptions.Builder();
    if (manualImpressionsEnabled != null) {
      builder.setManualImpressionsEnabled(manualImpressionsEnabled);
    }
    return builder.build();
  }
}
