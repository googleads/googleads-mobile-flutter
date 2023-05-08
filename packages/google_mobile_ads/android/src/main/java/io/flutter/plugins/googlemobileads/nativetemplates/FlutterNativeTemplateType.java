// Copyright 2023 Google LLC
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

package io.flutter.plugins.googlemobileads.nativetemplates;

import android.util.Log;
import io.flutter.plugins.googlemobileads.R;

public enum FlutterNativeTemplateType {
  SMALL(R.layout.small_template_view_layout),
  MEDIUM(R.layout.medium_template_view_layout);

  private final int resourceId;

  FlutterNativeTemplateType(int resourceId) {
    this.resourceId = resourceId;
  }

  public int resourceId() {
    return resourceId;
  }

  public static FlutterNativeTemplateType fromIntValue(int value) {
    if (value >= 0 && value < FlutterNativeTemplateType.values().length) {
      return FlutterNativeTemplateType.values()[value];
    }
    Log.w("NativeTemplateType", "Invalid template type index: " + value);
    return MEDIUM;
  }
}
