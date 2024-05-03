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
import UnityAds

/// Manages UnityPrivacyApi and implements the needed methods.
public class GmaMediationUnityPlugin: NSObject, FlutterPlugin, UnityPrivacyApi {
  let uadsMedatada: UnityMetaDataProtocol

  init (unityMetaData: UnityMetaDataProtocol) {
    self.uadsMedatada = unityMetaData
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : UnityPrivacyApi & NSObjectProtocol = GmaMediationUnityPlugin.init(unityMetaData: UnityMetaDataImpl())
    UnityPrivacyApiSetup.setUp(binaryMessenger: messenger, api: api)
  }
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    UnityPrivacyApiSetup.setUp(binaryMessenger: messenger, api: nil)
  }
  func setGDPRConsent(gdprConsent: Bool) {
    uadsMedatada.set(key: "gdpr.consent", value: gdprConsent)
    uadsMedatada.commit()
    print("GDPR Test")
  }
  func setCCPAConsent(ccpaConsent: Bool) {
    uadsMedatada.set(key: "privacy.consent", value: ccpaConsent)
    uadsMedatada.commit()
  }
}

protocol UnityMetaDataProtocol {
  func set(key: String, value: Any)

  func commit()
}

class UnityMetaDataImpl : UnityMetaDataProtocol {
  let instance: UADSMetaData
  init() {
    self.instance = UADSMetaData()
  }
  func set(key: String, value: Any) {
    instance.set(key, value: value)
  }
  func commit() {
    instance.commit()
  }
}
