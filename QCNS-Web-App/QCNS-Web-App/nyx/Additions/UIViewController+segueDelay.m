//
//  UIViewController+segueDelay.m
//  Axa_POC
//
//  Created by Paul Antonelli on 10/01/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "UIViewController+segueDelay.h"

@implementation UIViewController (segueDelay)

- (void)performSegueWithIdentifier:(NSString *)identifier object:(id)object afterDelay:(NSTimeInterval)delay
{
    double delayInSeconds = delay;
    if (delayInSeconds > 0.0f) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self performSegueWithIdentifier:identifier sender:object];
        });
    } else {
        [self performSegueWithIdentifier:identifier sender:object];
    }
}


@end
