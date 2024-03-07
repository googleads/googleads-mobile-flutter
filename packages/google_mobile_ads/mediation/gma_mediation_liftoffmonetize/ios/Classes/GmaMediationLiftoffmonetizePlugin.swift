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
    let api : LiftoffPrivacyApi& NSObjectProtocol = GmaMediationLiftoffmonetizePlugin.init(liftoffPrivacy: LiftoffPrivacyImpl()
    LiftoffPrivacyApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setGDPRStatus(optedIn: Bool, consentMessageVersion: String?) {
    VunglePrivacySettings.setGDPRStatus(optedIn)
    VunglePrivacySettings.setGDPRMessageVersion(consentMessageVersion)
  }

  func setCCPAStatus(optedIn: Bool) {
    VunglePrivacySettings.setCCPAStatus(optedIn)
  }
}

protocol LiftoffPrivacyProtocol {
  static func setGDPRStatus(optedIn: Bool)

  static func setGDPRMessageVersion(consentMessageVersion: String?)

  static func setCCPAStatus(optedIn: Bool)
}

class LiftoffPrivacyImpl : LiftoffPrivacyProtocol {
  static func setGDPRStatus(optedIn: Bool) {
    VunglePrivacySettings.setGDPRStatus(optedIn)
  }

  static func setGDPRMessageVersion(consentMessageVersion: String?) {
    VunglePrivacySettings.setGDPRMessageVersion(consentMessageVersion)
  }

  static func setCCPAStatus(optedIn: Bool) {
    VunglePrivacySettings.setCCPAStatus(optedIn)
  }
}
