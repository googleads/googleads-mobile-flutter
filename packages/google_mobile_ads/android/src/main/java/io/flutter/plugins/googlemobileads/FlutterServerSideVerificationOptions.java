package io.flutter.plugins.googlemobileads;

import androidx.annotation.Nullable;
import com.google.android.gms.ads.rewarded.ServerSideVerificationOptions;

class FlutterServerSideVerificationOptions {

  @Nullable private final String userId;
  @Nullable private final String customData;

  public FlutterServerSideVerificationOptions(
      @Nullable String userId, @Nullable String customData) {
    this.userId = userId;
    this.customData = customData;
  }

  @Nullable
  public String getUserId() {
    return userId;
  }

  @Nullable
  public String getCustomData() {
    return customData;
  }

  public ServerSideVerificationOptions asServerSideVerificationOptions() {
    ServerSideVerificationOptions.Builder builder = new ServerSideVerificationOptions.Builder();
    if (userId != null) {
      builder.setUserId(userId);
    }
    if (customData != null) {
      builder.setCustomData(customData);
    }
    return builder.build();
  }
}
