//
//  RequestController.m
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "RequestController.h"

#import "NXHTTPClient.h"

#import "AppModel.h"

#import "NSDate+ISO8601.h"

@implementation RequestController

#pragma mark - Public

+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initInternal];
    });
}

- (void)processSetupAction
{
    DDLogInfo(@"");
    SetupAction *action = [[SetupAction alloc] init];
    [[NXHTTPClient sharedInstance] addNewHTTPAction:action];    
}


#pragma mark - Private

- (id)initInternal
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


@end
