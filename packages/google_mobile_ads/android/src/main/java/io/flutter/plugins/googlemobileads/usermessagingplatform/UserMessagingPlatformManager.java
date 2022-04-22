// Copyright 2022 Google LLC
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

package io.flutter.plugins.googlemobileads.usermessagingplatform;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.ump.ConsentForm;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentRequestParameters;
import com.google.android.ump.FormError;
import com.google.android.ump.UserMessagingPlatform;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMethodCodec;

/** Manages platform code for UMP SDK. */
public class UserMessagingPlatformManager implements MethodCallHandler {

  private static final String METHOD_CHANNEL_NAME = "plugins.flutter.io/google_mobile_ads/ump";

  private final UserMessagingCodec userMessagingCodec;
  private final MethodChannel methodChannel;
  private Context context;

  @Nullable private Activity activity;

  public UserMessagingPlatformManager(BinaryMessenger binaryMessenger, Context context) {
    userMessagingCodec = new UserMessagingCodec(context);
    methodChannel =
        new MethodChannel(
            binaryMessenger, METHOD_CHANNEL_NAME, new StandardMethodCodec(userMessagingCodec));
    methodChannel.setMethodCallHandler(this);
    this.context = context;
  }

  public void setActivity(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "ConsentInformation#reset":
        {
          ConsentInformation consentInformation = call.argument("consentInformation");
          if (consentInformation == null) {
            // TODO = update the errors
            result.error("2", "Unable to find ConsentInfo in ConsentInfo#reset", null);
          } else {
            consentInformation.reset();
            result.success(null);
          }
          break;
        }
      case "ConsentInformation#getConsentStatus":
        {
          ConsentInformation consentInformation = call.argument("consentInformation");
          if (consentInformation == null) {
            // TODO = update the errors
            result.error("2", "Unable to find ConsentInfo in ConsentInfo#reset", null);
          } else {
            result.success(consentInformation.getConsentStatus());
          }
          break;
        }
      case "UserMessagingPlatform#getConsentInformation":
        {
          ConsentInformation consentInformation =
              UserMessagingPlatform.getConsentInformation(context);
          result.success(consentInformation);
          break;
        }
      case "ConsentInfo#requestConsentInfoUpdate":
        {
          ConsentRequestParameters consentRequestParameters = call.argument("params");
          ConsentInformation consentInformation = call.argument("contentInformation");
          if (activity == null) {
            // TODO - update error codes
            result.error(
                "1",
                "ConsentInfo#requestConsentInfoUpdate called before plugin has been registered to an activity.",
                null);
            break;
          }
          if (consentInformation == null) {
            result.error(
                "2", "Unable to find ConsentInfo in ConsentInfo#requestConsentInfoUpdate", null);
            break;
          }
          consentInformation.requestConsentInfoUpdate(
              activity,
              consentRequestParameters,
              () -> {
                result.success(null);
              },
              (FormError error) -> {
                result.error(Integer.toString(error.getErrorCode()), error.getMessage(), null);
              });
          break;
        }
      case "UserMessagingPlatform#loadConsentForm":
        UserMessagingPlatform.loadConsentForm(
            context,
            result::success,
            (FormError formError) -> {
              result.error(
                  Integer.toString(formError.getErrorCode()), formError.getMessage(), null);
            });
        break;
      case "ConsentInfo#isConsentFormAvailable":
        {
          ConsentInformation consentInformation = call.argument("consentInformation");
          if (consentInformation == null) {
            result.error(
                "2", "Unable to find ConsentInfo in ConsentInfo#requestConsentInfoUpdate", null);
          } else {
            result.success(consentInformation.isConsentFormAvailable());
          }
          break;
        }
      case "ConsentForm#show":
        {
          ConsentForm consentForm = call.argument("consentForm");
          if (consentForm == null) {
            // TODO - update these error codes
            result.error(
                "2", "Unable to find ConsentInfo in ConsentInfo#requestConsentInfoUpdate", null);
          } else {
            consentForm.show(activity, (result::success));
          }
          break;
        }
      default:
        result.notImplemented();
    }
  }
}
