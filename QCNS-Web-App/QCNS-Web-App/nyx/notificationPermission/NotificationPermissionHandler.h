//
//  NotificationPermissionHandler.h
//  Feezly
//
//  Created by Paul Antonelli on 25/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationPermissionHandler : NSObject

+ (void)checkPermissions;
+ (bool)canSendNotifications;

@end