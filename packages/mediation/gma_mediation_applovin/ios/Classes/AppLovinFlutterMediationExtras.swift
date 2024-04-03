import Foundation
import AppLovinAdapter

@objc protocol FLTMediationExtras {
  var extras: NSMutableDictionary { get }
  func getMediationExtras() -> GADAdNetworkExtras
}

@objc(AppLovinFlutterMediationExtras)
class AppLovinFlutterMediationExtras : NSObject, FLTMediationExtras {
  var extras: NSMutableDictionary = [:]

  func getMediationExtras() -> GADAdNetworkExtras {
    let appLovinExtras = GADMAdapterAppLovinExtras()
    if let muteAudio = extras["isMuted"] as? Bool {
      appLovinExtras.muteAudio = muteAudio
    }
    return appLovinExtras
  }
}