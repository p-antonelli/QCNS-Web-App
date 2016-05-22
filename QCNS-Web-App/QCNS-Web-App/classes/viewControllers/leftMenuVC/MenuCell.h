//
//  MenuCell.h
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXCells.h"
#import "MenuItem.h"

@interface MenuCell : UITableViewCell <NXCells>

@property (weak, nonatomic, readonly) MenuItem *item;

@end
