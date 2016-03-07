//
//  UILabel+AwesomeFont.h
//  Feezly
//
//  Created by Paul Antonelli on 22/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"

@interface UILabel (AwesomeFont)

- (void)setTextWithFAIcon:(FAIcon)icon pointSize:(CGFloat)pointSize color:(UIColor *)color;

@end
