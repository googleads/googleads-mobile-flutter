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

/// Manages AppLovinSDKApi and implements the needed methods.
public class GmaMediationApplovinPlugin: NSObject, FlutterPlugin, AppLovinSDKApi {
  let applovinSdk: ALSdkProtocol

  init (applovinSdk: ALSdkProtocol) {
    self.applovinSdk = applovinSdk
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : AppLovinSDKApi& NSObjectProtocol = GmaMediationApplovinPlugin.init(applovinSdk: ALSdkImpl())
    AppLovinSDKApiSetup.setUp(binaryMessenger: messenger, api: api)
  }
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    AppLovinSDKApiSetup.setUp(binaryMessenger: messenger, api: nil)
  }

  func setHasUserConsent(hasUserConsent: Bool) {
    applovinSdk.setHasUserConsent(hasUserConsent: hasUserConsent)
  }
  func setIsAgeRestrictedUser(isAgeRestrictedUser: Bool) {
    applovinSdk.setIsAgeRestrictedUser(isAgeRestrictedUser: isAgeRestrictedUser)
  }
  func setDoNotSell(doNotSell: Bool) {
    applovinSdk.setDoNotSell(doNotSell: doNotSell)
  }
  func initializeSdk(sdkKey: String) {
    applovinSdk.initializeSdk(sdkKey: sdkKey)
  }
}

protocol ALSdkProtocol {
  func setHasUserConsent(hasUserConsent: Bool)

  func setIsAgeRestrictedUser(isAgeRestrictedUser: Bool)

  func setDoNotSell(doNotSell: Bool)

  func initializeSdk(sdkKey: String)
}

class ALSdkImpl : ALSdkProtocol {
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
