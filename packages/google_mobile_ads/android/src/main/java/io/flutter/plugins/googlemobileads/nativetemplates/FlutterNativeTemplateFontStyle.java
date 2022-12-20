package io.flutter.plugins.googlemobileads.nativetemplates;

import android.graphics.Typeface;
import android.util.Log;

public enum FlutterNativeTemplateFontStyle {
  NORMAL(Typeface.DEFAULT),
  BOLD(Typeface.DEFAULT_BOLD),
  ITALIC(Typeface.defaultFromStyle(Typeface.ITALIC)),
  MONOSPACE(Typeface.MONOSPACE);

  private final Typeface typeface;

  FlutterNativeTemplateFontStyle(Typeface typeface) {
    this.typeface = typeface;
  }

  public static FlutterNativeTemplateFontStyle fromIntValue(int value) {
    if (value >= 0 && value < FlutterNativeTemplateFontStyle.values().length) {
      return FlutterNativeTemplateFontStyle.values()[value];
    }
    Log.w("NativeTemplateFontStyle", "Invalid index for NativeTemplateFontStyle: " + value);
    return NORMAL;
  }

  Typeface getTypeface() {
    return typeface;
  }
}
