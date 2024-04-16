import UIKit
import XCTest

@testable import gma_mediation_dtexchange

class GmaMediationDtexchangePluginTests: XCTestCase {
  func testSetGDPRConsent() {
    let dtExchangeFake = DTExchangePrivacyFake()
    let plugin = GmaMediationDTExchangePlugin.init(dtExchangeApi: dtExchangeFake)

    do {
      try plugin.setGDPRConsent(gdprConsent: true)
    } catch {
      fatalError("testSetGDPRConsent FAILED: setGDPRConsent did not complete.")
    }

    XCTAssertEqual(dtExchangeFake.gdprConsent, true)
  }

  func testSetGDPRConsentString() {
    let dtExchangeFake = DTExchangePrivacyFake()
    let plugin = GmaMediationDTExchangePlugin.init(dtExchangeApi: dtExchangeFake)

    do {
      try plugin.setGDPRConsentString(gdprConsentString: "testString")
    } catch {
      fatalError("testSetGDPRConsentString FAILED: setGDPRConsentString did not complete.")
    }

    XCTAssertEqual(dtExchangeFake.gdprString, "testString")
  }

  func testSetUSPrivacyString() {
    let dtExchangeFake = DTExchangePrivacyFake()
    let plugin = GmaMediationDTExchangePlugin.init(dtExchangeApi: dtExchangeFake)

    do {
      try plugin.setUSPrivacyString(usPrivacyString: "testString")
    } catch {
      fatalError("testSetUSPrivacyString FAILED: setUSPrivacyString did not complete.")
    }

    XCTAssertEqual(dtExchangeFake.usPrivacyString, "testString")
  }
}

class DTExchangePrivacyFake : DTExchangePrivacyProtocol {
  var gdprConsent: Bool
  var gdprString: String
  var usPrivacyString: String

  init() {
    gdprConsent = false
    gdprString = ""
    usPrivacyString = ""
  }

  func setGDPRConsent(gdprConsent: Bool) {
    self.gdprConsent = gdprConsent
  }

  func setGDPRConsentString(gdprConsentString: String) {
    self.gdprString = gdprConsentString
  }

  func setUSPrivacyString(usPrivacyString: String) {
    self.usPrivacyString = usPrivacyString
  }
}
