//
//  UIImage+tintColor.m
//  Axa_POC
//
//  Created by Paul Antonelli on 19/01/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "UIImage+tintColor.h"

@implementation UIImage (tintColor)

- (UIImage *)imageWithTintColor:(UIColor *)color
{
    return [self imageWithTintColor:color blendMode:kCGBlendModeNormal];
}

- (UIImage *)imageWithTintColor:(UIColor *)color blendMode:(CGBlendMode)blendMode
{
    UIImage *img = self;

    // lets tint the icon - assumes your icons are black
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);

    // draw alpha-mask
    CGContextSetBlendMode(context, blendMode);
    CGContextDrawImage(context, rect, img.CGImage);

    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);

    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

@end
