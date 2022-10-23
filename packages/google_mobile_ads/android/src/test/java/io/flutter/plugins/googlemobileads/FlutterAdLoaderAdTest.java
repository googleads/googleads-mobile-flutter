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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
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
        .loadAdManagerAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest));

    adLoaderAd.load();

    verify(mockLoader)
        .loadAdManagerAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest));

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
        .loadAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest));

    adLoaderAd.load();

    verify(mockLoader).loadAdLoaderAd(eq("testId"), any(AdListener.class), eq(mockRequest));

    verify(testManager).onAdClicked(eq(1));
    verify(testManager).onAdClosed(eq(1));
    FlutterLoadAdError expectedError = new FlutterLoadAdError(mockLoadAdError);
    verify(testManager).onAdFailedToLoad(eq(1), eq(expectedError));
    verify(testManager).onAdImpression(eq(1));
    verify(testManager).onAdOpened(eq(1));
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
