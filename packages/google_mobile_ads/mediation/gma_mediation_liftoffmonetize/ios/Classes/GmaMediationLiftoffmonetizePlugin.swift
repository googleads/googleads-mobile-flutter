import Flutter
import UIKit
import VungleAdsSDK

public class GmaMediationLiftoffmonetizePlugin: NSObject, FlutterPlugin, LiftoffPrivacyApi {
  let liftoffPrivacy: LiftoffPrivacyProtocol

  init (liftoffPrivacy: LiftoffPrivacyProtocol) {
    self.liftoffPrivacy = liftoffPrivacy
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : LiftoffPrivacyApi& NSObjectProtocol = GmaMediationLiftoffmonetizePlugin.init(liftoffPrivacy: LiftoffPrivacyImpl())
    LiftoffPrivacyApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setGDPRStatus(optedIn: Bool, consentMessageVersion: String?) {
    liftoffPrivacy.setGDPRStatus(optedIn)
    liftoffPrivacy.setGDPRMessageVersion(consentMessageVersion)
  }

  func setCCPAStatus(optedIn: Bool) {
    liftoffPrivacy.setCCPAStatus(optedIn)
  }
}

protocol LiftoffPrivacyProtocol {
  func setGDPRStatus(optedIn: Bool)

  func setGDPRMessageVersion(consentMessageVersion: String?)

  func setCCPAStatus(optedIn: Bool)
}

class LiftoffPrivacyImpl : LiftoffPrivacyProtocol {
  func setGDPRStatus(optedIn: Bool) {
    VunglePrivacySettings.setGDPRStatus(optedIn)
  }

  func setGDPRMessageVersion(consentMessageVersion: String?) {
    VunglePrivacySettings.setGDPRMessageVersion(consentMessageVersion)
  }

  func setCCPAStatus(optedIn: Bool) {
    VunglePrivacySettings.setCCPAStatus(optedIn)
  }
}
