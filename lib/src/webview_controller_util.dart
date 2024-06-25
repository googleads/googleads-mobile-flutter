// Copyright 2023 Google LLC
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

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// Util class for `WebViewController`.
class WebViewControllerUtil {
  /// Default constructor.
  const WebViewControllerUtil();

  /// Returns the identifier for the underlying webview.
  int webViewIdentifier(WebViewController controller) {
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      return (controller.platform as AndroidWebViewController)
          .webViewIdentifier;
    } else if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return (controller.platform as WebKitWebViewController).webViewIdentifier;
    } else {
      throw UnsupportedError('This method only supports Android and iOS.');
    }
  }
}
