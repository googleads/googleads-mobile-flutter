package io.flutter.plugins.googlemobileads;

import android.text.TextUtils;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.rewarded.ServerSideVerificationOptions;
import java.util.Objects;

/** A wrapper for {@link ServerSideVerificationOptions}. */
class FlutterServerSideVerificationOptions {

  private final String userId;
  private final String customData;

  public FlutterServerSideVerificationOptions(
      @Nullable String userId, @Nullable String customData) {
    this.userId = TextUtils.isEmpty(userId) ? "" : userId;
    this.customData = TextUtils.isEmpty(customData) ? "" : customData;
  }

  public String getUserId() {
    return userId;
  }

  public String getCustomData() {
    return customData;
  }

  /** Gets an equivalent {@link ServerSideVerificationOptions}. */
  public ServerSideVerificationOptions asServerSideVerificationOptions() {
    return new ServerSideVerificationOptions(userId, customData);
  }

  @Override
  public boolean equals(@Nullable Object obj) {
    if (this == obj) {
      return true;
    }
    if (!(obj instanceof FlutterServerSideVerificationOptions)) {
      return false;
    }
    FlutterServerSideVerificationOptions other = (FlutterServerSideVerificationOptions) obj;
    return Objects.equals(other.userId, userId) && Objects.equals(other.customData, customData);
  }

  @Override
  public int hashCode() {
    return Objects.hash(userId, customData);
  }
}
