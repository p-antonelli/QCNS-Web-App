//
//  UIImageView+TintImageColor.m
//  Feezly
//
//  Created by Paul Antonelli on 02/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIImageView+ImageTintColor.h"

@implementation UIImageView (ImageTintColor)

- (void)setImageTintColor:(UIColor *)color
{
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tintColor = color;
}
- (UIColor *)imageTintColor
{
    return self.tintColor;
}

@end
