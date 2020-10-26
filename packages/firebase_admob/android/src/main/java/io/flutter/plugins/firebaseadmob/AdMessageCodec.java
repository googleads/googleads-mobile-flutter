// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Encodes and decodes values by reading from a ByteBuffer and writing to a ByteArrayOutputStream.
 */
final class AdMessageCodec extends StandardMessageCodec {
  // The type values below must be consistent for each platform.
  private static final byte VALUE_AD_SIZE = (byte) 128;
  private static final byte VALUE_AD_REQUEST = (byte) 129;
  private static final byte VALUE_DATE_TIME = (byte) 130;
  private static final byte VALUE_MOBILE_AD_GENDER = (byte) 131;
  private static final byte VALUE_REWARD_ITEM = (byte) 132;
  private static final byte VALUE_LOAD_AD_ERROR = (byte) 133;
  private static final byte VALUE_PUBLISHER_AD_REQUEST = (byte) 134;
  private static final byte VALUE_INITIALIZATION_STATE = (byte) 135;
  private static final byte VALUE_ADAPTER_STATUS = (byte) 136;
  private static final byte VALUE_INITIALIZATION_STATUS = (byte) 137;

  @Override
  protected void writeValue(ByteArrayOutputStream stream, Object value) {
    if (value instanceof FlutterAdSize) {
      stream.write(VALUE_AD_SIZE);
      final FlutterAdSize size = (FlutterAdSize) value;
      writeValue(stream, size.width);
      writeValue(stream, size.height);
    } else if (value instanceof FlutterAdRequest) {
      stream.write(VALUE_AD_REQUEST);
      final FlutterAdRequest request = (FlutterAdRequest) value;
      writeValue(stream, request.getKeywords());
      writeValue(stream, request.getContentUrl());
      writeValue(stream, request.getBirthday());
      writeValue(stream, request.getGender());
      writeValue(stream, request.getDesignedForFamilies());
      writeValue(stream, request.getChildDirected());
      writeValue(stream, request.getTestDevices());
      writeValue(stream, request.getNonPersonalizedAds());
    } else if (value instanceof Date) {
      stream.write(VALUE_DATE_TIME);
      writeValue(stream, ((Date) value).getTime());
    } else if (value instanceof FlutterAdRequest.MobileAdGender) {
      stream.write(VALUE_MOBILE_AD_GENDER);
      writeValue(stream, ((FlutterAdRequest.MobileAdGender) value).ordinal());
    } else if (value instanceof FlutterRewardedAd.FlutterRewardItem) {
      stream.write(VALUE_REWARD_ITEM);
      final FlutterRewardedAd.FlutterRewardItem item = (FlutterRewardedAd.FlutterRewardItem) value;
      writeValue(stream, item.amount);
      writeValue(stream, item.type);
    } else if (value instanceof FlutterAd.FlutterLoadAdError) {
      stream.write(VALUE_LOAD_AD_ERROR);
      final FlutterAd.FlutterLoadAdError error = (FlutterAd.FlutterLoadAdError) value;
      writeValue(stream, error.code);
      writeValue(stream, error.domain);
      writeValue(stream, error.message);
    } else if (value instanceof FlutterPublisherAdRequest) {
      stream.write(VALUE_PUBLISHER_AD_REQUEST);
      final FlutterPublisherAdRequest request = (FlutterPublisherAdRequest) value;
      writeValue(stream, request.getKeywords());
      writeValue(stream, request.getContentUrl());
      writeValue(stream, request.getCustomTargeting());
      writeValue(stream, request.getCustomTargetingLists());
    } else if (value instanceof FlutterAdapterStatus.AdapterInitializationState) {
      stream.write(VALUE_INITIALIZATION_STATE);
      final FlutterAdapterStatus.AdapterInitializationState state =
          (FlutterAdapterStatus.AdapterInitializationState) value;
      switch (state) {
        case NOT_READY:
          writeValue(stream, "notReady");
          return;
        case READY:
          writeValue(stream, "ready");
          return;
      }
      final String message = String.format("Unable to handle state: %s", state);
      throw new IllegalArgumentException(message);
    } else if (value instanceof FlutterAdapterStatus) {
      stream.write(VALUE_ADAPTER_STATUS);
      final FlutterAdapterStatus status = (FlutterAdapterStatus) value;
      writeValue(stream, status.state);
      writeValue(stream, status.description);
      writeValue(stream, status.latency);
    } else if (value instanceof FlutterInitializationStatus) {
      stream.write(VALUE_INITIALIZATION_STATUS);
      final FlutterInitializationStatus status = (FlutterInitializationStatus) value;
      writeValue(stream, status.adapterStatuses);
    } else {
      super.writeValue(stream, value);
    }
  }

