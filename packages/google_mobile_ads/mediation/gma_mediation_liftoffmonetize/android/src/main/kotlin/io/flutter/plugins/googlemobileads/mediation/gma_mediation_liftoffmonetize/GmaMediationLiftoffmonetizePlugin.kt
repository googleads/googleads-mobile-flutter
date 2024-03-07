package io.flutter.plugins.googlemobileads.mediation.gma_mediation_liftoffmonetize

import com.vungle.ads.VunglePrivacySettings
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** GmaMediationLiftoffmonetizePlugin */
class GmaMediationLiftoffmonetizePlugin: FlutterPlugin, LiftoffPrivacyApi {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    LiftoffPrivacyApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    LiftoffPrivacyApi.setUp(binding.binaryMessenger, null)
  }

  override fun setGDPRStatus(optedIn: Boolean, consentMessageVersion: String?) {
    VunglePrivacySettings.setGDPRStatus(optedIn, consentMessageVersion)
  }

  override fun setCCPAStatus(optedIn: Boolean) {
    VunglePrivacySettings.setCCPAStatus(optedIn)
  }
}
