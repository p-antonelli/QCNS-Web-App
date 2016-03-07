//
//  NSString+URLEncode.m
//  Feezly
//
//  Created by Paul Antonelli on 01/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
//    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                               (CFStringRef)self,
//                                                               NULL,
//                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
//                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
    
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL, // characters to leave unescaped
                                                                                 CFSTR(":!*();@/&?+$,='"),
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));

}

@end
