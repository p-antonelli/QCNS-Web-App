//
//  HeaderView.m
//  Feezly
//
//  Created by Paul Antonelli on 14/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) UIButton *button;

@end

@implementation HeaderView

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titleLabel];

        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.textColor = FEEZLY_BLUE_COLOR;
    
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.leftView)
    {
        CGRect rect = self.leftView.frame;
        
        rect.size = CGSizeMake(40, 40);
        rect.origin.x = 20;
        rect.origin.y = CGRectGetMaxY(self.contentView.frame) - rect.size.height;
        self.leftView.frame = CGRectIntegral(rect);
    }
    
    CGRect rect =  self.titleLabel.frame;
    rect.origin.x = _leftView ? CGRectGetMaxX(_leftView.frame) + 5 : 20.0f;
    rect.origin.y = CGRectGetMaxY(self.contentView.frame) - rect.size.height;
    self.titleLabel.frame = CGRectIntegral(rect);
    
    if (!self.button)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44);
        [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        self.button.userInteractionEnabled = YES;        
    }
}

- (void)setLeftView:(UIView *)leftView
{
    if (_leftView)
    {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    
    if (leftView)
    {
        _leftView = leftView;
        [self.contentView addSubview:_leftView];
        [self setNeedsLayout];
    }
}

#pragma mark - Private

- (void)buttonPressed:(id)sender
{
    DDLogInfo(@"");
    [self setNeedsLayout];
    if ([_delegate respondsToSelector:@selector(headerViewButtonPressed:)])
    {
        [_delegate headerViewButtonPressed:self];
    }
}

@end
