//
//  NSNotificationCenter+Additions.m
//  NXFramework
//
//  Created by Paul Antonelli on 03/10/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NSNotificationCenter+Additions.h"



@implementation NSNotificationCenter (Additions)

#pragma mark - Threading
- (void)postNotificationOnMainThread:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotification:notification];
    });
}

- (void)postNotificationOnMainThreadNamed:(NSString *)aName object:(id)anObject
{
    [self postNotificationOnMainThreadNamed:aName object:anObject userInfo:nil];
}

- (void)postNotificationOnMainThreadNamed:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    });
}

@end
