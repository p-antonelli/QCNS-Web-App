//
//  NXMediaPool.m
//  Feezly
//
//  Created by Paul Antonelli on 27/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NXMediaPool.h"
#import "NXDispatcherHelper.h"

@interface NXMediaPool () <AVAssetResourceLoaderDelegate>

// Pool
@property (nonatomic, strong) NSMutableDictionary *pool;

// Default item
@property (nonatomic, strong) AVAsset *defaultAsset;

@end


@implementation NXMediaPool

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    static NXMediaPool *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NXMediaPool alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Constructor
- (id)init
{
    if (self = [super init])
    {
        // Build pool
        self.pool = [NSMutableDictionary dictionary];
        
        // Load default video
        self.defaultAsset = [self loadVideoForKey:nil];
    }
    
    return self;
}

#pragma mark - Accessors
- (AVAsset *)assetForKey:(NSString *)key token:(NSString *)token
{
//    DDLogError(@"key : %@ token : %@", key, token);
    
    AVAsset *asset = [_pool objectForKey:key];
    DDLogError(@"asset : %@", asset);
    if (!asset)
    {
        // Load video
        dispatch_async_on_background_queue(^{
            AVAsset *loadingAsset = [self loadVideoForKey:key];
//            DDLogError(@"LOADING ASSET : %@", loadingAsset);
            
            if (loadingAsset)
            {
                [loadingAsset loadValuesAsynchronouslyForKeys:@[ @"playable", @"tracks", @"duration" ] completionHandler:^{
                    dispatch_after_delay_on_main_queue(0.0f, ^{
                        
//                        NSLog(@"######### ASSET : %@, TOKEN : %@", loadingAsset, token);
                        NSDictionary *dict = @{@"asset" : loadingAsset,
                                               @"token" : token};
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NXMediaPoolAssetLoadedNotificationName
                                                                            object:self
                                                                          userInfo:dict];
                    });
                }];

            }
        });
        
        return _defaultAsset;
    }
    
    return asset;
}

#pragma mark - Video management
- (AVAsset *)loadVideoForKey:(NSString *)key
{
//    NSString *movieFile = [[NSBundle mainBundle] pathForResource:key ofType:@"mp4"];
    NSString *keyTMP = [key copy];
    if (!keyTMP || [keyTMP length] == 0) {
        DDLogError(@"#### CAN'T FIND MOVIE FILE : %@", keyTMP);
        return nil;
    }
    NSURL *videoURL = [[NSURL alloc] initFileURLWithPath:keyTMP];
    AVAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    if (!asset)
    {
        return nil;
    }
    
//    DDLogError(@"asset : %@", asset);
//    DDLogError(@"key : %@", key);
    
    // Hold in pool
    [_pool setObject:asset forKey:keyTMP];
    
    return asset;
}


@end
