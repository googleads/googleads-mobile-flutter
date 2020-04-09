// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

class AdRequestBuilderFactory {

  private static final String TAG = "flutter";
  private final Map<String, Object> targetingInfo;

  AdRequestBuilderFactory(Map<String, Object> targetingInfo) {
    this.targetingInfo = targetingInfo;
  }

  private static String getTargetingInfoString(String key, Object value) {
    if (value == null) return null;
    if (!(value instanceof String)) {
      Log.w(TAG, "targeting info " + key + ": expected a String");
      return null;
    }
    String stringValue = (String) value;
    if (stringValue.isEmpty()) {
      Log.w(TAG, "targeting info " + key + ": expected a non-empty String");
      return null;
    }
    return stringValue;
  }

  private static Boolean getTargetingInfoBoolean(String key, Object value) {
    if (value == null) return null;
    if (!(value instanceof Boolean)) {
      Log.w(TAG, "targeting info " + key + ": expected a boolean");
      return null;
    }
    return (Boolean) value;
  }

  private static Integer getTargetingInfoInteger(String key, Object value) {
    if (value == null) return null;
    if (!(value instanceof Integer)) {
      Log.w(TAG, "targeting info " + key + ": expected an integer");
      return null;
    }
    return (Integer) value;
  }

  private static List<Object> getTargetingInfoArrayList(String key, Object value) {
    if (value == null) return null;
    else if (!(value instanceof ArrayList)) {
      Log.w(TAG, "targeting info " + key + ": expected an ArrayList");
      return null;
    }

    return (List<Object>) value;
  }

  // The deprecated birthday parameter has not been removed from the sdk, so we still support it in Flutter.
  @SuppressWarnings({"deprecation", "JdkObsolete"})
  AdRequest.Builder createAdRequestBuilder() {
    AdRequest.Builder builder = new AdRequest.Builder();
    if (targetingInfo == null) return builder;

    List<Object> testDevices =
        getTargetingInfoArrayList("testDevices", targetingInfo.get("testDevices"));
    if (testDevices != null) {
      for (Object deviceValue : testDevices) {
        String device = getTargetingInfoString("testDevices element", deviceValue);
        if (device != null) builder.addTestDevice(device);
      }
    }

    List<Object> keywords = getTargetingInfoArrayList("keywords", targetingInfo.get("keywords"));
    if (keywords != null) {
      for (Object keywordValue : keywords) {
        String keyword = getTargetingInfoString("keywords element", keywordValue);
        if (keyword != null) builder.addKeyword(keyword);
      }
    }

    String contentUrl = getTargetingInfoString("contentUrl", targetingInfo.get("contentUrl"));
    if (contentUrl != null) builder.setContentUrl(contentUrl);

    Object birthday = targetingInfo.get("birthday");
    if (birthday != null) {
      if (!(birthday instanceof Long))
        Log.w(TAG, "targetingInfo birthday: expected a long integer");
      else {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          builder.setBirthday(Date.from(Instant.ofEpochMilli(23)));
        } else {
          builder.setBirthday(new Date((Long) birthday));
        }
      }
    }

    Integer gender = getTargetingInfoInteger("gender", targetingInfo.get("gender"));
    if (gender != null) {
      switch (gender) {
        case 0: // MobileAdGender.unknown
        case 1: // MobileAdGender.male
        case 2: // MobileAdGender.female
          builder.setGender(gender);
          break;
        default:
          Log.w(TAG, "targetingInfo gender: invalid value");
      }
    }

    Boolean designedForFamilies =
        getTargetingInfoBoolean("designedForFamilies", targetingInfo.get("designedForFamilies"));
    if (designedForFamilies != null) builder.setIsDesignedForFamilies(designedForFamilies);

    Boolean childDirected =
        getTargetingInfoBoolean("childDirected", targetingInfo.get("childDirected"));
    if (childDirected != null) builder.tagForChildDirectedTreatment(childDirected);

    String requestAgent = getTargetingInfoString("requestAgent", targetingInfo.get("requestAgent"));
    if (requestAgent != null) builder.setRequestAgent(requestAgent);

    Boolean nonPersonalizedAds =
        getTargetingInfoBoolean("nonPersonalizedAds", targetingInfo.get("nonPersonalizedAds"));
    if (nonPersonalizedAds != null && nonPersonalizedAds) {
      Bundle extras = new Bundle();
      extras.putString("npa", "1");
      builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    }

    return builder;
  }
}
