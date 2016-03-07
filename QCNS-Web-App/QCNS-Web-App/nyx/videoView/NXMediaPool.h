//
//  NXMediaPool.h
//  Feezly
//
//  Created by Paul Antonelli on 27/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

static NSString * const NXMediaPoolAssetLoadedNotificationName = @"NXMediaPoolAssetLoadedNotificationName";

@interface NXMediaPool : NSObject

// Shared instance
+ (instancetype)sharedInstance;

// Get a asset from pool
- (AVAsset *)assetForKey:(NSString *)key token:(NSString *)token;

@end
