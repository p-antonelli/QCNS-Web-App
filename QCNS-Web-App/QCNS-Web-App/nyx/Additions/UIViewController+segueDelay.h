//
//  UIViewController+segueDelay.h
//  Axa_POC
//
//  Created by Paul Antonelli on 10/01/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (segueDelay)

- (void)performSegueWithIdentifier:(NSString *)identifier object:(id)object afterDelay:(NSTimeInterval)delay;

@end
