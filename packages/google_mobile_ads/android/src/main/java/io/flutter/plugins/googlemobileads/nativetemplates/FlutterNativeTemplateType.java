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
