package io.flutter.plugins.googlemobileads;

import android.util.Log;
import androidx.annotation.NonNull;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;
import io.flutter.plugin.common.MethodChannel.Result;
import java.lang.reflect.Method;

/** An {@link OnInitializationCompleteListener} that invokes result.success() at most once. */
public final class FlutterInitializationListener implements OnInitializationCompleteListener {

  private final Result result;
  private boolean isInitializationCompleted;

  FlutterInitializationListener(@NonNull final Result result) {
    this.result = result;
    isInitializationCompleted = false;
  }

  @Override
  public void onInitializationComplete(@NonNull InitializationStatus initializationStatus) {
    // Make sure not to invoke this more than once, since Dart will throw an exception if success
    // is invoked more than once. See b/193418432.
    if (isInitializationCompleted) {
      return;
    }
    try {
      Class<?> clazz = Class.forName("com.google.android.gms.ads.MobileAds");
      Method method = clazz.getDeclaredMethod("setPlugin", String.class);
      method.setAccessible(true);
      method.invoke(null, Constants.REQUEST_AGENT_PREFIX_VERSIONED);
    } catch (Exception ignored) {
    }
    result.success(new FlutterInitializationStatus(initializationStatus));
    isInitializationCompleted = true;
  }
}
