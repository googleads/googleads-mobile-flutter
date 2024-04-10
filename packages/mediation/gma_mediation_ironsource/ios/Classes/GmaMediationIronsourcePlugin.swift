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
import IronSource
import UIKit

public class GmaMediationIronsourcePlugin: NSObject, FlutterPlugin, IronSourcePrivacyApi {
  let ironSourceSdk: IronSourceSdkProtocol

  init (ironSourceSdk: IronSourceSdkProtocol) {
    self.ironSourceSdk = ironSourceSdk
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : IronSourcePrivacyApi& NSObjectProtocol = GmaMediationIronsourcePlugin.init(ironSourceSdk: IronSourceSdkImpl())
    IronSourcePrivacyApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setConsent(gdprConsent: Bool) throws {
    ironSourceSdk.setConsent(gdprConsent: gdprConsent)
  }

  func setDoNotSell(doNotSell: Bool) throws {
    ironSourceSdk.setDoNotSell(onKey: "do_not_sell", withValue: doNotSell ? "YES" : "NO")
  }
}

protocol IronSourceSdkProtocol {
  func setConsent(gdprConsent: Bool)

  func setDoNotSell(onKey: String, withValue: String)
}

class IronSourceSdkImpl : IronSourceSdkProtocol {
  func setConsent(gdprConsent: Bool) {
    IronSource.setConsent(gdprConsent)
  }

  func setDoNotSell(onKey: String, withValue: String) {
    IronSource.setMetaDataWithKey(onKey, value: withValue)
  }
}
