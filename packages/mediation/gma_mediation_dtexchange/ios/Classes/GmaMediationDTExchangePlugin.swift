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
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    DTExchangePrivacyApiSetup.setUp(binaryMessenger: messenger, api: nil)
  }

  func setLgpdConsent(wasConsentGiven: Bool) throws {
    dtExchangeApi.setLgpdConsent(wasConsentGiven: wasConsentGiven)
  }

  func clearLgpdConsentData() throws {
    dtExchangeApi.clearLgpdConsentData()
  }

  func setUSPrivacyString(usPrivacyString: String) throws {
    dtExchangeApi.setUSPrivacyString(usPrivacyString: usPrivacyString)
  }

  func clearUSPrivacyString() throws {
    dtExchangeApi.clearUSPrivacyString()
  }
}

protocol DTExchangePrivacyProtocol {
  func setLgpdConsent(wasConsentGiven: Bool)

  func clearLgpdConsentData()

  func setUSPrivacyString(usPrivacyString: String)

  func clearUSPrivacyString()
}

class DTExchangePrivacyImpl : DTExchangePrivacyProtocol {
  func setLgpdConsent(wasConsentGiven: Bool) {
    IASDKCore.sharedInstance().lgpdConsent = wasConsentGiven ? IALGPDConsentType.given : IALGPDConsentType.denied
  }
  
  func clearLgpdConsentData() {
    IASDKCore.sharedInstance().clearLGPDConsentData()
  }

  func setUSPrivacyString(usPrivacyString: String) {
    IASDKCore.sharedInstance().ccpaString = usPrivacyString
  }

  func clearUSPrivacyString() {
    IASDKCore.sharedInstance().ccpaString = nil
  }
}
