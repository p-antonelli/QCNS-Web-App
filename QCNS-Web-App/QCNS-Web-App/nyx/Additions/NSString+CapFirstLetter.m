//
//  NSString+CapFirstLetter.m
//  Axalfred
//
//  Created by Paul Antonelli on 30/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "NSString+CapFirstLetter.h"
#import "NSString+trimLeadingWhitespace.h"

@implementation NSString (CapFirstLetter)

- (NSString *)capitalizedFirstLetter
{
    if ([self length] == 0) {
        return self;
    }

    return [[self  stringByTrimmingLeadingWhitespace] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}

@end
