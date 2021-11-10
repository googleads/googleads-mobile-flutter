// Copyright 2021 Google LLC
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

package com.example.mediationexample;

import android.content.Context;
import androidx.annotation.NonNull;
import com.applovin.sdk.AppLovinPrivacySettings;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** A {@link MethodCallHandler} that calls static APIs in the AppLovin SDK. */
final class MyMediationMethodCallHandler implements MethodCallHandler {

  private static final String TAG = "MethodCallHandler";
  private final Context context;

  MyMediationMethodCallHandler(Context context) {
    this.context = context;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "setIsAgeRestrictedUser":
        AppLovinPrivacySettings.setIsAgeRestrictedUser(call.argument("isAgeRestricted"), context);
        result.success(null);
        break;
      case "setHasUserConsent":
        AppLovinPrivacySettings.setHasUserConsent(call.argument("hasUserConsent"), context);
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
