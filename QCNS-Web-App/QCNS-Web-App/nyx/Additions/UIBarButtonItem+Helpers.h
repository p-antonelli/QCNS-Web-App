//
//  UIBarButtonItem+Helpers.h
//  Feezly
//
//  Created by Paul Antonelli on 29/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Helpers)

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                       font:(UIFont *)font
                                      color:(UIColor *)color
                                     target:(id)target
                                     action:(SEL)action;

@end
