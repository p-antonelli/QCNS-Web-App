//
//  FZNavigationBar.h
//  Feezly
//
//  Created by Paul Antonelli on 30/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultNavigationBarHeight 90
#define kButtonW        44

@interface QCNavigationBar : UINavigationBar

// Properties
@property (nonatomic, assign) CGFloat height;

// Content view
@property (nonatomic, strong) UIView *contentView;

// Logo imageView
@property (nonatomic, readonly, strong) UIImageView *logoImageView;

@property (nonatomic, readonly, strong) UIBarButtonItem *menuItem;
@property (nonatomic, readonly, strong) UIBarButtonItem *callItem;

@end
