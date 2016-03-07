//
//  NSString+AstroSignGlyph.h
//  Feezly
//
//  Created by Paul Antonelli on 13/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AstroSignGlyph)

- (NSAttributedString *)attributedStringByAddingGlyphWithSignString:(NSString *)signString
                                                           fontSize:(CGFloat)fontSize
                                                              color:(UIColor *)color;

+ (NSAttributedString *)attributedStringWithGlyphSignString:(NSString *)signString fontSize:(CGFloat)fontSize color:(UIColor *)color;


@end
