//
//  UIApplication+LocalNotification.h
//  Axalfred
//
//  Created by Paul Antonelli on 22/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LocalNotification)

+ (void)showLocalNotificationWithMessage:(NSString *)message;
+ (void)showLocalNotificationWithMessage:(NSString *)message badgeNumber:(NSInteger)bagdeNumber;

@end
