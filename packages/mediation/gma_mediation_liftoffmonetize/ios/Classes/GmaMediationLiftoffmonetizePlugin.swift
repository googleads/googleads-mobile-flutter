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

import Flutter
import UIKit
import VungleAdsSDK

public class GmaMediationLiftoffmonetizePlugin: NSObject, FlutterPlugin, LiftoffPrivacyApi {
  let liftoffPrivacy: LiftoffPrivacyProtocol

  init (liftoffPrivacy: LiftoffPrivacyProtocol) {
    self.liftoffPrivacy = liftoffPrivacy
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : LiftoffPrivacyApi& NSObjectProtocol = GmaMediationLiftoffmonetizePlugin.init(liftoffPrivacy: LiftoffPrivacyImpl())
    LiftoffPrivacyApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setGDPRStatus(optedIn: Bool, consentMessageVersion: String?) {
    liftoffPrivacy.setGDPRStatus(optedIn: optedIn)
    liftoffPrivacy.setGDPRMessageVersion(consentMessageVersion: consentMessageVersion)
  }

  func setCCPAStatus(optedIn: Bool) {
    liftoffPrivacy.setCCPAStatus(optedIn: optedIn)
  }
}

protocol LiftoffPrivacyProtocol {
  func setGDPRStatus(optedIn: Bool)

  func setGDPRMessageVersion(consentMessageVersion: String?)

  func setCCPAStatus(optedIn: Bool)
}

class LiftoffPrivacyImpl : LiftoffPrivacyProtocol {
  func setGDPRStatus(optedIn: Bool) {
    VunglePrivacySettings.setGDPRStatus(optedIn)
  }

  func setGDPRMessageVersion(consentMessageVersion: String?) {
    VunglePrivacySettings.setGDPRMessageVersion(consentMessageVersion ?? "")
  }

  func setCCPAStatus(optedIn: Bool) {
    VunglePrivacySettings.setCCPAStatus(optedIn)
  }
}
