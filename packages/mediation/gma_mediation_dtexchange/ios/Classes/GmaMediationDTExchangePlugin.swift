import Flutter
import IASDKCore
import UIKit

/// Manages DTExchangePrivacyApi and implements the needed methods.
public class GmaMediationDTExchangePlugin: NSObject, FlutterPlugin, DTExchangePrivacyApi {
  let dtExchangeApi: DTExchangePrivacyProtocol

  init (dtExchangeApi: DTExchangePrivacyProtocol) {
    self.dtExchangeApi = dtExchangeApi
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : DTExchangePrivacyApi&NSObjectProtocol=GmaMediationDTExchangePlugin.init(dtExchangeApi: DTExchangePrivacyImpl())
    DTExchangePrivacyApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setGDPRConsent(gdprConsent: Bool) throws {
    dtExchangeApi.setGDPRConsent(gdprConsent: gdprConsent)
  }

  func setGDPRConsentString(gdprConsentString: String) throws {
    dtExchangeApi.setGDPRConsentString(gdprConsentString: gdprConsentString)
  }

  func setUSPrivacyString(usPrivacyString: String) throws {
    dtExchangeApi.setUSPrivacyString(usPrivacyString: usPrivacyString)
  }
}

protocol DTExchangePrivacyProtocol {
  func setGDPRConsent(gdprConsent: Bool)

  func setGDPRConsentString(gdprConsentString: String)

  func setUSPrivacyString(usPrivacyString: String)
}

class DTExchangePrivacyImpl : DTExchangePrivacyProtocol {
  func setGDPRConsent(gdprConsent: Bool) {
    IASDKCore.sharedInstance().gdprConsent = gdprConsent ? IAGDPRConsentType.given : IAGDPRConsentType.denied
  }
  
  func setGDPRConsentString(gdprConsentString: String) {
    IASDKCore.sharedInstance().gdprConsentString = gdprConsentString
  }
  
  func setUSPrivacyString(usPrivacyString: String) {
    IASDKCore.sharedInstance().ccpaString = usPrivacyString
  }
}
