//
//  NXHTTPJSONAction.m
//  NXFramework
//
//  Created by Paul Antonelli on 06/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXHTTPJSONAction.h"



@implementation NXHTTPJSONAction

#pragma mark - Configuration
- (void)prepareOperation
{
    [super prepareOperation];
    
    // Update operation to use JSON as serializer
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
}

@end
