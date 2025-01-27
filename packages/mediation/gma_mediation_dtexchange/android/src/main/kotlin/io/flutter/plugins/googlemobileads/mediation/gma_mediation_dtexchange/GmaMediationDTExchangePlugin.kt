package io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange

import com.fyber.inneractive.sdk.external.InneractiveAdManager
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** Manages DTExchangePrivacyApi and implements the needed methods. */
class GmaMediationDTExchangePlugin: FlutterPlugin, DTExchangePrivacyApi {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    DTExchangePrivacyApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    DTExchangePrivacyApi.setUp(binding.binaryMessenger, null)
  }

  override fun setLgpdConsent(wasConsentGiven: Boolean) {
    InneractiveAdManager.setLgpdConsent(wasConsentGiven)
  }

  override fun clearLgpdConsentData() {
    InneractiveAdManager.clearLgpdConsentData()
  }

  override fun setUSPrivacyString(usPrivacyString: String) {
    InneractiveAdManager.setUSPrivacyString(usPrivacyString)
  }

  override fun clearUSPrivacyString() {
    InneractiveAdManager.clearUSPrivacyString()
  }
}
