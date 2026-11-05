// Copyright 2026 Google LLC
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
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import android.content.Context;
import androidx.test.core.app.ApplicationProvider;
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize;
import com.google.android.libraries.ads.mobile.sdk.banner.AdView;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAd;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAdRequest;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import io.flutter.plugin.common.MethodChannel;
import java.util.Arrays;
import java.util.List;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.robolectric.RobolectricTestRunner;

/** Tests for the Next-Gen SDK {@link FlutterBannerAd}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterBannerAdTest {

  private AdInstanceManager manager;
  private FlutterAdRequest mockRequest;
  private BannerAdCreator mockBannerAdCreator;
  private AdView mockAdView;
  private BannerAd mockBannerAd;
  private Context context;

  @Before
  public void setup() {
    context = ApplicationProvider.getApplicationContext();
    manager = new AdInstanceManager(mock(MethodChannel.class));
    mockRequest = mock(FlutterAdRequest.class);
    BannerAdRequest.Builder mockBuilder = mock(BannerAdRequest.Builder.class);
    doReturn(mock(BannerAdRequest.class)).when(mockBuilder).build();
    doReturn(mockBuilder).when(mockRequest).toBannerAdRequestBuilder(any(), anyList());

    mockAdView = mock(AdView.class);
    mockBannerAd = mock(BannerAd.class);
    doReturn(mockBannerAd).when(mockAdView).getBannerAd();

    mockBannerAdCreator = mock(BannerAdCreator.class);
    doReturn(mockAdView).when(mockBannerAdCreator).createAdView();
  }

  private FlutterBannerAd createBannerAd(FlutterAdSize size) {
    return new FlutterBannerAd(1, manager, "testId", mockRequest, size, mockBannerAdCreator);
  }

  @SuppressWarnings("unchecked")
  private List<AdSize> loadAndCaptureRequestedSizes(FlutterBannerAd bannerAd) {
    bannerAd.load();
    ArgumentCaptor<List<AdSize>> captor = ArgumentCaptor.forClass(List.class);
    verify(mockRequest).toBannerAdRequestBuilder(eq("testId"), captor.capture());
    verify(mockAdView).loadAd(any(BannerAdRequest.class), any(AdLoadCallback.class));
    return captor.getValue();
  }

  @Test
  public void load_inlineAdaptiveSize_keepsInlineAdaptiveFlag() {
    FlutterAdSize size =
        new FlutterAdSize.InlineAdaptiveBannerAdSize(
            new FlutterAdSize.AdSizeFactory(), context, 328, null, 320);

    List<AdSize> requested = loadAndCaptureRequestedSizes(createBannerAd(size));

    assertEquals(1, requested.size());
    assertSame(size.getAdSize(), requested.get(0));
    assertTrue(requested.get(0).isInlineAdaptiveBanner());
    assertFalse(requested.get(0).isAnchoredAdaptiveBanner());
  }

  @Test
  public void load_anchoredAdaptiveSize_keepsAnchoredAdaptiveFlag() {
    FlutterAdSize size =
        new FlutterAdSize.AnchoredAdaptiveBannerAdSize(
            context, new FlutterAdSize.AdSizeFactory(), "portrait", 344, false);

    List<AdSize> requested = loadAndCaptureRequestedSizes(createBannerAd(size));

    assertSame(size.getAdSize(), requested.get(0));
    assertTrue(requested.get(0).isAnchoredAdaptiveBanner());
    assertFalse(requested.get(0).isLargeAnchoredAdaptiveBanner());
  }

  @Test
  public void load_largeAnchoredAdaptiveSize_keepsLargeAnchoredAdaptiveFlag() {
    FlutterAdSize size =
        new FlutterAdSize.AnchoredAdaptiveBannerAdSize(
            context, new FlutterAdSize.AdSizeFactory(), null, 344, true);

    List<AdSize> requested = loadAndCaptureRequestedSizes(createBannerAd(size));

    assertSame(size.getAdSize(), requested.get(0));
    assertTrue(requested.get(0).isLargeAnchoredAdaptiveBanner());
  }

  @Test
  public void load_multipleSizes_passesAllSizesThrough() {
    FlutterAdSize fixed = new FlutterAdSize(320, 50);
    FlutterAdSize fluid = new FlutterAdSize.FluidAdSize();
    FlutterAdSize inline =
        new FlutterAdSize.InlineAdaptiveBannerAdSize(
            new FlutterAdSize.AdSizeFactory(), context, 328, null, 320);
    FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            1,
            manager,
            "testId",
            mockRequest,
            Arrays.asList(fixed, fluid, inline),
            mockBannerAdCreator);

    List<AdSize> requested = loadAndCaptureRequestedSizes(bannerAd);

    assertEquals(3, requested.size());
    assertEquals(new AdSize(320, 50), requested.get(0));
    assertSame(AdSize.FLUID, requested.get(1));
    assertSame(inline.getAdSize(), requested.get(2));
  }

  @Test
  public void getAdSize_fixedSize_returnsSdkSize() {
    FlutterBannerAd bannerAd = createBannerAd(new FlutterAdSize(320, 50));
    bannerAd.load();
    doReturn(new AdSize(320, 50)).when(mockBannerAd).getAdSize();

    assertEquals(new FlutterAdSize(320, 50), bannerAd.getAdSize());
  }

  @Test
  public void getAdSize_inlineAdaptive_returnsSdkSizeUnchanged() {
    FlutterBannerAd bannerAd =
        createBannerAd(
            new FlutterAdSize.InlineAdaptiveBannerAdSize(
                new FlutterAdSize.AdSizeFactory(), context, 426, null, 320));
    bannerAd.load();
    // Next-Gen SDK 1.5.0 reports inline adaptive sizes in dp; no conversion is applied.
    doReturn(new AdSize(426, 320)).when(mockBannerAd).getAdSize();

    assertEquals(new FlutterAdSize(426, 320), bannerAd.getAdSize());
  }

  @Test
  public void getAdSize_noBannerAd_returnsNull() {
    FlutterBannerAd bannerAd = createBannerAd(new FlutterAdSize(320, 50));
    bannerAd.load();
    doReturn(null).when(mockAdView).getBannerAd();

    assertNull(bannerAd.getAdSize());
  }

  @Test
  public void getAdSize_beforeLoad_returnsNull() {
    assertNull(createBannerAd(new FlutterAdSize(320, 50)).getAdSize());
  }
}

