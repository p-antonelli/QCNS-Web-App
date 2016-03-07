//
//  UIApplication+HideKeyboard.m
//  Feezly
//
//  Created by Paul Antonelli on 29/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIApplication+HideKeyboard.h"

@implementation UIApplication (HideKeyboard)

+ (void)hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
