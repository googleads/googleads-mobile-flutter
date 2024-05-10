// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    if (extras["age"] != nil || extras["gender"] != nil || extras["zipCode"] != nil) {
        let userData = IAUserData.build({ builder in
          if let age = self.extras["age"] as? UInt {
            builder.age = age
          }
          if let gender = self.extras["gender"] as? UInt {
            switch gender {
            case 1:
              builder.gender = IAUserGenderType.male
            case 2:
              builder.gender = IAUserGenderType.female
            case 3:
              builder.gender = IAUserGenderType.other
            default:
              builder.gender = IAUserGenderType.unknown
            }
          }
          if let zipCode = self.extras["zipCode"] as? String {
            builder.zipCode = zipCode
          }
        })
        fyberExtras.userData = userData
    }
    return fyberExtras
  }
}
