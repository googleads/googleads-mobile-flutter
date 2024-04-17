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
import InMobiAdapter

@objc protocol FLTMediationExtras {
  var extras: NSMutableDictionary { get }
  func getMediationExtras() -> GADAdNetworkExtras
}

@objc(InMobiFlutterMediationExtras)
class InMobiFlutterMediationExtras : NSObject, FLTMediationExtras {
  var extras: NSMutableDictionary = [:]

  func getMediationExtras() -> GADAdNetworkExtras {
    let inMobiExtras = GADInMobiExtras()
    if let ageGroup = extras["ageGroup"] as? Int {
      switch ageGroup {
      case 0:
        inMobiExtras.ageGroup = IMSDKAgeGroup.below18
      case 1:
        inMobiExtras.ageGroup = IMSDKAgeGroup.between18And24
      case 2:
        inMobiExtras.ageGroup = IMSDKAgeGroup.between25And29
      case 3:
        inMobiExtras.ageGroup = IMSDKAgeGroup.between30And34
      case 4:
        inMobiExtras.ageGroup = IMSDKAgeGroup.between35And44
      case 5:
        inMobiExtras.ageGroup = IMSDKAgeGroup.between45And54
      case 6:
        inMobiExtras.ageGroup = IMSDKAgeGroup.between55And65
      case 7:
        inMobiExtras.ageGroup = IMSDKAgeGroup.above65
      default:
        break;
      }
    }
    if let educationType = extras["educationType"] as? Int {
      switch educationType {
      case 0:
        inMobiExtras.educationType = IMSDKEducation.highSchoolOrLess
      case 1:
        inMobiExtras.educationType = IMSDKEducation.collageOrGraduate
      case 2:
        inMobiExtras.educationType = IMSDKEducation.postGraduateOrAbove
      default:
        break;
      }
    }
    if let logLevel = extras["logLevel"] as? Int {
      switch logLevel {
      case 0:
        inMobiExtras.logLevel = IMSDKLogLevel.none
      case 1:
        inMobiExtras.logLevel = IMSDKLogLevel.debug
      case 2:
        inMobiExtras.logLevel = IMSDKLogLevel.error
      default:
        break;
      }

    }
    if let age = extras["age"] as? UInt {
      inMobiExtras.age = age
    }
    if let yearOfBirth = extras["yearOfBirth"] as? Int {
      inMobiExtras.yearOfBirth = yearOfBirth
    }
    if let postalCode = extras["postalCode"] as? String {
      inMobiExtras.postalCode = postalCode
    }
    if let areaCode = extras["areaCode"] as? String {
      inMobiExtras.areaCode = areaCode
    }
    if let language = extras["language"] as? String {
      inMobiExtras.language = language
    }
    if let keywords = extras["keywords"] as? String {
      inMobiExtras.keywords = keywords
    }
    if let interests = extras["interests"] as? String {
      inMobiExtras.interests = interests
    }
    let city = extras["city"] as? String
    let state = extras["state"] as? String
    let country = extras["country"] as? String
    if city != nil && state != nil && country != nil {
      inMobiExtras.setLocationWithCity(city, state: state, country: country)
    }

    return inMobiExtras
  }
}
