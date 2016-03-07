//
//  UIImage+ImageNamedNoCache.m
//  Feezly
//
//  Created by Paul Antonelli on 20/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIImage+ImageNamedNoCache.h"

@implementation UIImage (ImageNamedNoCache)

static NSString *bundlePath = nil;

+ (UIImage *)imageNamedNoCache:(NSString *)imageName
{
    if (!bundlePath)
    {
        bundlePath = [[NSBundle mainBundle] bundlePath];
    }
    
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:imageName];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        imgPath = [imgPath stringByAppendingFormat:@"@%ldx.png", (long)[MAIN_SCREEN scale]];
    }
    return [UIImage imageWithContentsOfFile:imgPath];
}

@end
