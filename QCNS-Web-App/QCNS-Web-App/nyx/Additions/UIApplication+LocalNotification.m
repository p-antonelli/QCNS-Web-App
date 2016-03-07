//
//  UIApplication+LocalNotification.m
//  Axalfred
//
//  Created by Paul Antonelli on 22/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "UIApplication+LocalNotification.h"

@implementation UIApplication (LocalNotification)


+ (void)showLocalNotificationWithMessage:(NSString *)message badgeNumber:(NSInteger)bagdeNumber
{
//    [[[self class] sharedApplication] cancelAllLocalNotifications];

    UILocalNotification *localNotification = [[UILocalNotification alloc]init];

    //setting the fire dat of the local notification
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];

    //setting the time zone
    localNotification.timeZone = [NSTimeZone defaultTimeZone];

    //setting the message to display
    localNotification.alertBody = [message copy];

    //default notification sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    //displaying the badge number
    localNotification.applicationIconBadgeNumber = bagdeNumber;

    //schedule a notification at its specified time with the help of the app delegate
    [[[self class] sharedApplication] scheduleLocalNotification:localNotification];
}


+ (void)showLocalNotificationWithMessage:(NSString *)msg
{
    [[self class] showLocalNotificationWithMessage:msg badgeNumber:[[UIApplication sharedApplication]applicationIconBadgeNumber]+1];
}


@end
