//
//  UIColor+NavigationBar.m
//  Feezly
//
//  Created by Paul Antonelli on 24/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIColor+NavigationBar.h"

@implementation UIColor (NavigationBar)

- (UIColor *)equivalentNonOpaqueColorWhenInterpolatedWithBackgroundColor:(UIColor *)backgroundColor minimumAlpha:(CGFloat)alpha
{
//    NSAssert(self.canProvideRGBComponents, @"Self must be a RGB color to use arithmatic operations");
//    NSAssert(backgroundColor.canProvideRGBComponents, @"Self must be a RGB color to use arithmatic operations");
//    NSAssert(self.alpha == 1, @"Self must be an opaque RGB color");
//    NSAssert(backgroundColor.alpha == 1, @"Background color must be an opaque RGB color");
    
    CGFloat r, g, b, a;
    if (CGColorGetNumberOfComponents(self.CGColor) == 2)
    {
        CGFloat w;
        if (![self getWhite:&w alpha:&a]) return nil;
        r = g = b = w;
    }
    else if (![self getRed:&r green:&g blue:&b alpha:&a]) return nil;
    
    CGFloat r2,g2,b2,a2;
    if (CGColorGetNumberOfComponents(backgroundColor.CGColor) == 2)
    {
        CGFloat w2;
        if (![backgroundColor getWhite:&w2 alpha:&a2]) return nil;
        r2 = g2 = b2 = w2;
    }
    else if (![backgroundColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2]) return nil;
    
    
    CGFloat red,green,blue;
    
    alpha -= 0.01;
    do
    {
        alpha += 0.01;
        red = (r - r2 + r2 * alpha) / alpha;
        green = (g - g2 + g2 * alpha) / alpha;
        blue = (b - b2 + b2 * alpha) / alpha;
    }
    while (alpha < 1 && (red < 0 || green < 0 || blue < 0 || red > 1 || green > 1 || blue > 1));
    
    UIColor *new = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return new;
}

@end
