//
//  UICollectionView+CenterCell.m
//  Feezly
//
//  Created by Paul Antonelli on 04/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UICollectionView+CenterCell.h"

@implementation UICollectionView (CenterCell)


- (CGPoint)centerPoint
{
        return CGPointMake(self.center.x + self.contentOffset.x,self.center.y + self.contentOffset.y);
}

- (NSIndexPath *)centerCellIndexPath
{
    DDLogDebug(@"centerPoint : %@", NSStringFromCGPoint([self centerPoint]));
    return [self indexPathForItemAtPoint:[self centerPoint]];
}

@end
