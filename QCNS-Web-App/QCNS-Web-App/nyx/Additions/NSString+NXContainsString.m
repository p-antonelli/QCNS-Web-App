//
//  NSString+NXContainsString.m
//  Feezly
//
//  Created by Paul Antonelli on 03/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSString+NXContainsString.h"

@implementation NSString (NXContainsString)

- (BOOL)nx_containsString:(NSString *)aString
{
    return [self rangeOfString:aString].location != NSNotFound;
}

- (BOOL)nx_containsStringCaseInsensitive:(NSString *)aString
{
    return [self rangeOfString:aString options:NSCaseInsensitiveSearch].location != NSNotFound;
}

@end
