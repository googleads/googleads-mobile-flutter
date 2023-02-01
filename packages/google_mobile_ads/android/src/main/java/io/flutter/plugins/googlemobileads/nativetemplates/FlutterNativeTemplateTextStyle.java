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

import android.graphics.drawable.ColorDrawable;
import androidx.annotation.Nullable;
import java.util.Objects;

public final class FlutterNativeTemplateTextStyle {

  @Nullable private final ColorDrawable textColor;
  @Nullable private final ColorDrawable backgroundColor;
  @Nullable private final FlutterNativeTemplateFontStyle fontStyle;
  @Nullable private final Double size;

  public FlutterNativeTemplateTextStyle(
      @Nullable ColorDrawable textColor,
      @Nullable ColorDrawable backgroundColor,
      @Nullable FlutterNativeTemplateFontStyle fontStyle,
      @Nullable Double size) {
    this.textColor = textColor;
    this.backgroundColor = backgroundColor;
    this.fontStyle = fontStyle;
    this.size = size;
  }

  @Nullable
  public ColorDrawable getTextColor() {
    return textColor;
  }

  @Nullable
  public ColorDrawable getBackgroundColor() {
    return backgroundColor;
  }

  @Nullable
  public FlutterNativeTemplateFontStyle getFontStyle() {
    return fontStyle;
  }

  @Nullable
  public Float getSize() {
    return size == null ? null : size.floatValue();
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterNativeTemplateTextStyle)) {
      return false;
    }

    FlutterNativeTemplateTextStyle other = (FlutterNativeTemplateTextStyle) o;
    return ((textColor == null && other.textColor == null)
            || textColor.getColor() == other.textColor.getColor())
        && ((backgroundColor == null && other.backgroundColor == null)
            || backgroundColor.getColor() == other.backgroundColor.getColor())
        && Objects.equals(size, other.size)
        && Objects.equals(fontStyle, other.fontStyle);
  }

  @Override
  public int hashCode() {
    Integer textColorValue = textColor == null ? null : textColor.getColor();
    Integer backgroundColorValue = backgroundColor == null ? null : backgroundColor.getColor();
    return Objects.hash(textColorValue, backgroundColorValue, size, fontStyle);
  }
}
