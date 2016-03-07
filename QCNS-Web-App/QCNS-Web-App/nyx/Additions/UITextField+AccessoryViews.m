//
//  UITextField+AccessoryViews.m
//  Axalfred
//
//  Created by Paul Antonelli on 12/05/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "UITextField+AccessoryViews.h"

@implementation UITextField (AccessoryViews)


- (void)setLeftViewWithImageNamed:(NSString *)imageName
{
    [self setSideViewWithImageName:imageName isLeft:YES];
}
- (void)setRightViewWithImageNamed:(NSString *)imageName
{
    [self setSideViewWithImageName:imageName isLeft:NO];
}

- (void)setLeftPadding:(CGFloat)padding
{
    [self setPadding:padding isLeft:YES];
}
- (void)setRightPadding:(CGFloat)padding
{
    [self setPadding:padding isLeft:NO];
}

#pragma mark - Private Methods

- (void)setPadding:(CGFloat)padding isLeft:(BOOL)isLeft
{
    if (isLeft)
    {
        if (self.leftViewMode == UITextFieldViewModeNever)
        {
            self.leftViewMode = UITextFieldViewModeAlways;
        }
    }
    else
    {
        if (self.rightViewMode == UITextFieldViewModeNever)
        {
            self.rightViewMode = UITextFieldViewModeAlways;
        }
    }

    if (padding == 0) {
        if (isLeft) {
            self.leftView = nil;
        } else {
            self.rightView = nil;
        }

        return;
    }

    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, CGRectGetHeight(self.bounds))];
    if (isLeft) {
        self.leftView = emptyView;
    } else {
        self.rightView = emptyView;
    }
}

- (void)setSideViewWithImageName:(NSString *)imageName isLeft:(BOOL)isLeft
{
    if (!imageName || [imageName length] == 0) {
        DDLogError(@"# Invalid image name : %@", imageName);
        return;
    }
    UIImage *img = [UIImage imageNamed:imageName];
    if (!img) {
        DDLogError(@"# Image not found in bundle : %@", imageName);
        return;
    }

    CGRect rect = CGRectZero;
    rect.size.width = img.size.width * 2;
    rect.size.height = img.size.height;

    UIView *accessoryView = [[UIView alloc] initWithFrame:rect];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    rect = imgView.frame;
    rect.origin.x = (CGRectGetWidth(accessoryView.frame) - rect.size.width) / 2.0f;
    imgView.frame = CGRectIntegral(rect);
    [accessoryView addSubview:imgView];

    if (isLeft)
    {
        if (self.leftViewMode == UITextFieldViewModeNever)
        {
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        self.leftView = accessoryView;
    }
    else
    {
        if (self.rightViewMode == UITextFieldViewModeNever)
        {
            self.rightViewMode = UITextFieldViewModeAlways;
        }
        self.rightView = accessoryView;
    }
}

@end
