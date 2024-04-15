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
      inMobiExtras.ageGroup = ageGroup
    }
    if let educationType = extras["educationType"] as? Int {
      inMobiExtras.educationType = educationType
    }
    if let logLevel = extras["logLevel"] as? Int {
      inMobiExtras.logLevel = logLevel
    }
    if let age = extras["age"] as? Int {
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
    if let city = extras["city"] as? String && let state = extras["state"] as? String && let areaCode = extras["country"] as? String {
      inMobiExtras.setLocationWithCityStateCountry(city, state, country)
    }

    return inMobiExtras
  }
}