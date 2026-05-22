// Copyright 2026 Google LLC
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

import android.content.Context;
import io.flutter.plugin.common.MethodChannel.Result;

public final class FlutterAdInspector {
  public static void openAdInspector(
      Context context, FlutterMobileAdsWrapper flutterMobileAds, Result result) {
    flutterMobileAds.openAdInspector(
        context,
        adInspectorError -> {
          if (adInspectorError != null) {
            String errorCode = Integer.toString(adInspectorError.getCode().getValue());
            result.error(
                errorCode,
                adInspectorError.getMessage(),
                "com.google.android.libraries.ads.mobile.sdk");
          } else {
            result.success(null);
          }
        });
  }
}
