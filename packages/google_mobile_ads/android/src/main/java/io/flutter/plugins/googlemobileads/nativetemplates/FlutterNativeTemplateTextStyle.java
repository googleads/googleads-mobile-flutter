package io.flutter.plugins.googlemobileads.nativetemplates;

import android.graphics.drawable.ColorDrawable;
import androidx.annotation.Nullable;

public class FlutterNativeTemplateTextStyle {

  @Nullable private final ColorDrawable textColor;
  @Nullable private final ColorDrawable backgroundColor;
  @Nullable private final FlutterNativeTemplateFontStyle fontStyle;
  @Nullable private final Float size;

  public FlutterNativeTemplateTextStyle(
      @Nullable ColorDrawable textColor,
      @Nullable ColorDrawable backgroundColor,
      @Nullable FlutterNativeTemplateFontStyle fontStyle,
      @Nullable Float size) {
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
    return size;
  }
}
