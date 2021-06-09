// Copyright 2021 Google LLC
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

import 'package:reference/reference.dart';

import 'mobile_ads.dart';
import 'mobile_ads.g.dart';

/// Register channels for mobile ads classes.
class ChannelRegistrar extends $ChannelRegistrar {
  /// Default constructor for [ChannelRegistrar].
  ChannelRegistrar(LibraryImplementations implementations)
      : super(implementations);

  /// Default [ChannelRegistrar] instance.
  ///
  /// Replace this for custom usability.
  static ChannelRegistrar instance =
      ChannelRegistrar(LibraryImplementations(MethodChannelMessenger.instance))
        ..registerHandlers();
}

/// Type channel implementations for mobile ads classes.
///
/// Most implementations are generated.
class LibraryImplementations extends $LibraryImplementations {
  /// Default constructor for [LibraryImplementations].
  LibraryImplementations(TypeChannelMessenger messenger) : super(messenger);

  @override
  $AdapterInitializationStateHandler get handlerAdapterInitializationState =>
      AdapterInitializationStateHandler();

  @override
  InitializationStatusHandler get handlerInitializationStatus =>
      InitializationStatusHandler();

  @override
  AdapterStatusHandler get handlerAdapterStatus => AdapterStatusHandler();
}

class AdapterInitializationStateHandler
    extends $AdapterInitializationStateHandler {
  @override
  AdapterInitializationState $$create(
    TypeChannelMessenger messenger,
    String value,
  ) {
    // ignore: invalid_use_of_visible_for_testing_member
    return AdapterInitializationState(value);
  }
}

class InitializationStatusHandler extends $InitializationStatusHandler {
  @override
  InitializationStatus $$create(
    TypeChannelMessenger messenger,
    covariant Map adapterStatuses,
  ) {
    return InitializationStatus(adapterStatuses.cast<String, AdapterStatus>());
  }
}

class AdapterStatusHandler extends $AdapterStatusHandler {
  @override
  AdapterStatus $$create(
    TypeChannelMessenger messenger,
    covariant AdapterInitializationState state,
    String description,
    double latency,
  ) {
    return AdapterStatus(state, description, latency);
  }
}
