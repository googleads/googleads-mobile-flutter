package io.flutter.plugins.googlemobileads;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.nativead.CustomNativeAd;
import java.util.Map;

public interface CustomAdFactory {
  View createCustomAd(
      @NonNull CustomNativeAd customNativeAd, @Nullable Map<String, Object> customOptions);
}
