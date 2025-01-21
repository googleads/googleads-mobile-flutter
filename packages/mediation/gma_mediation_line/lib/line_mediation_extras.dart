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

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Extra information sent to the Line adapter through an [AdRequest] or an [AdManagerAdRequest].
class LineMediationExtras implements MediationExtras {
  /// Default constructor with required extras value.
  const LineMediationExtras({required this.enableAdSound});

  final bool enableAdSound;

  @override
  String getAndroidClassName() {
    return 'io.flutter.plugins.googlemobileads.mediation.gma_mediation_line.LineFlutterMediationExtras';
  }

  @override
  String getIOSClassName() {
    return 'LineFlutterMediationExtras';
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic>{'enableAdSound': enableAdSound};
  }
}
