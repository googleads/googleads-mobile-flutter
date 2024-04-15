import Foundation
import DTExchangeAdapter

@objc protocol FLTMediationExtras {
  var extras: NSMutableDictionary { get }
  func getMediationExtras() -> GADAdNetworkExtras
}

@objc(DTExchangeFlutterMediationExtras)
class DTExchangeFlutterMediationExtras : NSObject, FLTMediationExtras {
  var extras: NSMutableDictionary = [:]

  func getMediationExtras() -> GADAdNetworkExtras {
    let fyberExtras = GADMAdapterFyberExtras()
    if let muteVideo = extras["muteVideo"] as? Bool {
      fyberExtras.muteAudio = muteVideo
    }
//     if let userData = extras["userData"] as ? UserData {
//       fyberExtras.userData = userData.asIAUserData()
//     }
    return fyberExtras
  }
}
