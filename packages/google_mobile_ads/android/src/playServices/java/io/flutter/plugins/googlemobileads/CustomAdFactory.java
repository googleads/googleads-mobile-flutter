package io.flutter.plugins.googlemobileads;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.nativead.NativeCustomFormatAd;
import java.util.Map;

public interface CustomAdFactory {
  View createCustomAd(
      @NonNull NativeCustomFormatAd nativeAd, @Nullable Map<String, Object> customOptions);
}
