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

@testable import gma_mediation_chartboost

class GmaMediationChartboostPluginTests: XCTestCase {
  func testSetGDPRConsent() {
    let chartboostApiFake = ChartboostApiFake()

    GmaMediationChartboostPlugin(chartboostApi: chartboostApiFake).setGDPRConsent(gdprConsent: true)

    XCTAssertTrue(chartboostApiFake.gdprConsent)
  }

  func testSetCCPAConsent() {
    let chartboostApiFake = ChartboostApiFake()

    GmaMediationChartboostPlugin(chartboostApi: chartboostApiFake).setCCPAConsent(ccpaConsent: true)

    XCTAssertTrue(chartboostApiFake.ccpaConsent)
  }
}

class ChartboostApiFake: ChartboostApiProtocol {
  var gdprConsent: Bool = false
  var ccpaConsent: Bool = false

  func setGDPRConsent(gdprConsent: Bool) {
    self.gdprConsent = gdprConsent
  }

  func setCCPAConsent(ccpaConsent: Bool) {
    self.ccpaConsent = ccpaConsent
  }
}
