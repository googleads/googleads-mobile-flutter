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

import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;

/** A type for retrieving {@link ResponseInfo} from an ad after it is loaded. */
interface ResponseInfoProvider {
  ResponseInfo getResponseInfo();
}

class FlutterAdListener extends AdListener {
  @NonNull protected final AdInstanceManager manager;
  @NonNull protected final FlutterAd ad;
  @NonNull protected final ResponseInfoProvider responseInfoProvider;

  FlutterAdListener(
      @NonNull AdInstanceManager manager,
      @NonNull FlutterAd ad,
      @NonNull ResponseInfoProvider responseInfoProvider) {
    this.manager = manager;
    this.ad = ad;
    this.responseInfoProvider = responseInfoProvider;
  }

  @Override
  public void onAdClosed() {
    manager.onAdClosed(ad);
  }

  @Override
  public void onAdFailedToLoad(LoadAdError loadAdError) {
    manager.onAdFailedToLoad(ad, new FlutterAd.FlutterLoadAdError(loadAdError));
  }

  @Override
  public void onAdOpened() {
    manager.onAdOpened(ad);
  }

  @Override
  public void onAdLoaded() {
    manager.onAdLoaded(ad, responseInfoProvider.getResponseInfo());
  }
}

/**
 * Ad listener for banner ads. Does not override onAdClicked(), since that is only for native ads.
 */
class FlutterBannerAdListener extends FlutterAdListener {

  FlutterBannerAdListener(
      @NonNull AdInstanceManager manager,
      @NonNull FlutterAd ad,
      ResponseInfoProvider responseInfoProvider) {
    super(manager, ad, responseInfoProvider);
  }

  @Override
  public void onAdImpression() {
    manager.onAdImpression(ad);
  }
}
