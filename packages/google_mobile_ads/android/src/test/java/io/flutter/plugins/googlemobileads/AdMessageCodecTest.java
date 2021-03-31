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

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.Test;

public class AdMessageCodecTest {

  @Test
  public void adMessageCodec_encodeAdapterInitializationState() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(FlutterAdapterStatus.AdapterInitializationState.NOT_READY);

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        FlutterAdapterStatus.AdapterInitializationState.NOT_READY);
  }

  @Test
  public void adMessageCodec_encodeAdapterStatus() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterAdapterStatus(
                FlutterAdapterStatus.AdapterInitializationState.READY, "desc", 24));

    final FlutterAdapterStatus result =
        (FlutterAdapterStatus) codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(
        result,
        new FlutterAdapterStatus(
            FlutterAdapterStatus.AdapterInitializationState.READY, "desc", 24));
  }

  @Test
  public void adMessageCodec_encodeInitializationStatus() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterInitializationStatus(
                Collections.singletonMap(
                    "table",
                    new FlutterAdapterStatus(
                        FlutterAdapterStatus.AdapterInitializationState.NOT_READY,
                        "desc",
                        56.66))));

    final FlutterInitializationStatus initStatus =
        (FlutterInitializationStatus) codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(initStatus.adapterStatuses.size(), 1);
    final FlutterAdapterStatus adapterStatus = initStatus.adapterStatuses.get("table");
    assertEquals(
        adapterStatus,
        new FlutterAdapterStatus(
            FlutterAdapterStatus.AdapterInitializationState.NOT_READY, "desc", 56.66));
  }

  @Test
  public void adMessageCodec_decodeInitializationStatus() {
    AdMessageCodec codec = new AdMessageCodec();
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

    ByteBuffer message = codec.encodeMessage(flutterPublisherAdRequest);

    FlutterPublisherAdRequest decodedPublisherAdRequest =
        (FlutterPublisherAdRequest) codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedPublisherAdRequest, flutterPublisherAdRequest);
  }

  @Test
  public void adMessageCodec_decodeServerSideVerificationOptions() {
    AdMessageCodec codec = new AdMessageCodec();
    FlutterServerSideVerificationOptions options =
        new FlutterServerSideVerificationOptions("user-id", "custom-data");

    ByteBuffer message = codec.encodeMessage(options);

    FlutterServerSideVerificationOptions decodedOptions =
        (FlutterServerSideVerificationOptions)
            codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);

    // With userId = null.
    options = new FlutterServerSideVerificationOptions(null, "custom-data");
    message = codec.encodeMessage(options);
    decodedOptions =
        (FlutterServerSideVerificationOptions)
            codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);

    // With customData = null.
    options = new FlutterServerSideVerificationOptions("user-Id", null);
    message = codec.encodeMessage(options);
    decodedOptions =
        (FlutterServerSideVerificationOptions)
            codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);

    // With userId and customData = null.
    options = new FlutterServerSideVerificationOptions(null, null);
    message = codec.encodeMessage(options);
    decodedOptions =
        (FlutterServerSideVerificationOptions)
            codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedOptions, options);
  }
}
