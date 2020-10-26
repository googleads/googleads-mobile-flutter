// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Represent `GADAdapterInitializationState` for the Firebase AdMob Plugin.
 *
 * Used to help serialize and pass  `GADAdapterInitializationState`  to Dart.
 */
typedef NS_ENUM(NSUInteger, FLTAdapterInitializationState) {
  FLTAdapterInitializationStateNotReady,
  FLTAdapterInitializationStateReady,
};

/**
 * Wrapper around `GADAdapterStatus` for the Firebase AdMob Plugin.
 *
 * Used to help serialize and pass  `GADAdapterStatus`  to Dart.
 */
@interface FLTAdapterStatus : NSObject
@property NSNumber *state;
@property NSString *statusDescription;
@property NSNumber *latency;
- (instancetype)initWithStatus:(GADAdapterStatus *)status;
@end

/**
 * Wrapper around `GADInitializationStatus` for the Firebase AdMob Plugin.
 *
 * Used to help serialize and pass  `GADInitializationStatus`  to Dart.
 */
@interface FLTInitializationStatus : NSObject
@property NSDictionary<NSString *, FLTAdapterStatus *> *adapterStatuses;
- (instancetype)initWithStatus:(GADInitializationStatus *)status;
@end

NS_ASSUME_NONNULL_END
