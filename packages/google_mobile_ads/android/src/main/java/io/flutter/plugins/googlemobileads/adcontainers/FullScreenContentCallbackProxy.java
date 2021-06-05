package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.FullScreenContentCallback;

public class FullScreenContentCallbackProxy extends FullScreenContentCallback implements AdContainersChannelLibrary.$FullScreenContentCallback {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public FullScreenContentCallbackProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onAdShowedFullScreenContent() {
    implementations.getChannelFullScreenContentCallback().$onAdShowedFullScreenContent(this);
  }

  @Override
  public void onAdDismissedFullScreenContent() {
    implementations.getChannelFullScreenContentCallback().$onAdDismissedFullScreenContent(this);
  }

  @Override
  public void onAdImpression() {
    implementations.getChannelFullScreenContentCallback().$onAdImpression(this);
  }

  @Override
  public void onAdFailedToShowFullScreenContent(@NonNull AdError adError) {
    implementations.getChannelFullScreenContentCallback().$onAdFailedToShowFullScreenContent(this);
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelFullScreenContentCallback().disposeInstancePair(this);
    super.finalize();
  }
}
