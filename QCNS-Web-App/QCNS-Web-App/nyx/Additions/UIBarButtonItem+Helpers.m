//
//  UIBarButtonItem+Helpers.m
//  Feezly
//
//  Created by Paul Antonelli on 29/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIBarButtonItem+Helpers.h"

@implementation UIBarButtonItem (Helpers)

+ (UIButton *)buttonForBarItemWithTitle:(NSString *)title
                                   font:(UIFont *)font
                                  color:(UIColor *)color
                                 target:(id)target
                                 action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = font;
    button.titleLabel.textColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    
    if (target && action)
    {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [button sizeToFit];
    
    return button;
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                       font:(UIFont *)font
                                      color:(UIColor *)color
                                     target:(id)target
                                     action:(SEL)action
{
    UIButton *button = [[self class] buttonForBarItemWithTitle:title font:font color:color target:target action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}



@end
