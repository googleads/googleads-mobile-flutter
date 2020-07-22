#import <Foundation/Foundation.h>
#import "FLTAd_Internal.h"
#import "FLTFirebaseAdMobPlugin.h"

@protocol FLTAd;

// Thread-safe wrapper of NSMutableDictionary.
@interface FLTFirebaseAdMobCollection<KeyType, ObjectType> : NSObject
- (void)setObject:(ObjectType _Nonnull)object forKey:(KeyType<NSCopying> _Nonnull)key;
- (void)removeObjectForKey:(KeyType _Nonnull)key;
- (id _Nullable)objectForKey:(KeyType _Nonnull)key;
- (NSArray<KeyType> *_Nonnull)allKeysForObject:(ObjectType _Nonnull)object;
@end
