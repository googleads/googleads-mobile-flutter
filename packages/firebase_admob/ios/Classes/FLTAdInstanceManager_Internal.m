#import "FLTAdInstanceManager_Internal.h"

@implementation FLTAdInstanceManager {
  FLTFirebaseAdMobCollection<NSNumber *, id<FLTAd>> *_ads;
  FlutterMethodChannel *_channel;
}

- (instancetype _Nonnull)initWithBinaryMessenger:
    (id<FlutterBinaryMessenger> _Nonnull)binaryMessenger {
  self = [super init];
  if (self) {
    _ads = [[FLTFirebaseAdMobCollection alloc] init];
    NSObject<FlutterMethodCodec> *methodCodec = [FlutterStandardMethodCodec
        codecWithReaderWriter:[[FLTFirebaseAdMobReaderWriter alloc] init]];
    _channel = [[FlutterMethodChannel alloc] initWithName:@"plugins.flutter.io/firebase_admob"
                                          binaryMessenger:binaryMessenger
                                                    codec:methodCodec];
  }
  return self;
}

- (id<FLTAd> _Nullable)adFor:(NSNumber *_Nonnull)adId {
  return [_ads objectForKey:adId];
}

- (NSNumber *_Nullable)adIdFor:(id<FLTAd> _Nonnull)ad {
  NSArray<NSNumber *> *keys = [_ads allKeysForObject:ad];

  if (keys.count > 1) {
    NSLog(@"%@Error: Multiple keys for a single ad.",
          NSStringFromClass([FLTAdInstanceManager class]));
  }

  if (keys.count > 0) {
    return keys[0];
  }

  return nil;
}

- (void)loadAd:(id<FLTAd> _Nonnull)ad adId:(NSNumber *_Nonnull)adId {
  [_ads setObject:ad forKey:adId];
  [ad load];
}

- (void)dispose:(id<FLTAd> _Nonnull)ad {
  [_ads removeObjectForKey:[self adIdFor:ad]];
}

- (void)onAdLoaded:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdLoaded"}];
}

- (void)onAdFailedToLoad:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdFailedToLoad"}];
}

- (void)onNativeAdClicked:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdClicked"}];
}

- (void)onNativeAdImpression:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdImpression"}];
}

- (void)onAdOpened:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdOpened"}];
}

- (void)onApplicationExit:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onApplicationExit"}];
}

- (void)onAdClosed:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdClosed"}];
}
@end
