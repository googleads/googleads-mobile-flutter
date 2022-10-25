// Copyright 2022 Google LLC
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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerAdView;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterLoadAdError;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link FlutterAdLoaderAd} */
@RunWith(RobolectricTestRunner.class)
public class FlutterAdLoaderAdTest {

  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();

  @Before
  public void setup() {
    testManager = spy(new AdInstanceManager(mock(MethodChannel.class)));
    when(testManager.getActivity()).thenReturn(mock(Activity.class));
  }

  @Test
  public void loadAdLoaderAdWithAdManagerAdRequest() {
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest(anyString())).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    final FlutterAdLoaderAd adLoaderAd =
        new FlutterAdLoaderAd(1, testManager, "testId", mockFlutterRequest, mockLoader);

    final LoadAdError mockLoadAdError = mock(LoadAdError.class);
    when(mockLoadAdError.getCode()).thenReturn(1);
    when(mockLoadAdError.getDomain()).thenReturn("2");
    when(mockLoadAdError.getMessage()).thenReturn("3");

    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) {
                AdListener listener = invocation.getArgument(1);
                listener.onAdClicked();
                listener.onAdClosed();
                listener.onAdFailedToLoad(mockLoadAdError);
                listener.onAdImpression();
                listener.onAdOpened();
                return null;
              }
            })
        .when(mockLoader)
        .loadAdManagerAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest), isNull());

    adLoaderAd.load();

    verify(mockLoader)
        .loadAdManagerAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest), isNull());

    verify(testManager).onAdClicked(eq(1));
    verify(testManager).onAdClosed(eq(1));
    FlutterLoadAdError expectedError = new FlutterLoadAdError(mockLoadAdError);
    verify(testManager).onAdFailedToLoad(eq(1), eq(expectedError));
    verify(testManager).onAdImpression(eq(1));
    verify(testManager).onAdOpened(eq(1));
  }

  @Test
  public void loadAdLoaderAdWithAdRequest() {
    final FlutterAdRequest mockFlutterRequest = mock(FlutterAdRequest.class);
    final AdRequest mockRequest = mock(AdRequest.class);
    when(mockFlutterRequest.asAdRequest(anyString())).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    final FlutterAdLoaderAd adLoaderAd =
        new FlutterAdLoaderAd(1, testManager, "testId", mockFlutterRequest, mockLoader);

    final LoadAdError mockLoadAdError = mock(LoadAdError.class);
    when(mockLoadAdError.getCode()).thenReturn(1);
    when(mockLoadAdError.getDomain()).thenReturn("2");
    when(mockLoadAdError.getMessage()).thenReturn("3");

    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) {
                AdListener listener = invocation.getArgument(1);
                listener.onAdClicked();
                listener.onAdClosed();
                listener.onAdFailedToLoad(mockLoadAdError);
                listener.onAdImpression();
                listener.onAdOpened();
                return null;
              }
            })
        .when(mockLoader)
        .loadAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest), isNull());

    adLoaderAd.load();

    verify(mockLoader)
        .loadAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest), isNull());

    verify(testManager).onAdClicked(eq(1));
    verify(testManager).onAdClosed(eq(1));
    FlutterLoadAdError expectedError = new FlutterLoadAdError(mockLoadAdError);
    verify(testManager).onAdFailedToLoad(eq(1), eq(expectedError));
    verify(testManager).onAdImpression(eq(1));
    verify(testManager).onAdOpened(eq(1));
  }

  @Test
  public void loadAdLoaderAdBannerWithAdManagerAdRequest() {
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest(anyString())).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    final FlutterAdLoaderAd adLoaderAd =
        new FlutterAdLoaderAd(1, testManager, "testId", mockFlutterRequest, mockLoader);
    final FlutterAdManagerAdViewLoadedListener listener =
        new FlutterAdManagerAdViewLoadedListener(adLoaderAd);
    final FlutterAdLoaderAd.BannerParameters bannerParameters =
        new FlutterAdLoaderAd.BannerParameters(listener, new AdSize[] {AdSize.BANNER}, null);
    adLoaderAd.bannerParameters = bannerParameters;

    final LoadAdError mockLoadAdError = mock(LoadAdError.class);
    when(mockLoadAdError.getCode()).thenReturn(1);
    when(mockLoadAdError.getDomain()).thenReturn("2");
    when(mockLoadAdError.getMessage()).thenReturn("3");

    final AdManagerAdView mockAdView = mock(AdManagerAdView.class);
    when(mockAdView.getAdSize()).thenReturn(new AdSize(0, 0));
    final ResponseInfo mockResponseInfo = mock(ResponseInfo.class);
    when(mockAdView.getResponseInfo()).thenReturn(mockResponseInfo);

    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) {
                AdListener listener = invocation.getArgument(1);
                listener.onAdClicked();
                listener.onAdClosed();
                listener.onAdFailedToLoad(mockLoadAdError);
                listener.onAdImpression();
                listener.onAdOpened();

                FlutterAdLoaderAd.BannerParameters bannerParameters = invocation.getArgument(3);
                bannerParameters.listener.onAdManagerAdViewLoaded(mockAdView);
                return null;
              }
            })
        .when(mockLoader)
        .loadAdManagerAdLoaderAd(
            eq("testId"), any(AdListener.class), eq(mockRequest), eq(bannerParameters));

    adLoaderAd.load();

    assertEquals(adLoaderAd.getAdLoaderAdType(), FlutterAdLoaderAd.AdLoaderAdType.BANNER);

    final FlutterAdSize adSize = adLoaderAd.getAdSize();
    assertEquals(adSize.width, 0);
    assertEquals(adSize.height, 0);

    verify(mockAdView, times(1)).getAdSize();

    verify(mockLoader)
        .loadAdManagerAdLoaderAd(
            eq("testId"), any(AdListener.class), eq(mockRequest), eq(bannerParameters));

    verify(testManager).onAdClicked(eq(1));
    verify(testManager).onAdClosed(eq(1));
    FlutterLoadAdError expectedError = new FlutterLoadAdError(mockLoadAdError);
    verify(testManager).onAdFailedToLoad(eq(1), eq(expectedError));
    verify(testManager).onAdImpression(eq(1));
    verify(testManager).onAdOpened(eq(1));
    verify(testManager).onAdLoaded(eq(1), eq(mockResponseInfo));
  }

  @Test(expected = IllegalStateException.class)
  public void adLoaderAdBuilderNullManager() {
    new FlutterAdLoaderAd.Builder()
        .setManager(null)
        .setAdUnitId("testId")
        .setRequest(request)
        .build();
  }

  @Test(expected = IllegalStateException.class)
  public void adLoaderAdBuilderNullAdUnitId() {
    new FlutterAdLoaderAd.Builder()
        .setManager(testManager)
        .setAdUnitId(null)
        .setRequest(request)
        .build();
  }

  @Test(expected = IllegalStateException.class)
  public void adLoaderAdBuilderNullRequest() {
    new FlutterAdLoaderAd.Builder()
        .setManager(testManager)
        .setAdUnitId("testId")
        .setRequest(null)
        .build();
  }
}
