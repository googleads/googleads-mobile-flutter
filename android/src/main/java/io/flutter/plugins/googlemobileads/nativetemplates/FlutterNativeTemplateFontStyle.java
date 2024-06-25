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

import android.graphics.Typeface;
import android.util.Log;

public enum FlutterNativeTemplateFontStyle {
  NORMAL,
  BOLD,
  ITALIC,
  MONOSPACE;

  public static FlutterNativeTemplateFontStyle fromIntValue(int value) {
    if (value >= 0 && value < FlutterNativeTemplateFontStyle.values().length) {
      return FlutterNativeTemplateFontStyle.values()[value];
    }
    Log.w("NativeTemplateFontStyle", "Invalid index for NativeTemplateFontStyle: " + value);
    return NORMAL;
  }

  Typeface getTypeface() {
    switch (this) {
      case NORMAL:
        return Typeface.DEFAULT;
      case BOLD:
        return Typeface.DEFAULT_BOLD;
      case ITALIC:
        return Typeface.defaultFromStyle(Typeface.ITALIC);
      case MONOSPACE:
        return Typeface.MONOSPACE;
    }
    return Typeface.DEFAULT;
  }
}
