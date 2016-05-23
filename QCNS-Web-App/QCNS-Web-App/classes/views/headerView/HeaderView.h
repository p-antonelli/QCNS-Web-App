//
//  HeaderView.h
//  Feezly
//
//  Created by Paul Antonelli on 14/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HeaderViewDelegate;


@interface HeaderView : UITableViewHeaderFooterView

//@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readwrite) UIView *leftView;
@property (nonatomic, readonly) UILabel *titleLabel;
//@property (nonatomic, readonly) UIButton *button;

@property (weak, nonatomic, readwrite) id<HeaderViewDelegate> delegate;

@end



@protocol HeaderViewDelegate <NSObject>

@required
- (void)headerViewButtonPressed:(HeaderView *)headerView;

@end
