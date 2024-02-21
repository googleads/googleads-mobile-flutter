import UIKit
import XCTest

@testable import gma_mediation_unity

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class GmaMediationUnityPluginTests: XCTestCase {

  func testSetGDPRConsent() {
    let metadata = UnityMetaDataFake()
    
    GmaMediationUnityPlugin(unityMetaData:metadata).setGDPRConsent(gdprConsent: true)

    XCTAssertEqual(metadata.setPair?.0, "gdpr.consent")
    XCTAssertEqual(metadata.setPair?.1 as! Bool, true)
    XCTAssertEqual(metadata.commitCalls, 1)
  }

  func testSetCCPAConsent() {
    let metadata = UnityMetaDataFake()

    GmaMediationUnityPlugin(unityMetaData:metadata).setCCPAConsent(ccpaConsent: true)

    XCTAssertEqual(metadata.setPair?.0, "privacy.consent")
    XCTAssertEqual(metadata.setPair?.1 as! Bool, true)
    XCTAssertEqual(metadata.commitCalls, 1)
  }
}

class UnityMetaDataFake: UnityMetaDataProtocol {
  var setPair: (String, Any)?
  var commitCalls: Int

  init() {
    setPair = nil
    commitCalls = 0
  }

  func set(key: String, value: Any) {
    setPair = (key, value)
  }
  
  func commit() {
    commitCalls += 1
  }
}
