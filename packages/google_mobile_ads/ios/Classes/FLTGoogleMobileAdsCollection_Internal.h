// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import "FLTAd_Internal.h"
#import "FLTGoogleMobileAdsPlugin.h"

@protocol FLTAd;

// Thread-safe wrapper of NSMutableDictionary.
@interface FLTGoogleMobileAdsCollection<KeyType, ObjectType> : NSObject
- (void)setObject:(ObjectType _Nonnull)object forKey:(KeyType<NSCopying> _Nonnull)key;
- (void)removeObjectForKey:(KeyType _Nonnull)key;
- (id _Nullable)objectForKey:(KeyType _Nonnull)key;
- (NSArray<KeyType> *_Nonnull)allKeysForObject:(ObjectType _Nonnull)object;
@end
