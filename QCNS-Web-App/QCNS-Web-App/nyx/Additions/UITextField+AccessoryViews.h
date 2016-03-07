//
//  UITextField+AccessoryViews.h
//  Axalfred
//
//  Created by Paul Antonelli on 12/05/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (AccessoryViews)

- (void)setLeftViewWithImageNamed:(NSString *)imageName;
- (void)setRightViewWithImageNamed:(NSString *)imageName;

- (void)setLeftPadding:(CGFloat)pading;
- (void)setRightPadding:(CGFloat)pading;


@end
