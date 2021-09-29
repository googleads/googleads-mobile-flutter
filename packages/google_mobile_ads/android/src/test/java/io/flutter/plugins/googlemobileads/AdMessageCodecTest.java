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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;

import android.content.Context;
import com.google.android.gms.ads.AdSize;
import io.flutter.plugins.googlemobileads.FlutterAdSize.AdSizeFactory;
import io.flutter.plugins.googlemobileads.FlutterAdSize.InlineAdaptiveBannerAdSize;
import io.flutter.plugins.googlemobileads.FlutterAdSize.AnchoredAdaptiveBannerAdSize;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link AdMessageCodec}. */
@RunWith(RobolectricTestRunner.class)
public class AdMessageCodecTest {
  AdMessageCodec testCodec;
  AdSizeFactory mockAdSizeFactory;

  @Before
  public void setup() {
    mockAdSizeFactory = mock(AdSizeFactory.class);
    testCodec = new AdMessageCodec(mock(Context.class), mockAdSizeFactory);
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

    FlutterAdManagerAdRequest flutterAdManagerAdRequest =
        new FlutterAdManagerAdRequest.Builder()
            .setContentUrl("test-content-url")
            .setCustomTargeting(targeting)
            .setCustomTargetingLists(targetingList)
            .setKeywords(list)
            .setNonPersonalizedAds(true)
            .build();

    ByteBuffer message = testCodec.encodeMessage(flutterAdManagerAdRequest);

    FlutterAdManagerAdRequest decodedAdManagerAdRequest =
        (FlutterAdManagerAdRequest) testCodec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(decodedAdManagerAdRequest, flutterAdManagerAdRequest);
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
    AdSize mockAdSize = mock(AdSize.class);
    doReturn(mockAdSize)
        .when(mockAdSizeFactory)
        .getPortraitAnchoredAdaptiveBannerAdSize(any(Context.class), anyInt());

    final AnchoredAdaptiveBannerAdSize adaptiveAdSize =
        new AnchoredAdaptiveBannerAdSize(mock(Context.class), mockAdSizeFactory, "portrait", 23);
    final ByteBuffer data = testCodec.encodeMessage(adaptiveAdSize);

    final AnchoredAdaptiveBannerAdSize result =
        (AnchoredAdaptiveBannerAdSize) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, mockAdSize);
  }

  @Test
  public void adMessageCodec_encodeSmartBannerAdSize() {
    final ByteBuffer data = testCodec.encodeMessage(new FlutterAdSize.SmartBannerAdSize());

    final FlutterAdSize.SmartBannerAdSize result =
        (FlutterAdSize.SmartBannerAdSize) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, AdSize.SMART_BANNER);
  }

  @Test
  public void adMessageCodec_encodeFluidAdSize() {
    final ByteBuffer data = testCodec.encodeMessage(new FlutterAdSize.FluidAdSize());

    final FlutterAdSize.FluidAdSize result =
        (FlutterAdSize.FluidAdSize) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, AdSize.FLUID);
  }

  @Test
  public void adMessageCodec_nativeAdOptionsNull() {
    final ByteBuffer data =
        testCodec.encodeMessage(new FlutterNativeAdOptions(null, null, null, null, null, null));

    final FlutterNativeAdOptions result =
        (FlutterNativeAdOptions) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertNull(result.adChoicesPlacement);
    assertNull(result.mediaAspectRatio);
    assertNull(result.videoOptions);
    assertNull(result.requestCustomMuteThisAd);
    assertNull(result.shouldRequestMultipleImages);
    assertNull(result.shouldReturnUrlsForImageAssets);
  }

  @Test
  public void adMessageCodec_nativeAdOptions() {
    FlutterVideoOptions videoOptions = new FlutterVideoOptions(true, false, true);

    final ByteBuffer data =
        testCodec.encodeMessage(new FlutterNativeAdOptions(1, 2, videoOptions, false, true, false));

    final FlutterNativeAdOptions result =
        (FlutterNativeAdOptions) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.adChoicesPlacement, (Integer) 1);
    assertEquals(result.mediaAspectRatio, (Integer) 2);
    assertEquals(result.videoOptions.clickToExpandRequested, true);
    assertEquals(result.videoOptions.customControlsRequested, false);
    assertEquals(result.videoOptions.startMuted, true);
    assertFalse(result.requestCustomMuteThisAd);
    assertTrue(result.shouldRequestMultipleImages);
    assertFalse(result.shouldReturnUrlsForImageAssets);
  }

  @Test
  public void adMessageCodec_videoOptionsNull() {
    final ByteBuffer data = testCodec.encodeMessage(new FlutterVideoOptions(null, null, null));

    final FlutterVideoOptions result =
        (FlutterVideoOptions) testCodec.decodeMessage((ByteBuffer) data.position(0));
    assertNull(result.clickToExpandRequested);
    assertNull(result.customControlsRequested);
    assertNull(result.startMuted);
  }

  @Test
  public void adMessageCodec_adaptiveInlineBanner() {
    AdSize adSize = new AdSize(100, 101);
    doReturn(adSize)
        .when(mockAdSizeFactory)
        .getCurrentOrientationInlineAdaptiveBannerAdSize(any(Context.class), eq(100));

    InlineAdaptiveBannerAdSize size =
        new InlineAdaptiveBannerAdSize(mockAdSizeFactory, mock(Context.class), 100, null, null);
    final ByteBuffer data = testCodec.encodeMessage(size);
    final InlineAdaptiveBannerAdSize result =
        (InlineAdaptiveBannerAdSize) testCodec.decodeMessage((ByteBuffer) data.position(0));

    assertEquals(result.width, 100);
    assertNull(result.maxHeight);
    assertNull(result.orientation);
  }
}
