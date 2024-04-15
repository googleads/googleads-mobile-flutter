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

  override fun setGDPRConsent(gdprConsent: Boolean) {
    InneractiveAdManager.setGdprConsent(gdprConsent)
  }

  override fun setGDPRConsentString(gdprConsentString: String) {
    InneractiveAdManager.setGdprConsentString(gdprConsentString)
  }

  override fun setUSPrivacyString(usPrivacyString: String) {
    InneractiveAdManager.setUSPrivacyString(usPrivacyString)
  }
}
