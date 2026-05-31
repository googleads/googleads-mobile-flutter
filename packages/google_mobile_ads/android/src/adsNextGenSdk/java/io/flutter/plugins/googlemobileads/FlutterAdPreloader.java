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

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class FlutterAdPreloader {

  FlutterAdPreloader(@NonNull Context context, @NonNull AdInstanceManager instanceManager, @NonNull MethodChannel channel) {
    // Stub implementation for adsNextGenSdk
  }

  void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    result.notImplemented();
  }
}
