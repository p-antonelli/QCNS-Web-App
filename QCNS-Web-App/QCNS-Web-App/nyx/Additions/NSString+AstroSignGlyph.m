//
//  NSString+AstroSignGlyph.m
//  Feezly
//
//  Created by Paul Antonelli on 13/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSString+AstroSignGlyph.h"

@implementation NSString (AstroSignGlyph)

- (NSAttributedString *)attributedStringByAddingGlyphWithSignString:(NSString *)signString fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    NSString *str = [NSString stringWithFormat:@"%@ %@", self, FZAstroCharacterFromSignString(signString)];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];

    NSRange range = NSMakeRange([attStr length] - 1, 1);
    
    [attStr addAttribute:NSFontAttributeName value:ASTRO_FONT(fontSize) range:range];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];

    return [[NSAttributedString alloc] initWithAttributedString:attStr];
}

+ (NSAttributedString *)attributedStringWithGlyphSignString:(NSString *)signString fontSize:(CGFloat)fontSize color:(UIColor *)color
{
//    
//    NSLog(@"signString : |%@|", signString);
    NSString *str = [NSString stringWithFormat:@"%@", FZAstroCharacterFromSignString(signString)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, [str length]);
    
    [attStr addAttribute:NSFontAttributeName value:ASTRO_FONT(fontSize) range:range];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return [[NSAttributedString alloc] initWithAttributedString:attStr];
    
}


@end
