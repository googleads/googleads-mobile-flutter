package io.flutter.plugins.googlemobileads.mediation.gma_mediation_liftoffmonetize

import android.os.Bundle
import androidx.core.os.bundleOf
import com.google.ads.mediation.vungle.VungleConstants
import com.google.android.gms.ads.mediation.MediationExtrasReceiver
import com.vungle.ads.AdConfig
import com.vungle.mediation.VungleAdapter
import com.vungle.mediation.VungleInterstitialAdapter

class LiftoffFlutterMediationExtras : FlutterMediationExtras {
  private var flutterExtras: Map<String, Any>? = null

  override fun setMediationExtras(extras: MutableMap<String, Any>?) {
    flutterExtras = extras
  }

  override fun getMediationExtras(): Pair<Class<out MediationExtrasReceiver>, Bundle> {
    val extrasMap = flutterExtras
      ?: return Pair<Class<out MediationExtrasReceiver>, Bundle>(
        MediationExtrasReceiver::class.java,
        bundleOf()
      )

    val classType: Class<out MediationExtrasReceiver> =
      if (extrasMap.containsKey(IS_FOR_INTERSTITIAL) && extrasMap[USER_ID] is String) {
        VungleInterstitialAdapter::class.java
      } else {
        VungleAdapter::class.java
      }

    val extrasBundle = bundleOf()
    if (extrasMap.containsKey(USER_ID) && extrasMap[USER_ID] is String) {
      val userId = extrasMap[USER_ID] as String
      extrasBundle.putString(VungleConstants.KEY_USER_ID, userId)
    }

    if (extrasMap.containsKey(ORIENTATION_KEY) && extrasMap[ORIENTATION_KEY] is Int) {
      when(extrasMap[ORIENTATION_KEY]){
        0 -> extrasBundle.putInt(VungleConstants.KEY_ORIENTATION, AdConfig.PORTRAIT)
        1 -> extrasBundle.putInt(VungleConstants.KEY_ORIENTATION, AdConfig.LANDSCAPE)
        else -> extrasBundle.putInt(VungleConstants.KEY_ORIENTATION, AdConfig.AUTO_ROTATE)
      }
    }
    return Pair(classType, extrasBundle)
  }

  companion object {
    private const val USER_ID = "userId"
    private const val ORIENTATION_KEY = "orientation"
    private const val IS_FOR_INTERSTITIAL = "isForInterstitial"
  }
}