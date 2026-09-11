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

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import android.content.Context;
import android.view.View;
import androidx.test.core.app.ApplicationProvider;
import io.flutter.plugin.platform.PlatformView;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link GoogleMobileAdsViewFactory}. */
@RunWith(RobolectricTestRunner.class)
public class GoogleMobileAdsViewFactoryTest {

  private Context context;
  private AdInstanceManager mockManager;
  private GoogleMobileAdsViewFactory factory;

  @Before
  public void setup() {
    context = ApplicationProvider.getApplicationContext();
    mockManager = mock(AdInstanceManager.class);
    factory = new GoogleMobileAdsViewFactory(mockManager);
  }

  @Test
  public void create_withNullArgs_returnsConsistentView() {
    PlatformView platformView = factory.create(context, 1, null);
    assertNotNull(platformView);

    View view1 = platformView.getView();
    View view2 = platformView.getView();
    assertNotNull(view1);
    assertSame(view1, view2);
  }

  @Test
  public void create_withUnknownAdId_returnsConsistentView() {
    when(mockManager.adForId(999)).thenReturn(null);

    PlatformView platformView = factory.create(context, 1, 999);
    assertNotNull(platformView);

    View view1 = platformView.getView();
    View view2 = platformView.getView();
    assertNotNull(view1);
    assertSame(view1, view2);
  }

  @Test
  public void create_withAdHavingNullPlatformView_returnsConsistentView() {
    FlutterAd mockAd = mock(FlutterAd.class);
    when(mockAd.getPlatformView()).thenReturn(null);
    when(mockManager.adForId(123)).thenReturn(mockAd);

    PlatformView platformView = factory.create(context, 1, 123);
    assertNotNull(platformView);

    View view1 = platformView.getView();
    View view2 = platformView.getView();
    assertNotNull(view1);
    assertSame(view1, view2);
  }

  @Test
  public void create_withValidAd_returnsAdPlatformView() {
    FlutterAd mockAd = mock(FlutterAd.class);
    PlatformView mockPlatformView = mock(PlatformView.class);
    when(mockAd.getPlatformView()).thenReturn(mockPlatformView);
    when(mockManager.adForId(123)).thenReturn(mockAd);

    PlatformView result = factory.create(context, 1, 123);
    assertSame(mockPlatformView, result);
  }
}
