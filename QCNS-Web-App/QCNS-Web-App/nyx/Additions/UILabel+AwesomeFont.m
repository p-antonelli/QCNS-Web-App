//
//  UILabel+AwesomeFont.m
//  Feezly
//
//  Created by Paul Antonelli on 22/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UILabel+AwesomeFont.h"


@implementation UILabel (AwesomeFont)

- (void)setTextWithFAIcon:(FAIcon)icon pointSize:(CGFloat)pointSize color:(UIColor *)color
{
    self.font = AWESOME_FONT(pointSize);
    self.textColor = color;
    self.text = [NSString stringForFontAwesomeIcon:icon];
}

@end
