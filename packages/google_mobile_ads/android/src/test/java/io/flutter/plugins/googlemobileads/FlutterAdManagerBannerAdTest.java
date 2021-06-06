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
import static org.junit.Assert.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerAdView;
import com.google.android.gms.ads.admanager.AppEventListener;
import io.flutter.plugin.common.BinaryMessenger;

import java.util.ArrayList;
import java.util.List;
import org.junit.Before;
import org.junit.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

/** Tests for {@link FlutterAdManagerBannerAd}. */
public class FlutterAdManagerBannerAdTest {

  private AdInstanceManager mockManager;
  private AdManagerAdRequest mockAdRequest;
  private AdSize adSize;
  private AdManagerAdView mockAdView;

  // The system under test.
  private FlutterAdManagerBannerAd flutterBannerAd;

  @Before
  public void setup() {
    // Setup mock dependencies for flutterBannerAd.
    BinaryMessenger mockMessenger = mock(BinaryMessenger.class);
    mockManager = spy(new AdInstanceManager(mock(Activity.class), mockMessenger));
    FlutterAdManagerAdRequest mockFlutterAdRequest = mock(FlutterAdManagerAdRequest.class);
    mockAdRequest = mock(AdManagerAdRequest.class);
    FlutterAdSize mockFlutterAdSize = mock(FlutterAdSize.class);
    adSize = new AdSize(1, 2);
    when(mockFlutterAdRequest.asAdManagerAdRequest()).thenReturn(mockAdRequest);
    when(mockFlutterAdSize.getAdSize()).thenReturn(adSize);
    List<FlutterAdSize> sizes = new ArrayList<>();
    sizes.add(mockFlutterAdSize);
    BannerAdCreator bannerAdCreator = mock(BannerAdCreator.class);
    mockAdView = mock(AdManagerAdView.class);
    doReturn(mockAdView).when(bannerAdCreator).createAdManagerAdView();
    flutterBannerAd =
        new FlutterAdManagerBannerAd(
            mockManager, "testId", sizes, mockFlutterAdRequest, bannerAdCreator);
  }

  @Test
  public void failedToLoad() {
    final LoadAdError loadError = mock(LoadAdError.class);
    ResponseInfo responseInfo = mock(ResponseInfo.class);
    doReturn("id").when(responseInfo).getResponseId();
    doReturn("className").when(responseInfo).getMediationAdapterClassName();
    doReturn(1).when(loadError).getCode();
    doReturn("2").when(loadError).getDomain();
    doReturn("3").when(loadError).getMessage();
    doReturn(null).when(loadError).getResponseInfo();
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AdListener listener = invocation.getArgument(0);
                listener.onAdFailedToLoad(loadError);
                return null;
              }
            })
        .when(mockAdView)
        .setAdListener(any(AdListener.class));

    flutterBannerAd.load();
    verify(mockAdView).loadAd(eq(mockAdRequest));
    verify(mockAdView).setAdListener(any(AdListener.class));
    verify(mockAdView).setAppEventListener(any(AppEventListener.class));
    verify(mockAdView).setAdUnitId(eq("testId"));
    verify(mockAdView).setAdSizes(adSize);
    FlutterLoadAdError expectedError = new FlutterLoadAdError(loadError);
    verify(mockManager).onAdFailedToLoad(eq(flutterBannerAd), eq(expectedError));
  }

  @Test
  public void loadWithListenerCallbacks() {
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AdListener listener = invocation.getArgument(0);
                listener.onAdLoaded();
                listener.onAdImpression();
                listener.onAdClosed();
                listener.onAdOpened();
                return null;
              }
            })
        .when(mockAdView)
        .setAdListener(any(AdListener.class));
    final ResponseInfo responseInfo = mock(ResponseInfo.class);
    doReturn(responseInfo).when(mockAdView).getResponseInfo();
    flutterBannerAd.load();

    verify(mockAdView).loadAd(eq(mockAdRequest));
    verify(mockAdView).setAdListener(any(AdListener.class));
    verify(mockAdView).setAdUnitId(eq("testId"));
    verify(mockAdView).setAdSizes(adSize);
    verify(mockManager).onAdLoaded(eq(flutterBannerAd), eq(responseInfo));
    verify(mockManager).onAdImpression(eq(flutterBannerAd));
    verify(mockManager).onAdClosed(eq(flutterBannerAd));
    verify(mockManager).onAdOpened(eq(flutterBannerAd));
    assertEquals(flutterBannerAd.getView(), mockAdView);
  }

  @Test
  public void appEventListener() {
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AppEventListener listener = invocation.getArgument(0);
                listener.onAppEvent("appEvent", "data");
                return null;
              }
            })
        .when(mockAdView)
        .setAppEventListener(any(AppEventListener.class));

    flutterBannerAd.load();

    verify(mockManager).onAppEvent(eq(flutterBannerAd), eq("appEvent"), eq("data"));
  }

  @Test
  public void destroy() {
    flutterBannerAd.load();

    assertEquals(flutterBannerAd.getView(), mockAdView);

    flutterBannerAd.destroy();
    verify(mockAdView).destroy();

    assertNull(flutterBannerAd.getView());
  }
}
