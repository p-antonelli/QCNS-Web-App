//
//  NSDictionary+FormParamString.m
//  Axalfred
//
//  Created by Paul Antonelli on 23/05/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "NSDictionary+FormParamString.h"

@implementation NSDictionary (FormParamString)

- (NSString *)formParamString
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:0];
    NSData *data = nil;
    id object = nil;
    for (NSString *key in self) {

        object = self[key];

        [string appendString:key];
        [string appendString:@"="];

        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]])
        {
            data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
            NSString *dictString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [string appendString:dictString];
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            [string appendString:object];
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            [string appendFormat:@"%f", [object doubleValue]];
        }

        [string appendString:@"&"];
    }

    // remove last '&'
    [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];

    return [NSString stringWithString:string];
}

@end
