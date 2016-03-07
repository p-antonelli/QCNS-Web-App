//
//  NotificationPermissionHandler.m
//  Feezly
//
//  Created by Paul Antonelli on 25/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NotificationPermissionHandler.h"

@implementation NotificationPermissionHandler

static const UIUserNotificationType USER_NOTIFICATION_TYPES_REQUIRED = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
static const UIRemoteNotificationType REMOTE_NOTIFICATION_TYPES_REQUIRED = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;

+ (void)checkPermissions;
{
    bool isIOS8OrGreater = [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)];
    if (!isIOS8OrGreater)
    {
        [NotificationPermissionHandler iOS7AndBelowPermissions];
        return;
    }
    
    [NotificationPermissionHandler iOS8AndAbovePermissions];
}

+ (void)iOS7AndBelowPermissions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:REMOTE_NOTIFICATION_TYPES_REQUIRED];
}

+ (void)iOS8AndAbovePermissions;
{
    if ([NotificationPermissionHandler canSendNotifications])
    {
        return;
    }
    
    UIUserNotificationSettings* requestedSettings = [UIUserNotificationSettings settingsForTypes:USER_NOTIFICATION_TYPES_REQUIRED categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:requestedSettings];
}

+ (bool)canSendNotifications;
{
    UIApplication *application = [UIApplication sharedApplication];
    bool isIOS8OrGreater = [application respondsToSelector:@selector(currentUserNotificationSettings)];
    
    if (!isIOS8OrGreater)
    {
        // We actually just don't know if we can, no way to tell programmatically before iOS8
        return true;
    }
    
    UIUserNotificationSettings* notificationSettings = [application currentUserNotificationSettings];
    bool canSendNotifications = notificationSettings.types == USER_NOTIFICATION_TYPES_REQUIRED;
    
    return canSendNotifications;
}

@end
