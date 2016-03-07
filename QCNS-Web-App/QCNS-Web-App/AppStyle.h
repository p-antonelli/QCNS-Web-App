//
//  AppStyle.h
//  Feezly
//
//  Created by Paul Antonelli on 30/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#ifndef AppStyle_h
#define AppStyle_h

//
// App Colors
//
//11 - 135 - 172
//#define FEEZLY_BLUE_COLOR           RGBCOLOR(25, 137, 173)
#define kDarkenCoeff                0.04f
//#define FEEZLY_BLUE_BAR_COLOR       [UIColor colorWithRed:(11.0f/255.0f) - kDarkenCoeff green:(135.0f/255.0f) - kDarkenCoeff blue:(172.0f/255.0f) - kDarkenCoeff alpha:1.0f]


//#define COSTA_BLUE_COLOR           RGBCOLOR(7, 73, 164)
#define COSTA_BLUE_COLOR           RGBCOLOR(12, 97, 177)

//#define FEEZLY_GREY_COLOR           RGBCOLOR(236, 233, 223)


//#define FEEZLY_BLUE_BAR_COLOR       RGBCOLOR(0, 113, 157)
//#define FEEZLY_BLUE_BAR_COLOR       RGBCOLOR(49, 154, 185)
#define FEEZLY_BLUE_BAR_COLOR       [FEEZLY_BLUE_COLOR equivalentNonOpaqueColorWhenInterpolatedWithBackgroundColor:FEEZLY_BLUE_COLOR minimumAlpha:0.9]

#define FACEBOOK_BLUE_COLOR         RGBCOLOR(59, 89, 152)
#define INSTAGRAM_BLUE_COLOR        RGBCOLOR(63, 106, 149)



//// Colors
#define BLUE_TEXT_COLOR                 [UIColor colorWithRed:0.0f/255.0f green:147.0f/255.0f blue:251.0f/255.0f alpha:1.0f]
#define GRAY_TEXT_COLOR                 [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f]
#define LIGHT_GRAY_TEXT_COLOR           [UIColor colorWithRed:163.0f/255.0f green:163.0f/255.0f blue:163.0f/255.0f alpha:1.0f]
#define GREEN_TEXT_COLOR                [UIColor colorWithRed:87.0f/255.0f green:191.0f/255.0f blue:67.0f/255.0f alpha:1.0f]
#define RED_TEXT_COLOR                  [UIColor colorWithRed:245.0f/255.0f green:3.0f/255.0f blue:19.0f/255.0f alpha:1.0f]
#define PINK_TEXT_COLOR                 [UIColor colorWithRed:255.0f/255.0f green:66.0f/255.0f blue:92.0f/255.0f alpha:1.0f]
#define FEMALE_AVATAR_COLOR             [UIColor colorWithRed:240.0f/255.0f green:149.0f/255.0f blue:234.0f alpha :1.0f]
#define MALE_AVATAR_COLOR               [UIColor colorWithRed:4.0f/255.0f green:149.0f/255.0f blue:251.0f alpha:1.0f]
#define FIELD_PLACEHOLDER_COLOR         [UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1.0f]
//
//// Other colors
//#define NAV_BAR_BACKGROUND_COLOR        [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]
//#define MENU_TITLE_COLOR                [UIColor colorWithRed:97.0f/255.0f green:97.0f/255.0f blue:97.0f/255.0f alpha:1.0f]
//
//// Stretchable buttons
//#define STRETCHABLE_RED_BUTTON_IMAGE    [[UIImage imageNamed:@"stretchable_red_button_background"] stretchableImageWithLeftCapWidth:11.0f topCapHeight:15.0f]
//#define STRETCHABLE_WHITE_BUTTON_IMAGE  [[UIImage imageNamed:@"stretchable_white_button_background"] stretchableImageWithLeftCapWidth:11.0f topCapHeight:15.0f]
//#define STRETCHABLE_PRICE_TAG_IMAGE     [[UIImage imageNamed:@"price_tag"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 18, 9, 18)]
//
//// Textures
//#define NOISE_TEXTURE                   [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_pattern.png"]]
//
//// Fonts
//#define TITLE_FONT(s)                   [UIFont fontWithName:@"Lobster-Regular" size:s]
//#define SUBTITLE_BOLD_FONT(s)                [UIFont fontWithName:@"Dosis-Bold" size:s]
//#define SUBTITLE_MEDIUM_FONT(s)         [UIFont fontWithName:@"Dosis-Medium" size:s]

#define ASTRO_FONT(s)                   [UIFont fontWithName:@"font-astrowi" size:s]
#define AWESOME_FONT(s)                 [UIFont fontWithName:@"FontAwesome" size:s]
#define REGULAR_FONT(s)                 [UIFont fontWithName:@"HelveticaNeue" size:s]
#define LIGHT_FONT(s)                   [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define MEDIUM_FONT(s)                  [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
#define BOLD_FONT(s)                    [UIFont boldSystemFontOfSize:s]
#define ITALIC_FONT(s)                  [UIFont italicSystemFontOfSize:s]
#define SYSTEM_FONT(s)                  [UIFont systemFontOfSize:s]

#endif /* AppStyle_h */
