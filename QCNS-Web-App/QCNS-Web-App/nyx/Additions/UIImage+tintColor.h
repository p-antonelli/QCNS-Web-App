//
//  UIImage+tintColor.h
//  Axa_POC
//
//  Created by Paul Antonelli on 19/01/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tintColor)

- (UIImage *)imageWithTintColor:(UIColor *)color;
- (UIImage *)imageWithTintColor:(UIColor *)color blendMode:(CGBlendMode)blendMode;

@end
