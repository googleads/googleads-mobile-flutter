package com.example.mediationexample;

import android.content.Context;
import android.util.Log;
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
        Log.w(TAG, "Unexpected method call: " + call.method);
    }
  }
}
