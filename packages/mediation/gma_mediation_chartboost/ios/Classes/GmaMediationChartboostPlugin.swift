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

/// Required to link the iOS dependency of the Chartboost Adapter.
public class GmaMediationChartboostPlugin: NSObject, FlutterPlugin, ChartboostSDKApi {
  let chartboostApi: ChartboostApiProtocol

  init(chartboostApi: ChartboostApiProtocol) {
    self.chartboostApi = chartboostApi
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger = registrar.messenger()
    let api: ChartboostSDKApi & NSObjectProtocol = GmaMediationChartboostPlugin(
      chartboostApi: ChartboostApiImpl())
    ChartboostSDKApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger = registrar.messenger()
    ChartboostSDKApiSetup.setUp(binaryMessenger: messenger, api: nil)
  }

  func setGDPRConsent(userConsent: Bool) {
    chartboostApi.setGDPRConsent(gdprConsent: userConsent)
  }

  func setCCPAConsent(userConsent: Bool) {
    chartboostApi.setCCPAConsent(ccpaConsent: userConsent)
  }
}

protocol ChartboostApiProtocol {
  func setGDPRConsent(gdprConsent: Bool)
  func setCCPAConsent(ccpaConsent: Bool)
}

class ChartboostApiImpl: ChartboostApiProtocol {

  func setGDPRConsent(gdprConsent: Bool) {
    Chartboost.addDataUseConsent(
      CHBDataUseConsent.GDPR(
        gdprConsent
          ? CHBDataUseConsent.GDPR.Consent.behavioral : CHBDataUseConsent.GDPR.Consent.nonbehavioral
      )
    )
  }

  func setCCPAConsent(ccpaConsent: Bool) {
    Chartboost.addDataUseConsent(
      CHBDataUseConsent.CCPA(
        ccpaConsent
          ? CHBDataUseConsent.CCPA.Consent.optInSale : CHBDataUseConsent.CCPA.Consent.optOutSale)
    )
  }
}
