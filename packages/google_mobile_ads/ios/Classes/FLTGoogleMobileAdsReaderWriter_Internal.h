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

#import <Flutter/Flutter.h>
#import "FLTAd_Internal.h"

@class FLTAdSizeFactory;

// The type values below must be consistent for each platform.
typedef NS_ENUM(NSInteger, FLTAdMobField) {
  FLTAdMobFieldAdSize = 128,
  FLTAdMobFieldAdRequest = 129,
  FLTAdMobFieldRewardItem = 132,
  FLTAdMobFieldLoadAdError = 133,
  FLTAdMobFieldPublisherAdRequest = 134,
  FLTAdMobFieldAdapterInitializationState = 135,
  FLTAdMobFieldAdapterStatus = 136,
  FLTAdMobFieldInitializationStatus = 137,
  FLTAdmobFieldServerSideVerificationOptions = 138,
  FLTAdmobFieldAnchoredAdaptiveBannerAdSize = 139,
  FLTAdmobFieldSmartBannerAdSize = 140,
};

@interface FLTGoogleMobileAdsReaderWriter : FlutterStandardReaderWriter
@property(readonly) FLTAdSizeFactory *_Nonnull adSizeFactory;
- (instancetype _Nonnull)initWithFactory:(FLTAdSizeFactory *_Nonnull)adSizeFactory;
@end

@interface FLTGoogleMobileAdsReader : FlutterStandardReader
@property(readonly) FLTAdSizeFactory *_Nonnull adSizeFactory;
- (instancetype _Nonnull)initWithFactory:(FLTAdSizeFactory *_Nonnull)adSizeFactory
                                    data:(NSData *_Nonnull)data;
@end
