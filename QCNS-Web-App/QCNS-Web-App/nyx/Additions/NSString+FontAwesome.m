//
//  * The Font Awesome font is licensed under the SIL Open Font License
//  http://scripts.sil.org/OFL
//
//
//  * Font Awesome CSS, LESS, and SASS files are licensed under the MIT License
//  http://opensource.org/licenses/mit-license.html
//
//
//  * The Font Awesome pictograms are licensed under the CC BY 3.0 License
//  http://creativecommons.org/licenses/by/3.0
//
//
//  * Attribution is no longer required in Font Awesome 3.0, but much appreciated:
//  "Font Awesome by Dave Gandy - http://fortawesome.github.com/Font-Awesome"
//
//
//  -----------------------------------------
//  Edited and refactored by Jesse Squires on 2 April, 2013.
//
//  http://github.com/jessesquires/BButton
//
//  http://hexedbits.com
//

#import "NSString+FontAwesome.h"

//NSString * const kFontAwesomeFont = @"FontAwesome";

@implementation NSString (FontAwesome)

+ (NSString *)stringForFontAwesomeIcon:(FAIcon)icon
{
    return [NSString stringWithFormat:@"%C", icon];
}

@end


@implementation NSAttributedString (FontAwesome)

+ (NSAttributedString *)attributedStringForFontAwesomeIcon:(FAIcon)icon pointSize:(CGFloat)pointSize color:(UIColor *)color
{
    NSString *string =  [NSString stringForFontAwesomeIcon:icon];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: color ?: [UIColor blackColor],
                           NSFontAttributeName:AWESOME_FONT(pointSize)};
    
    [mutStr addAttributes:attr range:NSMakeRange(0, [string length]-1)];
    
    
    return [[NSAttributedString alloc] initWithAttributedString:mutStr];
}



@end