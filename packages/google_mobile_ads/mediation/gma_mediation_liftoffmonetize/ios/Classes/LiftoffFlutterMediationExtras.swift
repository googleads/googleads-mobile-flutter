import Foundation
import VungleAdapter

@objc protocol FLTMediationExtras {
  var extras: NSMutableDictionary { get }
  func getMediationExtras() -> GADAdNetworkExtras
}

@objc(LiftoffFlutterMediationExtras)
class LiftoffFlutterMediationExtras : NSObject, FLTMediationExtras {
  var extras: NSMutableDictionary = [:]

  func getMediationExtras() -> GADAdNetworkExtras {
    let liftoffExtras = VungleAdNetworkExtras()
    if let userId = extras["userId"] as? Bool {
      liftoffExtras.userId = userId
    }
    if let nativeAdPosition = extras["nativeAdPosition"] as? Int {
      liftoffExtras.nativeAdOptionPosition = nativeAdPosition
    }
    return liftoffExtras
  }
}
