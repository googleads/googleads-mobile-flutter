// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTMobileAds_Internal.h"

@implementation FLTAdapterStatus
- (instancetype)initWithStatus:(GADAdapterStatus *)status {
  self = [self init];
  if (self) {
    switch (status.state) {
      case GADAdapterInitializationStateNotReady:
        _state = @(FLTAdapterInitializationStateNotReady);
        break;
      case GADAdapterInitializationStateReady:
        _state = @(FLTAdapterInitializationStateReady);
        break;
    }
    _statusDescription = status.description;
    _latency = @(status.latency);
  }
  return self;
}
@end

@implementation FLTInitializationStatus
- (instancetype)initWithStatus:(GADInitializationStatus *)status {
  self = [self init];
  if (self) {
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    for (NSString *name in status.adapterStatusesByClassName.allKeys) {
      FLTAdapterStatus *adapterStatus =
          [[FLTAdapterStatus alloc] initWithStatus:status.adapterStatusesByClassName[name]];
      [newDictionary setValue:adapterStatus forKey:name];
    }
    _adapterStatuses = newDictionary;
  }
  return self;
}
@end
