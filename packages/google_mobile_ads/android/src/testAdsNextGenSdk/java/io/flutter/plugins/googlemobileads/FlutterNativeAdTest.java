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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;

import android.content.Context;
import androidx.test.core.app.ApplicationProvider;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoader;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoaderCallback;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdRequest;
import io.flutter.plugin.common.MethodChannel;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class FlutterNativeAdTest {

  private Context context;
  private AdInstanceManager manager;
  private MockedStatic<NativeAdLoader> mockedNativeAdLoader;

  @Before
  public void setup() {
    context = ApplicationProvider.getApplicationContext();
    manager = new AdInstanceManager(mock(MethodChannel.class));
    mockedNativeAdLoader = Mockito.mockStatic(NativeAdLoader.class);
  }

  @After
  public void tearDown() {
    mockedNativeAdLoader.close();
  }

  @Test
  public void load_withAdRequest_setsRequestAgent() {
    FlutterNativeAd nativeAd =
        new FlutterNativeAd.Builder(context)
            .setId(1)
            .setManager(manager)
            .setAdUnitId("test-ad-unit")
            .setAdFactory(mock(NativeAdFactory.class))
            .setRequest(
                new FlutterAdRequest.Builder()
                    .setRequestAgent(Constants.REQUEST_AGENT_PREFIX_VERSIONED)
                    .build())
            .setFlutterAdLoader(new FlutterAdLoader(context))
            .build();

    nativeAd.load();

    ArgumentCaptor<NativeAdRequest> captor = ArgumentCaptor.forClass(NativeAdRequest.class);
    mockedNativeAdLoader.verify(
        () -> NativeAdLoader.load(captor.capture(), any(NativeAdLoaderCallback.class)));
    assertEquals(Constants.REQUEST_AGENT_PREFIX_VERSIONED, captor.getValue().getRequestAgent());
  }

  @Test
  public void load_withAdManagerAdRequest_setsRequestAgent() {
    FlutterNativeAd nativeAd =
        new FlutterNativeAd.Builder(context)
            .setId(2)
            .setManager(manager)
            .setAdUnitId("test-ad-unit")
            .setAdFactory(mock(NativeAdFactory.class))
            .setAdManagerRequest(
                (FlutterAdManagerAdRequest)
                    new FlutterAdManagerAdRequest.Builder()
                        .setRequestAgent(Constants.REQUEST_AGENT_PREFIX_VERSIONED)
                        .build())
            .setFlutterAdLoader(new FlutterAdLoader(context))
            .build();

    nativeAd.load();

    ArgumentCaptor<NativeAdRequest> captor = ArgumentCaptor.forClass(NativeAdRequest.class);
    mockedNativeAdLoader.verify(
        () -> NativeAdLoader.load(captor.capture(), any(NativeAdLoaderCallback.class)));
    assertEquals(Constants.REQUEST_AGENT_PREFIX_VERSIONED, captor.getValue().getRequestAgent());
  }
}
