package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.LoadAdError;

public class AdViewWithListenerProxy extends AdListener implements AdContainersChannelLibrary.$AdWithViewListener {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public AdViewWithListenerProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onAdLoaded() {
    implementations.getChannelAdWithViewListener().$onAdLoaded(this);
  }

  @Override
  public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    implementations.getChannelAdWithViewListener().$onAdFailedToLoad(this, new LoadAdErrorProxy(loadAdError, implementations));
  }

  @Override
  public void onAdOpened() {
    implementations.getChannelAdWithViewListener().$onAdOpened(this);
  }

  @Override
  public void onAdClosed() {
    implementations.getChannelAdWithViewListener().$onAdClosed(this);
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelAdWithViewListener().disposeInstancePair(this);
    super.finalize();
  }
}
