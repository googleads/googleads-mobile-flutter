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

@testable import gma_mediation_ironsource

class GmaMediationIronsourcePluginTests: XCTestCase {

  func testSetHasUserConsent() {
    let ironSourceSdkFake = IronSourceSdkFake()
    let plugin = GmaMediationIronsourcePlugin.init(ironSourceSdk: ironSourceSdkFake)

    do {
      try plugin.setConsent(gdprConsent: true)
    } catch {
      fatalError("testSetHasUserConsent FAILED: setConsent did not complete")
    }

    XCTAssertEqual(ironSourceSdkFake.gdprConsent, true)
  }

  func testSetDoNotSellWhenTrue() {
    let ironSourceSdkFake = IronSourceSdkFake()
    let plugin = GmaMediationIronsourcePlugin.init(ironSourceSdk: ironSourceSdkFake)

    do {
      try plugin.setDoNotSell(doNotSell: true)
    } catch {
      fatalError("testSetHasUserConsent FAILED: setConsent did not complete")
    }

    XCTAssertEqual(ironSourceSdkFake.doNotSellKey, "do_not_sell")
    XCTAssertEqual(ironSourceSdkFake.doNotSellValue, "YES")
  }

  func testSetDoNotSellWhenFalse() {
    let ironSourceSdkFake = IronSourceSdkFake()
    let plugin = GmaMediationIronsourcePlugin.init(ironSourceSdk: ironSourceSdkFake)

    do {
      try plugin.setDoNotSell(doNotSell: false)
    } catch {
      fatalError("testSetHasUserConsent FAILED: setConsent did not complete")
    }

    XCTAssertEqual(ironSourceSdkFake.doNotSellKey, "do_not_sell")
    XCTAssertEqual(ironSourceSdkFake.doNotSellValue, "NO")
  }
}

class IronSourceSdkFake: IronSourceSdkProtocol {
  var gdprConsent: Bool
  var doNotSellKey: String
  var doNotSellValue: String

  init() {
    gdprConsent = false
    doNotSellKey = ""
    doNotSellValue = ""
  }

  func setConsent(gdprConsent: Bool) {
    self.gdprConsent = gdprConsent
  }

  func setDoNotSell(onKey: String, withValue: String) {
    self.doNotSellKey = onKey
    self.doNotSellValue = withValue
  }
}
