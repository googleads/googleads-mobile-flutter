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

package io.flutter.plugins.googlemobileads;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;

import android.content.Context;
import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdSize;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.Before;
import org.junit.Test;

public class AdMessageCodecTest {
  static class TestMessageCodec extends AdMessageCodec {
    TestMessageCodec(@NonNull Context context, @NonNull FlutterAdSize.AdSizeFactory adSizeFactory) {
      super(context, adSizeFactory);
    }

    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      if (type == VALUE_ANCHORED_ADAPTIVE_BANNER_AD_SIZE) {
        final String orientation = (String) readValueOfType(buffer.get(), buffer);
        final Integer width = (Integer) readValueOfType(buffer.get(), buffer);
        @SuppressWarnings("unused")
        // Unused to create a new instance when reading the value from Dart.
        // This is for the purpose of testing the writer.
        final Integer height = (Integer) readValueOfType(buffer.get(), buffer);
        return new FlutterAdSize.AnchoredAdaptiveBannerAdSize(
            context, adSizeFactory, orientation, width);
      } else {
        return super.readValueOfType(type, buffer);
      }
    }
  }

  TestMessageCodec testCodec;
  AdSize mockAdSize;
  FlutterAdSize.AdSizeFactory testAdFactory;

  @Before
  public void setup() {
    mockAdSize = mock(AdSize.class);
    testAdFactory =
        new FlutterAdSize.AdSizeFactory() {
          @Override
          AdSize getPortraitAnchoredAdaptiveBannerAdSize(Context context, int width) {
            return mockAdSize;
          }
        };
    testCodec = new TestMessageCodec(null, testAdFactory);
  }

  @Test
  public void adMessageCodec_encodeAdapterInitializationState() {
    final ByteBuffer message =
        testCodec.encodeMessage(FlutterAdapterStatus.AdapterInitializationState.NOT_READY);

    assertEquals(
        testCodec.decodeMessage((ByteBuffer) message.position(0)),
        FlutterAdapterStatus.AdapterInitializationState.NOT_READY);
  }

  @Test
  public void adMessageCodec_encodeAdapterStatus() {
    final ByteBuffer message =
        testCodec.encodeMessage(
            new FlutterAdapterStatus(
                FlutterAdapterStatus.AdapterInitializationState.READY, "desc", 24));

    final FlutterAdapterStatus result =
        (FlutterAdapterStatus) testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(
        result,
        new FlutterAdapterStatus(
            FlutterAdapterStatus.AdapterInitializationState.READY, "desc", 24));
  }

  @Test
  public void adMessageCodec_encodeInitializationStatus() {
    final ByteBuffer message =
        testCodec.encodeMessage(
            new FlutterInitializationStatus(
                Collections.singletonMap(
                    "table",
                    new FlutterAdapterStatus(
                        FlutterAdapterStatus.AdapterInitializationState.NOT_READY,
                        "desc",
                        56.66))));

    final FlutterInitializationStatus initStatus =
        (FlutterInitializationStatus) testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(initStatus.adapterStatuses.size(), 1);
    final FlutterAdapterStatus adapterStatus = initStatus.adapterStatuses.get("table");
    assertEquals(
        adapterStatus,
        new FlutterAdapterStatus(
            FlutterAdapterStatus.AdapterInitializationState.NOT_READY, "desc", 56.66));
  }

  @Test
  public void adMessageCodec_decodeInitializationStatus() {
    Map<String, String> targeting = new HashMap<>();
    targeting.put("testKey", "testValue");

    Map<String, List<String>> targetingList = new HashMap<>();
    List<String> list = new ArrayList<>();
    list.add("testValue1");
    list.add("testValue2");
    targetingList.put("testKey", list);

    FlutterPublisherAdRequest flutterPublisherAdRequest =
        new FlutterPublisherAdRequest.Builder()
            .setContentUrl("test-content-url")
            .setCustomTargeting(targeting)
            .setCustomTargetingLists(targetingList)
            .setKeywords(list)
            .setNonPersonalizedAds(true)
            .build();

    ByteBuffer message = testCodec.encodeMessage(flutterPublisherAdRequest);

    FlutterPublisherAdRequest decodedPublisherAdRequest =
        (FlutterPublisherAdRequest) testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedPublisherAdRequest, flutterPublisherAdRequest);
  }

  @Test
  public void adMessageCodec_decodeServerSideVerificationOptions() {
    FlutterServerSideVerificationOptions options =
        new FlutterServerSideVerificationOptions("user-id", "custom-data");

    ByteBuffer message = testCodec.encodeMessage(options);

    FlutterServerSideVerificationOptions decodedOptions =
        (FlutterServerSideVerificationOptions)
            testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);

    // With userId = null.
    options = new FlutterServerSideVerificationOptions(null, "custom-data");
    message = testCodec.encodeMessage(options);
    decodedOptions =
        (FlutterServerSideVerificationOptions)
            testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);

    // With customData = null.
    options = new FlutterServerSideVerificationOptions("user-Id", null);
    message = testCodec.encodeMessage(options);
    decodedOptions =
        (FlutterServerSideVerificationOptions)
            testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);

    // With userId and customData = null.
    options = new FlutterServerSideVerificationOptions(null, null);
    message = testCodec.encodeMessage(options);
    decodedOptions =
        (FlutterServerSideVerificationOptions)
            testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);
  }

  @Test
  public void adMessageCodec_encodeAnchoredAdaptiveBannerAdSize() {
    final FlutterAdSize.AnchoredAdaptiveBannerAdSize adaptiveAdSize =
        new FlutterAdSize.AnchoredAdaptiveBannerAdSize(null, testAdFactory, "portrait", 23);
    final ByteBuffer data = testCodec.encodeMessage(adaptiveAdSize);

    final FlutterAdSize.AnchoredAdaptiveBannerAdSize result =
        (FlutterAdSize.AnchoredAdaptiveBannerAdSize)
            testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, mockAdSize);
  }

  @Test
  public void adMessageCodec_encodeSmartBannerAdSize() {
    final ByteBuffer data = testCodec.encodeMessage(new FlutterAdSize.SmartBannerAdSize());

    final FlutterAdSize.SmartBannerAdSize result =
        (FlutterAdSize.SmartBannerAdSize) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, AdSize.SMART_BANNER);
  }
}
