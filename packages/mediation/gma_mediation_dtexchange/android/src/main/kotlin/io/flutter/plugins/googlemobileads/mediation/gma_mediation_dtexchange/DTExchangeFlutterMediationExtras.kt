package io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange

import android.os.Bundle
import android.util.Pair
import androidx.core.os.bundleOf
import com.fyber.inneractive.sdk.external.InneractiveMediationDefs
import com.google.ads.mediation.fyber.FyberMediationAdapter
// import com.google.ads.mediation.fyber.FyberMediationAdapter.KEY_MUTE_VIDEO
import com.google.android.gms.ads.mediation.MediationExtrasReceiver
import io.flutter.plugins.googlemobileads.FlutterMediationExtras

class DTExchangeFlutterMediationExtras : FlutterMediationExtras() {
  private var flutterExtras: Map<String, Any>? = null

  override fun setMediationExtras(extras: MutableMap<String, Any>?) {
    flutterExtras = extras
  }
  override fun getMediationExtras(): Pair<Class<out MediationExtrasReceiver>, Bundle> {
    val extrasMap = flutterExtras
    if (extrasMap == null) {
      return Pair<Class<out MediationExtrasReceiver>, Bundle>(FyberMediationAdapter::class.java, bundleOf())
    }
    val extrasBundle = bundleOf()
    val muteVideo = extrasMap[MUTE_VIDEO]
    if (muteVideo is Boolean) {
      // extrasBundle.putBoolean(KEY_MUTE_VIDEO, muteVideo)
      extrasBundle.putBoolean(MUTE_VIDEO, muteVideo)
    }
    val age = extrasMap[AGE]
    if (age is Int) {
      extrasBundle.putInt(InneractiveMediationDefs.KEY_AGE, age)
    }
    return Pair<Class<out MediationExtrasReceiver>, Bundle>(FyberMediationAdapter::class.java, extrasBundle)
  }

  companion object {
    private const val MUTE_VIDEO = "muteVideo"
    private const val AGE = "age"
  }
}