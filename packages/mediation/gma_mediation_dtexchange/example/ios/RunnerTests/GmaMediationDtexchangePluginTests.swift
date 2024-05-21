import UIKit
import XCTest

@testable import gma_mediation_dtexchange

class GmaMediationDtexchangePluginTests: XCTestCase {
  func testSetLgpdConsent() {
    let dtExchangeFake = DTExchangePrivacyFake()
    let plugin = GmaMediationDTExchangePlugin.init(dtExchangeApi: dtExchangeFake)

    do {
      try plugin.setLgpdConsent(wasConsentGiven: true)
    } catch {
      fatalError("testSetLgpdConsent FAILED: setLgpdConsent did not complete.")
    }

    XCTAssertEqual(dtExchangeFake.lgdpConsent, true)
  }

  func testClearLgpdConsentData() {
    let dtExchangeFake = DTExchangePrivacyFake()
    let plugin = GmaMediationDTExchangePlugin.init(dtExchangeApi: dtExchangeFake)

    do {
      try plugin.clearLgpdConsentData()
    } catch {
      fatalError("testClearLgpdConsentData FAILED: clearLgpdConsentData did not complete.")
    }

    XCTAssertEqual(dtExchangeFake.clearLgdp, 1)
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

  func testClearUSPrivacyString() {
    let dtExchangeFake = DTExchangePrivacyFake()
    let plugin = GmaMediationDTExchangePlugin.init(dtExchangeApi: dtExchangeFake)

    do {
      try plugin.clearUSPrivacyString()
    } catch {
      fatalError("testClearUSPrivacyString FAILED: clearUSPrivacyString did not complete.")
    }

    XCTAssertEqual(dtExchangeFake.clearUSPrivacy, 1)
  }
}

class DTExchangePrivacyFake : DTExchangePrivacyProtocol {
  var lgdpConsent: Bool
  var clearLgdp: Int
  var usPrivacyString: String
  var clearUSPrivacy: Int

  init() {
    lgdpConsent = false
    clearLgdp = 0
    usPrivacyString = ""
    clearUSPrivacy = 0
  }

  func setLgpdConsent(wasConsentGiven: Bool) {
    self.lgdpConsent = wasConsentGiven
  }

  func clearLgpdConsentData() {
    self.clearLgdp += 1
  }

  func setUSPrivacyString(usPrivacyString: String) {
    self.usPrivacyString = usPrivacyString
  }

  func clearUSPrivacyString() {
    self.clearUSPrivacy += 1
  }
}
