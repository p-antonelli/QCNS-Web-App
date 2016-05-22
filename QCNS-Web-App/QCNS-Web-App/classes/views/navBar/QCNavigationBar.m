//
//  FZNavigationBar.m
//  Feezly
//
//  Created by Paul Antonelli on 30/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "QCNavigationBar.h"
#import "SlideNavigationController.h"
#import "UIBarButtonItem+Helpers.h"
#import "UIImage+Color.h"
#import "AppController.h"


@interface QCNavigationBar ()

// Sizes
@property (nonatomic, assign) CGFloat delta;

// Bar background
@property (nonatomic, weak) UIImageView *backgroundImageView;

@end


@implementation QCNavigationBar

#pragma mark - Constructors
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Default height
        self.height = kDefaultNavigationBarHeight;
//        self.delta = 1.0f;
        
        // Background image
        self.backgroundColor = [UIColor clearColor];
        [self setBackgroundImage:[UIImage imageNamed:@"costa-navbar"] forBarMetrics:UIBarMetricsDefault];
//        [self setShadowImage:[[UIImage alloc] init]];
        for (UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) rangeOfString:@"BarBackground"].length != 0)
            {
                _backgroundImageView = (UIImageView *)subview;
                break;
            }
        }
        
        // Content mode
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.contentMode = UIViewContentModeBottom;
        _backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    
    return self;
}

- (UIImageView *)logoImageView
{
    @synchronized(self)
    {
        UIImage *logo = [[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView * logoImageView = [[UIImageView alloc] initWithImage:logo];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        logoImageView.frame = CGRectMake(0, 0, 100, kDefaultNavigationBarHeight - 8);
        
        return logoImageView;        
    }
}

- (UIBarButtonItem *)callItem
{
    UIButton *button = [UIBarButtonItem buttonForBarItemWithTitle:[NSString stringForFontAwesomeIcon:FAPhone]
                                                             font:AWESOME_FONT(30)
                                                            color:[UIColor whiteColor]
                                                           target:[AppController sharedInstance]
                                                           action:@selector(callButtonPressed:)];
    
    [button setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    button.clipsToBounds = YES;
    button.tintColor = [UIColor whiteColor];
    CGRect rect = button.frame;
    rect.size = CGSizeMake(kButtonW, kButtonW);
    button.frame = rect;
    button.layer.cornerRadius = kButtonW / 2.0;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.layer.borderWidth = 4;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
- (UIBarButtonItem *)menuItem
{
    UIImage *image = [[UIImage imageNamed:@"menu-button"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 1, 0.5f)];
    button.clipsToBounds = YES;
    button.tintColor = [UIColor whiteColor];
    
    CGRect rect = button.frame;
    rect.size = CGSizeMake(kButtonW, kButtonW);
    button.frame = rect;
    button.layer.cornerRadius = kButtonW / 2.0;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.layer.borderWidth = 4;
    
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}


#pragma mark - Size management
- (CGSize)sizeThatFits:(CGSize)size
{
    size.width = self.frame.size.width;
    size.height = _height;
    
    return size;
}

- (void)setHeight:(CGFloat)height
{
    // Hold height
    _height = height;
    
    // Recompute ratio
    self.delta = height / kDefaultNavigationBarHeight;
    
    // New title position
    [self setTitleVerticalPositionAdjustment:-(height - kDefaultNavigationBarHeight) forBarMetrics:UIBarMetricsDefault];
    
    // Update frame
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = CGRectIntegral(frame);
    
    // Force refresh
    [self layoutSubviews];
}

#pragma mark - Content view
- (void)setContentView:(UIView *)contentView
{
    NSLog(@"contentView : %@", contentView);
    // Remove old content view
    if (_contentView)
    {
        NSLog(@"remove !");
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    
    // Prepare frame
    CGRect frame = contentView.frame;
    frame.origin.y = kDefaultNavigationBarHeight;
    contentView.frame = CGRectIntegral(frame);
    
    // Hold new value
    _contentView = contentView;
    
    // Add it to view
    [self addSubview:contentView];
    
    // Force refresh
    [self layoutSubviews];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews)
    {
        if (subview == _backgroundImageView || subview == _contentView)
        {
//            if (subview == _backgroundImageView)
//            {
//                subview.clipsToBounds = NO;
//            }
            continue;
        }
            

        
        CGRect frame = subview.frame;
        frame.origin.y = (CGRectGetHeight(self.bounds) - frame.size.height) / 2.0;
        subview.frame = CGRectIntegral(frame);
    }
}

@end


