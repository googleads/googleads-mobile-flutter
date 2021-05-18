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

import 'ad_containers_new.dart';
import 'ad_containers_new.g.dart';

class ChannelRegistrar extends $ChannelRegistrar {
  ChannelRegistrar($LibraryImplementations implementations)
      : super(implementations);

  static ChannelRegistrar instance = ChannelRegistrar(
      $LibraryImplementations(MethodChannelMessenger.instance));
}

class LibraryImplementations extends $LibraryImplementations {
  LibraryImplementations(TypeChannelMessenger messenger) : super(messenger);

  @override
  $RewardItemHandler get rewardItemHandler => RewardItemHandler();

  @override
  $LoadAdErrorHandler get loadAdErrorHandler => LoadAdErrorHandler();

  @override
  $AdSizeHandler get adSizeHandler => AdSizeHandler();
}

class RewardItemHandler extends $RewardItemHandler {
  @override
  $RewardItem onCreate(
    TypeChannelMessenger messenger,
    $RewardItemCreationArgs args,
  ) {
    return RewardItem(args.amount, args.type);
  }
}

class LoadAdErrorHandler extends $LoadAdErrorHandler {
  @override
  $LoadAdError onCreate(
    TypeChannelMessenger messenger,
    $LoadAdErrorCreationArgs args,
  ) {
    return LoadAdError(args.code, args.domain, args.message);
  }
}

class AdSizeHandler extends $AdSizeHandler {
  @override
  $AdSize onCreate(TypeChannelMessenger messenger, $AdSizeCreationArgs args) {
    return AdSize(width: args.width, height: args.height, creator: false);
  }
}
