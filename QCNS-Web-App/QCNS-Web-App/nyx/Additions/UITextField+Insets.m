//
//  UITextField+Insets.m
//  Axalfred
//
//  Created by Paul Antonelli on 20/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "UITextField+Insets.h"



@implementation UITextField (Insets)

@dynamic edgeInsets;

static const char* textFieldEdgeInsetKey = "textFieldEdgeInsetKey";

// swizzle
+(void)load
{
    Method textRectForBounds = class_getInstanceMethod(self, @selector(textRectForBounds:));
    Method textRectForBoundsCustom = class_getInstanceMethod(self, @selector(textRectForBoundsCustom:));

    Method editingRectForBounds = class_getInstanceMethod(self, @selector(editingRectForBounds:));
    Method editingRectForBoundsCustom = class_getInstanceMethod(self, @selector(editingRectForBoundsCustom:));


    method_exchangeImplementations(textRectForBounds, textRectForBoundsCustom);
    method_exchangeImplementations(editingRectForBounds, editingRectForBoundsCustom);
}

// custom property
- (UIEdgeInsets)edgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &textFieldEdgeInsetKey);
    return [value UIEdgeInsetsValue];
}
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:edgeInsets];
    objc_setAssociatedObject(self, &textFieldEdgeInsetKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}


// swizzled methods
- (CGRect)textRectForBoundsCustom:(CGRect)bounds
{
    return [self textRectForBoundsCustom:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBoundsCustom:(CGRect)bounds
{
    return [self editingRectForBoundsCustom:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}



@end
