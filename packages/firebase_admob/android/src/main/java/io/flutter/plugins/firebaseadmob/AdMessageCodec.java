package io.flutter.plugins.firebaseadmob;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

  @Override
  protected void writeValue(ByteArrayOutputStream stream, Object value) {
    if (value instanceof FlutterBannerAd.FlutterAdSize) {
      stream.write(VALUE_AD_SIZE);
      final FlutterBannerAd.FlutterAdSize size = (FlutterBannerAd.FlutterAdSize) value;
      writeValue(stream, size.width);
      writeValue(stream, size.height);
    } else if (value instanceof FlutterAdRequest) {
      stream.write(VALUE_AD_REQUEST);
      final FlutterAdRequest request = (FlutterAdRequest) value;
      writeValue(stream, request.keywords);
      writeValue(stream, request.contentUrl);
      writeValue(stream, request.birthday);
      writeValue(stream, request.gender);
      writeValue(stream, request.designedForFamilies);
      writeValue(stream, request.childDirected);
      writeValue(stream, request.testDevices);
      writeValue(stream, request.nonPersonalizedAds);
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
    } else {
      super.writeValue(stream, value);
    }
  }

  @Override
  protected Object readValueOfType(byte type, ByteBuffer buffer) {
    switch (type) {
      case VALUE_AD_SIZE:
        return new FlutterBannerAd.FlutterAdSize(
            (Integer) readValueOfType(buffer.get(), buffer),
            (Integer) readValueOfType(buffer.get(), buffer));
      case VALUE_AD_REQUEST:
        return new FlutterAdRequest(
            convertToListOfStrings((List<Object>) readValueOfType(buffer.get(), buffer)),
            (String) readValueOfType(buffer.get(), buffer),
            (Date) readValueOfType(buffer.get(), buffer),
            (FlutterAdRequest.MobileAdGender) readValueOfType(buffer.get(), buffer),
            booleanValueOf(readValueOfType(buffer.get(), buffer)),
            booleanValueOf(readValueOfType(buffer.get(), buffer)),
            convertToListOfStrings((List<Object>) readValueOfType(buffer.get(), buffer)),
            booleanValueOf(readValueOfType(buffer.get(), buffer)));
      case VALUE_DATE_TIME:
        return new Date((Long) readValueOfType(buffer.get(), buffer));
      case VALUE_MOBILE_AD_GENDER:
        return FlutterAdRequest.MobileAdGender.values()[
            (Integer) readValueOfType(buffer.get(), buffer)];
      case VALUE_REWARD_ITEM:
        return new FlutterRewardedAd.FlutterRewardItem(
            (Integer) readValueOfType(buffer.get(), buffer),
            (String) readValueOfType(buffer.get(), buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  @Nullable
  private Boolean booleanValueOf(@Nullable Object object) {
    if (object == null) return null;
    return (Boolean) object;
  }

  private List<String> convertToListOfStrings(List<Object> source) {
    if (source == null) {
      return new ArrayList<>();
    }

    final List<String> newList = new ArrayList<>(source.size());
    for (final Object value : source) {
      newList.add(convertToString(value));
    }

    return newList;
  }

  private String convertToString(Object source) {
    if (source instanceof String) {
      return (String) source;
    }

    final String sourceType = source.getClass().getCanonicalName();
    final String message = "java.util.List was expected, unable to convert '%s' to a string.";
    throw new IllegalArgumentException(String.format(message, sourceType));
  }
}
