//
//  NSNotificationCenter+Additions.h
//  NXFramework
//
//  Created by Paul Antonelli on 03/10/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSNotificationCenter (Additions)

// Dispatches the notification on main thread instead of the current thread
- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadNamed:(NSString *)aName object:(id)anObject;
- (void)postNotificationOnMainThreadNamed:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end
