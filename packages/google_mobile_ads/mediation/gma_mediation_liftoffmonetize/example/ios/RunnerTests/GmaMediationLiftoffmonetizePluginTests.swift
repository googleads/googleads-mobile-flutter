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

@testable import gma_mediation_liftoffmonetize

class GmaMediationLiftoffmonetizePluginTests: XCTestCase {
  func testSetGDPRStatus() {
    let liftoffPrivacyFake = LiftoffPrivacyFake()

    GmaMediationLiftoffmonetizePlugin(liftoffPrivacy: liftoffPrivacyFake).setGDPRStatus(optedIn: true, consentMessageVersion: "testConsentVersion")

    XCTAssertEqual(liftoffPrivacyFake.gdprOptedIn, true)
    XCTAssertEqual(liftoffPrivacyFake.gdprMessageVersion, "testConsentVersion")
  }

  func testSetCCPAStatus() {
    let liftoffPrivacyFake = LiftoffPrivacyFake()

    GmaMediationLiftoffmonetizePlugin(liftoffPrivacy: liftoffPrivacyFake).setCCPAStatus(optedIn: true)

    XCTAssertEqual(liftoffPrivacyFake.ccpaOptedIn, true)
  }
}

class LiftoffPrivacyFake : LiftoffPrivacyProtocol {
  var gdprOptedIn: Bool = false
  var gdprMessageVersion: String? = ""
  var ccpaOptedIn: Bool = false

  func setGDPRStatus(optedIn: Bool) {
    self.gdprOptedIn = optedIn
  }

  func setGDPRMessageVersion(consentMessageVersion: String?) {
    self.gdprMessageVersion = consentMessageVersion
  }

  func setCCPAStatus(optedIn: Bool) {
    self.ccpaOptedIn = optedIn
  }
}
