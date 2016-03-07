//
//  SetupAction.m
//  Feezly
//
//  Created by Paul Antonelli on 21/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "SetupAction.h"

#import "AppModel.h"
#import "RequestModel.h"

static NSString *const kActionPath = @"sessions/init";

@interface SetupAction ()

@property (nonatomic, readwrite) SetupResponse *response;

@end

@implementation SetupAction

@synthesize response = _response;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.httpMethod = NXHTTPMethodGet;
    }
    return self;
}

- (NSURL *)actionURL
{
#warning TODO SETUP ACTION PARAMS
    NSDictionary *params = @{@"platform" : @"ios",
                             @"brand" : @"apple",
                             @"model" : [NXDevice modelName],
                             @"device_unique_id" : [NXDevice uniqueID],
                             @"lang" : [[NSLocale preferredLanguages] objectAtIndex:0],
                             @"version" : [NXDevice bundleVersion],
                             @"screen_size" : [NSString stringWithFormat:@"%ldx%ld", (long)MAIN_SCREEN_WIDTH, (long)MAIN_SCREEN_HEIGHT]};
    
    
    return [RequestModel urlWithPath:kActionPath params:params];
}

- (void)handleDownloadedData:(id)data
{
    //    DDLogDebug(@"##### DATA : %@", data);
    [super handleDownloadedData:data];
    
    _response = [[SetupResponse alloc] initWithDict:data error:nil];
    [[AppModel sharedInstance] updateWithSetupAction:self];
}

- (void)handleOperationDidFailWithError:(NSError *)error data:(id)data
{
    DDLogError(@"error : %@, data : %@", error, data);
    [super handleOperationDidFailWithError:error data:data];
    
    _response = [[SetupResponse alloc] initWithDict:data error:nil];
}


@end
