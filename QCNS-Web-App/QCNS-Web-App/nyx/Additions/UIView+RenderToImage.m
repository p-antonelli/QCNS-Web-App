//
//  UIView+RenderToImage.m
//  CheckIn
//
//  Created by Paul Antonelli on 27/02/2015.
//  Copyright (c) 2015 Paul Antonelli. All rights reserved.
//

#import "UIView+RenderToImage.h"
@import QuartzCore;

@implementation UIView (RenderToImage)

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}


@end
