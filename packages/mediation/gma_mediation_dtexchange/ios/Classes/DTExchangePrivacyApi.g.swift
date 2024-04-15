// Autogenerated from Pigeon (v18.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol DTExchangePrivacyApi {
  func setGDPRConsent(gdprConsent: Bool) throws
  func setGDPRConsentString(gdprConsentString: String) throws
  func setUSPrivacyString(usPrivacyString: String) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class DTExchangePrivacyApiSetup {
  /// The codec used by DTExchangePrivacyApi.
  /// Sets up an instance of `DTExchangePrivacyApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: DTExchangePrivacyApi?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let setGDPRConsentChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.gma_mediation_dtexchange.DTExchangePrivacyApi.setGDPRConsent\(channelSuffix)", binaryMessenger: binaryMessenger)
    if let api = api {
      setGDPRConsentChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let gdprConsentArg = args[0] as! Bool
        do {
          try api.setGDPRConsent(gdprConsent: gdprConsentArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setGDPRConsentChannel.setMessageHandler(nil)
    }
    let setGDPRConsentStringChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.gma_mediation_dtexchange.DTExchangePrivacyApi.setGDPRConsentString\(channelSuffix)", binaryMessenger: binaryMessenger)
    if let api = api {
      setGDPRConsentStringChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let gdprConsentStringArg = args[0] as! String
        do {
          try api.setGDPRConsentString(gdprConsentString: gdprConsentStringArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setGDPRConsentStringChannel.setMessageHandler(nil)
    }
    let setUSPrivacyStringChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.gma_mediation_dtexchange.DTExchangePrivacyApi.setUSPrivacyString\(channelSuffix)", binaryMessenger: binaryMessenger)
    if let api = api {
      setUSPrivacyStringChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let usPrivacyStringArg = args[0] as! String
        do {
          try api.setUSPrivacyString(usPrivacyString: usPrivacyStringArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setUSPrivacyStringChannel.setMessageHandler(nil)
    }
  }
}
