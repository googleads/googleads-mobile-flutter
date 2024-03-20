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

import UIKit
import XCTest

@testable import gma_mediation_unity

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
