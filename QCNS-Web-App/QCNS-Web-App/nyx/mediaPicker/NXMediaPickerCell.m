//
//  NXMediaPickerCell.m
//  Feezly
//
//  Created by Paul Antonelli on 25/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NXMediaPickerCell.h"
#import "NXMediaPicker.h"

@implementation NXMediaPickerCell

- (void)awakeFromNib {
    // Initialization code
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
}

// Configure cell with item, value, and eventually setup a delegate
- (void)setItem:(id)item value:(id)value delegate:(id)delegate
{
    
    self.imageView.image = item;
}

// Returns cell size for cell with given item
+ (CGSize)cellSizeWithItem:(id)item value:(id)value
{
    CGFloat h = (MAIN_SCREEN_WIDTH - PADDING) / COLS - PADDING;
    return CGSizeMake(h, h);
}


@end
