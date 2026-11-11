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

import android.os.Bundle;
import android.util.Pair;
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAdRequest;
import com.google.android.libraries.ads.mobile.sdk.common.AdRequest;
import java.util.Collections;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for the Next-Gen SDK {@link FlutterAdRequest}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterAdRequestTest {

  private static final String AD_UNIT_ID = "test-ad-unit";

  /** Stands in for a third-party ad source's extras receiver. */
  private static class FakeAdSourceAdapter implements MediationExtrasReceiver {}

  private static FlutterAdRequest.Builder requestBuilder() {
    return new FlutterAdRequest.Builder().setRequestAgent("test");
  }

  private static FlutterAdRequest requestWithAdMobExtras() {
    return requestBuilder()
        .setAdMobExtras(Collections.singletonMap("collapsible", "bottom"))
        .setNonPersonalizedAds(true)
        .build();
  }

  private static FlutterAdRequest requestWithAdSourceExtras() {
    Bundle bundle = new Bundle();
    bundle.putString("key", "value");
    FlutterMediationExtras extras =
        new FlutterMediationExtras() {
          @Override
          public Pair<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras() {
            return new Pair<>(FakeAdSourceAdapter.class, bundle);
          }
        };
    return requestBuilder().setMediationExtras(Collections.singletonList(extras)).build();
  }

  private static BannerAdRequest asBannerAdRequest(FlutterAdRequest request) {
    return request
        .toBannerAdRequestBuilder(AD_UNIT_ID, Collections.singletonList(AdSize.BANNER))
        .build();
  }

  @Test
  public void asAdRequest_adMobExtras_sentAsGoogleExtras() {
    AdRequest adRequest = requestWithAdMobExtras().asAdRequest(AD_UNIT_ID);

    assertEquals("bottom", adRequest.getGoogleExtrasBundle().getString("collapsible"));
    assertEquals("1", adRequest.getGoogleExtrasBundle().getString("npa"));
  }

  @Test
  public void asAdRequest_otherAdSourceExtras_sentAsAdSourceExtras() {
    AdRequest adRequest = requestWithAdSourceExtras().asAdRequest(AD_UNIT_ID);

    assertEquals(
        "value", adRequest.getAdSourceExtrasBundle(FakeAdSourceAdapter.class).getString("key"));
  }

  @Test
  public void toBannerAdRequestBuilder_adMobExtras_sentAsGoogleExtras() {
    BannerAdRequest adRequest = asBannerAdRequest(requestWithAdMobExtras());

    assertEquals("bottom", adRequest.getGoogleExtrasBundle().getString("collapsible"));
    assertEquals("1", adRequest.getGoogleExtrasBundle().getString("npa"));
  }

  @Test
  public void toBannerAdRequestBuilder_otherAdSourceExtras_sentAsAdSourceExtras() {
    BannerAdRequest adRequest = asBannerAdRequest(requestWithAdSourceExtras());

    assertEquals(
        "value", adRequest.getAdSourceExtrasBundle(FakeAdSourceAdapter.class).getString("key"));
  }
}
