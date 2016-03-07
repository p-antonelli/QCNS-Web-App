//
//  UIColor+NavigationBar.h
//  Feezly
//
//  Created by Paul Antonelli on 24/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NavigationBar)

- (UIColor *)equivalentNonOpaqueColorWhenInterpolatedWithBackgroundColor:(UIColor *)backgroundColor minimumAlpha:(CGFloat)alpha;

@end
