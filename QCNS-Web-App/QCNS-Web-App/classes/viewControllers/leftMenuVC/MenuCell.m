//
//  MenuCell.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib
{
    // Initialization code
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
    
}

// Returns cell height for cell with given item
+ (CGFloat)cellHeightWithItem:(id)item value:(id)value
{
    return 44;
}



@end
