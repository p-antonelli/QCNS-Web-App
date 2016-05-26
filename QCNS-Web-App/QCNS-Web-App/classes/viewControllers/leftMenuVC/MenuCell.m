//
//  MenuCell.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "MenuCell.h"
#import "AppModel.h"

#import "UIImage+Color.h"
#import "UIImageView+WebCache.h"


@interface MenuCell ()

@property (weak, nonatomic, readwrite) MenuItem *item;

@property (weak, nonatomic) IBOutlet UIImageView *pictoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MenuCell

- (void)awakeFromNib
{
    // Initialization code
//    self.backgroundColor = COSTA_BLUE_COLOR;
//    self.contentView.backgroundColor = COSTA_BLUE_COLOR;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor darkTextColor];
//    self.pictoImageView.backgroundColor = RANDOM_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - NXCells support

// Configure cell with item, value, and eventually setup a delegate
- (void)setItem:(id)item value:(id)value delegate:(id)delegate
{
    _item = item;
    self.titleLabel.text = [_item.title copy];
    
    NSString *url = [[[AppModel sharedInstance] baseURL] stringByAppendingString:_item.imageURL];
    
//    NSLog(@"image url : |%@|", url);
    [self.pictoImageView sd_setImageWithURL:[NSURL URLWithString:url]
                           placeholderImage:[UIImage imageFromColor:[UIColor clearColor]]
                                    options:SDWebImageRetryFailed];

//    self.pictoImageView.backgroundColor = RANDOM_COLOR;
}

// Returns cell height for cell with given item
+ (CGFloat)cellHeightWithItem:(id)item value:(id)value
{
    return 44;
}



@end
