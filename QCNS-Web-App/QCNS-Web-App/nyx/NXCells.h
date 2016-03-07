//
//  NXCells.h
//  Key4Lead
//
//  Created by Paul Antonelli on 12/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NXCells <NSObject>

@required

// Configure cell with item, value, and eventually setup a delegate
- (void)setItem:(id)item value:(id)value delegate:(id)delegate;

// Returns cell height for cell with given item
+ (CGFloat)cellHeightWithItem:(id)item value:(id)value;

@end


@protocol NXCollectionCells <NSObject>

// Configure cell with item, value, and eventually setup a delegate
- (void)setItem:(id)item value:(id)value delegate:(id)delegate;

// Returns cell size for cell with given item
+ (CGSize)cellSizeWithItem:(id)item value:(id)value;

@end