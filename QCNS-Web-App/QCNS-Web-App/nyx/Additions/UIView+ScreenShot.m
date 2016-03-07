//
//  UIView+ScreenShot.m
//  SNALC
//
//  Created by Paul Antonelli on 09/07/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage *)imageRepresentation
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return ret;
    
}


@end
