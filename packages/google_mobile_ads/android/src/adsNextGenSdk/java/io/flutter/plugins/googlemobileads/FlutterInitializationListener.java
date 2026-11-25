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

import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationStatus;
import com.google.android.libraries.ads.mobile.sdk.initialization.OnAdapterInitializationCompleteListener;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * An {@link OnAdapterInitializationCompleteListener} that invokes result.success() at most once.
 */
public final class FlutterInitializationListener
    implements OnAdapterInitializationCompleteListener {

  private final Result result;
  private final AtomicBoolean isInitializationCompleted = new AtomicBoolean(false);
  private final Handler mainHandler = new Handler(Looper.getMainLooper());

  FlutterInitializationListener(@NonNull final Result result) {
    this.result = result;
  }

  @Override
  public void onAdapterInitializationComplete(@NonNull InitializationStatus initializationStatus) {
    // Make sure not to invoke this more than once, since Dart will throw an exception if success
    // is invoked more than once. See b/193418432.
    if (!isInitializationCompleted.compareAndSet(false, true)) {
      return;
    }
    FlutterInitializationStatus status = new FlutterInitializationStatus(initializationStatus);
    mainHandler.post(() -> result.success(status));
  }

  void onInitializationFailed(@NonNull String errorCode, @Nullable String errorMessage) {
    if (!isInitializationCompleted.compareAndSet(false, true)) {
      return;
    }
    mainHandler.post(() -> result.error(errorCode, errorMessage, null));
  }
}
