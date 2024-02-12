package io.flutter.plugins.googlemobileads;

import android.os.Bundle;
import android.util.Pair;
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import java.util.Map;

public interface FlutterMediationExtras {

  Pair<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras();

  void setMediationExtras(Map<String, Object> extras);

}