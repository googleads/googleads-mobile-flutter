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

import AppLovinSDK
import Flutter
import UIKit

public class GmaMediationApplovinPlugin: NSObject, FlutterPlugin, AppLovinSDKApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : AppLovinSDKApi& NSObjectProtocol = GmaMediationApplovinPlugin.init()
    AppLovinSDKApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setHasUserConsent(hasUserConsent: Bool) {
    ALPrivacySettings.setHasUserConsent(hasUserConsent)
  }
  func setIsAgeRestrictedUser(isAgeRestrictedUser: Bool) {
    ALPrivacySettings.setIsAgeRestrictedUser(isAgeRestrictedUser)
  }
  func setDoNotSell(doNotSell: Bool) {
    ALPrivacySettings.setDoNotSell(doNotSell)
  }
  func initializeSdk(sdkKey: String) {
    let sdk = ALSdk.shared(withKey: sdkKey)
    sdk?.initializeSdk()
  }
}
