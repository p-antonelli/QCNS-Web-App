//
//  UILabel+Insets.m
//  PASDK
//
//  Created by Paul Antonelli on 27/06/2014.
//  Copyright (c) 2014 Paul Antonelli. All rights reserved.
//

#import "UILabel+Insets.h"
#import <objc/runtime.h>

@implementation UILabel (Insets)

@dynamic edgeInsets;

static const char* textFieldEdgeInsetKey = "labelEdgeInsetKey";

// swizzle
+(void)load
{
    Method textRectForBounds = class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:));
    Method textRectForBoundsCustom = class_getInstanceMethod(self, @selector(textRectForBoundsCustom:limitedToNumberOfLines:));

    Method editingRectForBounds = class_getInstanceMethod(self, @selector(drawTextInRect:));
    Method editingRectForBoundsCustom = class_getInstanceMethod(self, @selector(drawTextInRectCustom:));


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
- (CGRect)textRectForBoundsCustom:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    return [self textRectForBoundsCustom:UIEdgeInsetsInsetRect(bounds, self.edgeInsets) limitedToNumberOfLines:numberOfLines];
}

- (void)drawTextInRectCustom:(CGRect)rect
{
    [self drawTextInRectCustom:UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets)];
}




@end
