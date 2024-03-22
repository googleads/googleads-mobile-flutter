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

@testable import gma_mediation_applovin

class GmaMediationApplovinPluginTests: XCTestCase {

  func testSetHasUserConsent() {
    let appLovinSdkFake = ALSdkFake()

    GmaMediationApplovinPlugin(applovinSdk: appLovinSdkFake).setHasUserConsent(hasUserConsent: true)

    XCTAssertEqual(appLovinSdkFake.hasUserConsent, true)
  }

  func testSetIsAgeRestrictedUser() {
    let appLovinSdkFake = ALSdkFake()

    GmaMediationApplovinPlugin(applovinSdk: appLovinSdkFake).setIsAgeRestrictedUser(isAgeRestrictedUser: true)

    XCTAssertEqual(appLovinSdkFake.isAgeRestrictedUser, true)
  }

  func testSetDoNotSell() {
    let appLovinSdkFake = ALSdkFake()

    GmaMediationApplovinPlugin(applovinSdk: appLovinSdkFake).setDoNotSell(doNotSell: true)

    XCTAssertEqual(appLovinSdkFake.doNotSell, true)
  }

  func testInitializeSdk() {
    let appLovinSdkFake = ALSdkFake()

    GmaMediationApplovinPlugin(applovinSdk: appLovinSdkFake).initializeSdk(sdkKey: "testKey")

    XCTAssertEqual(appLovinSdkFake.initializeSdkCalls, 1)
  }
}

class ALSdkFake: ALSdkProtocol {
  var hasUserConsent: Bool
  var isAgeRestrictedUser: Bool
  var doNotSell: Bool
  var initializeSdkCalls: Int

  init() {
    hasUserConsent = false
    isAgeRestrictedUser = false
    doNotSell = false
    initializeSdkCalls = 0
  }

  func setHasUserConsent(hasUserConsent: Bool) {
    self.hasUserConsent = hasUserConsent
  }

  func setIsAgeRestrictedUser(isAgeRestrictedUser: Bool) {
    self.isAgeRestrictedUser = isAgeRestrictedUser
  }

  func setDoNotSell(doNotSell: Bool) {
    self.doNotSell = doNotSell
  }

  func initializeSdk(sdkKey: String) {
    initializeSdkCalls += 1
  }
}