  @Override
  protected Object readValueOfType(byte type, ByteBuffer buffer) {
    switch (type) {
      case VALUE_AD_SIZE:
        return new FlutterAdSize(
            (Integer) readValueOfType(buffer.get(), buffer),
            (Integer) readValueOfType(buffer.get(), buffer));
      case VALUE_AD_REQUEST:
        return new FlutterAdRequest.Builder()
            .setKeywords((List<String>) readValueOfType(buffer.get(), buffer))
            .setContentUrl((String) readValueOfType(buffer.get(), buffer))
            .setBirthday((Date) readValueOfType(buffer.get(), buffer))
            .setGender((FlutterAdRequest.MobileAdGender) readValueOfType(buffer.get(), buffer))
            .setDesignedForFamilies(booleanValueOf(readValueOfType(buffer.get(), buffer)))
            .setChildDirected(booleanValueOf(readValueOfType(buffer.get(), buffer)))
            .setTestDevices((List<String>) readValueOfType(buffer.get(), buffer))
            .setNonPersonalizedAds(booleanValueOf(readValueOfType(buffer.get(), buffer)))
            .build();
      case VALUE_DATE_TIME:
        return new Date((Long) readValueOfType(buffer.get(), buffer));
      case VALUE_MOBILE_AD_GENDER:
        return FlutterAdRequest.MobileAdGender.values()[
            (Integer) readValueOfType(buffer.get(), buffer)];
      case VALUE_REWARD_ITEM:
        return new FlutterRewardedAd.FlutterRewardItem(
            (Integer) readValueOfType(buffer.get(), buffer),
            (String) readValueOfType(buffer.get(), buffer));
      case VALUE_LOAD_AD_ERROR:
        return new FlutterAd.FlutterLoadAdError(
            (Integer) readValueOfType(buffer.get(), buffer),
            (String) readValueOfType(buffer.get(), buffer),
            (String) readValueOfType(buffer.get(), buffer));
      case VALUE_PUBLISHER_AD_REQUEST:
        return new FlutterPublisherAdRequest.Builder()
            .setKeywords((List<String>) readValueOfType(buffer.get(), buffer))
            .setContentUrl((String) readValueOfType(buffer.get(), buffer))
            .setCustomTargeting((Map<String, String>) readValueOfType(buffer.get(), buffer))
            .setCustomTargetingLists(
                (Map<String, List<String>>) readValueOfType(buffer.get(), buffer))
            .build();
      case VALUE_INITIALIZATION_STATE:
        final String state = (String) readValueOfType(buffer.get(), buffer);
        switch (state) {
          case "notReady":
            return FlutterAdapterStatus.AdapterInitializationState.NOT_READY;
          case "ready":
            return FlutterAdapterStatus.AdapterInitializationState.READY;
        }
        final String message = String.format("Unable to handle state: %s", state);
        throw new IllegalArgumentException(message);
      case VALUE_ADAPTER_STATUS:
        return new FlutterAdapterStatus(
            (FlutterAdapterStatus.AdapterInitializationState) readValueOfType(buffer.get(), buffer),
            (String) readValueOfType(buffer.get(), buffer),
            (Number) readValueOfType(buffer.get(), buffer));
      case VALUE_INITIALIZATION_STATUS:
        return new FlutterInitializationStatus(
            (Map<String, FlutterAdapterStatus>) readValueOfType(buffer.get(), buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  @Nullable
  private Boolean booleanValueOf(@Nullable Object object) {
    if (object == null) return null;
    return (Boolean) object;
  }
}
