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
