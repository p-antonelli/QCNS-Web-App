//
//  UIImage+Base64.m
//  Feezly
//
//  Created by Paul Antonelli on 17/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIImage+Base64.h"

@implementation UIImage (Base64)

- (NSString *)base64String
{
    NSData *data = UIImagePNGRepresentation(self);
    DDLogError(@"data length : %ld", (long)[data length]);
    DDLogError(@"string length : %ld", (long)[[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]     length]);
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (UIImage *)imageFromBase64String:(NSString *)string
{
    if (!string)
    {
        NSLog(@"%s ##### BASE 64 STRING IS EMPTY ! ! ! ", __PRETTY_FUNCTION__);
        return nil;
    }
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!data)
    {
        NSLog(@"%s ##### BASE 64 DATA IS EMPTY ! ! ! ", __PRETTY_FUNCTION__);
        return nil;
    }
    
    return [UIImage imageWithData:data];
}

@end
