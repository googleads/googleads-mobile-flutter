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
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;

import android.content.Context;
import com.google.android.gms.ads.AdSize;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterAdapterResponseInfo;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterResponseInfo;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.junit.Before;
import org.junit.Test;

/** Tests for {@link AdMessageCodec}. */
public class AdMessageCodecTest {
  AdMessageCodec codec;
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
    codec = new AdMessageCodec(null, testAdFactory);
  }

  @Test
  public void encodeAdapterInitializationState() {
    final ByteBuffer message =
        codec.encodeMessage(FlutterAdapterStatus.AdapterInitializationState.NOT_READY);

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        FlutterAdapterStatus.AdapterInitializationState.NOT_READY);
  }

  @Test
  public void encodeAdapterStatus() {
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
  public void encodeInitializationStatus() {
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
  public void decodeServerSideVerificationOptions() {
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

  @Test
  public void encodeAnchoredAdaptiveBannerAdSize() {
    final FlutterAdSize.AnchoredAdaptiveBannerAdSize adaptiveAdSize =
        new FlutterAdSize.AnchoredAdaptiveBannerAdSize(null, testAdFactory, "portrait", 23);
    final ByteBuffer data = codec.encodeMessage(adaptiveAdSize);

    final FlutterAdSize.AnchoredAdaptiveBannerAdSize result =
        (FlutterAdSize.AnchoredAdaptiveBannerAdSize)
            codec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, mockAdSize);
  }

  @Test
  public void encodeSmartBannerAdSize() {
    final ByteBuffer data = codec.encodeMessage(new FlutterAdSize.SmartBannerAdSize());

    final FlutterAdSize.SmartBannerAdSize result =
        (FlutterAdSize.SmartBannerAdSize) codec.decodeMessage((ByteBuffer) data.position(0));
    assertEquals(result.size, AdSize.SMART_BANNER);
  }

  @Test
  public void nativeAdOptionsNull() {
    final ByteBuffer data =
        codec.encodeMessage(new FlutterNativeAdOptions(null, null, null, null, null, null));

    final FlutterNativeAdOptions result =
        (FlutterNativeAdOptions) codec.decodeMessage((ByteBuffer) data.position(0));
    assertNull(result.adChoicesPlacement);
    assertNull(result.mediaAspectRatio);
    assertNull(result.videoOptions);
    assertNull(result.requestCustomMuteThisAd);
    assertNull(result.shouldRequestMultipleImages);
    assertNull(result.shouldReturnUrlsForImageAssets);
  }

  @Test
  public void nativeAdOptions() {
    FlutterVideoOptions videoOptions = new FlutterVideoOptions(true, false, true);

    final ByteBuffer data =
        codec.encodeMessage(new FlutterNativeAdOptions(1, 2, videoOptions, false, true, false));

    final FlutterNativeAdOptions result =
        (FlutterNativeAdOptions) codec.decodeMessage((ByteBuffer) data.position(0));
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
  public void videoOptionsNull() {
    final ByteBuffer data = codec.encodeMessage(new FlutterVideoOptions(null, null, null));

    final FlutterVideoOptions result =
        (FlutterVideoOptions) codec.decodeMessage((ByteBuffer) data.position(0));
    assertNull(result.clickToExpandRequested);
    assertNull(result.customControlsRequested);
    assertNull(result.startMuted);
  }

  @Test
  public void encodeFlutterAdRequest() {
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterAdRequest.Builder()
                .setKeywords(Arrays.asList("1", "2", "3"))
                .setContentUrl("contentUrl")
                .setNonPersonalizedAds(false)
                .setNeighboringContentUrls(Arrays.asList("example.com", "test.com"))
                .setHttpTimeoutMillis(1000)
                .build());

    final FlutterAdRequest request =
        (FlutterAdRequest) codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(Arrays.asList("1", "2", "3"), request.getKeywords());
    assertEquals("contentUrl", request.getContentUrl());
    assertEquals(false, request.getNonPersonalizedAds());
    assertEquals(Arrays.asList("example.com", "test.com"), request.getNeighboringContentUrls());
    assertEquals((Integer) 1000, request.getHttpTimeoutMillis());
  }

  @Test
  public void encodeFlutterAdManagerAdRequest() {
    FlutterAdManagerAdRequest.Builder builder = new FlutterAdManagerAdRequest.Builder();
    builder.setKeywords(Arrays.asList("1", "2", "3"));
    builder.setContentUrl("contentUrl");
    builder.setCustomTargeting(Collections.singletonMap("apple", "banana"));
    builder.setCustomTargetingLists(
        Collections.singletonMap("cherry", Collections.singletonList("pie")));
    builder.setNonPersonalizedAds(true);
    FlutterAdManagerAdRequest flutterAdManagerAdRequest = builder.build();

    final ByteBuffer message = codec.encodeMessage(flutterAdManagerAdRequest);

    assertEquals(codec.decodeMessage((ByteBuffer) message.position(0)), flutterAdManagerAdRequest);
  }

  @Test
  public void encodeFlutterAdSize() {
    final ByteBuffer message = codec.encodeMessage(new FlutterAdSize(1, 2));

    assertEquals(codec.decodeMessage((ByteBuffer) message.position(0)), new FlutterAdSize(1, 2));
  }

  @Test
  public void encodeFlutterRewardItem() {
    final ByteBuffer message =
        codec.encodeMessage(new FlutterRewardedAd.FlutterRewardItem(23, "coins"));

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        new FlutterRewardedAd.FlutterRewardItem(23, "coins"));
  }

  @Test
  public void encodeFlutterLoadAdError() {
    List<FlutterAdapterResponseInfo> adapterResponseInfos = new ArrayList<>();
    adapterResponseInfos.add(
        new FlutterAdapterResponseInfo("adapter-class", 9999, "description", "credentials", null));
    FlutterResponseInfo info =
        new FlutterResponseInfo("responseId", "className", adapterResponseInfos);
    final ByteBuffer message =
        codec.encodeMessage(new FlutterBannerAd.FlutterLoadAdError(1, "domain", "message", info));

    final FlutterAd.FlutterLoadAdError error =
        (FlutterAd.FlutterLoadAdError) codec.decodeMessage((ByteBuffer) message.position(0));
    assertNotNull(error);
    assertEquals(error.code, 1);
    assertEquals(error.domain, "domain");
    assertEquals(error.message, "message");
    assertEquals(error.responseInfo, info);
  }
}
