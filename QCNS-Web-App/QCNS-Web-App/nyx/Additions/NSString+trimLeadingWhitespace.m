//
//  NSString+trimLeadingWhitespace.m
//  Axalfred
//
//  Created by Paul Antonelli on 30/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "NSString+trimLeadingWhitespace.h"

@implementation NSString (trimLeadingWhitespace)

- (NSString *)stringByTrimmingLeadingWhitespace
{

    NSInteger i = 0;

    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

// remove leading & trailing whitespace
- (NSString *)stringByTrimmingWhitespace
{

    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);

    return [mStr copy];
}

@end
