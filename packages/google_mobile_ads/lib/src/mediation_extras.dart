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

import 'package:google_mobile_ads/src/ad_containers.dart';

/// Contains information for a particular ad network set by developer.
abstract class MediationExtras {
  /// Fully-qualified name of an Android FlutterMediationExtras class.
  ///
  /// The name of the class must implement the FlutterMediationExtras interface.
  /// The flutter plugin will try to instantiate it via reflection when an
  /// [AdRequest] is created and an instance of this class is assigned to its
  /// mediationExtras.
  String getAndroidClassName();

  /// Name of an iOS class that conforms to the FLTMediationExtras protocol.
  ///
  /// The flutter plugin will try to instantiate it via reflection when an
  /// [AdRequest] is created and an instance of this class is assigned to its
  /// mediationExtras.
  String getIOSClassName();

  /// Key-Value pair to be sent to the host platform to parse.
  ///
  /// The Android or iOS parse classes are responsible to take these values and
  /// parse them to Mediation Extras that the Ad Request can register.
  Map<String, dynamic> getExtras();
}
