//
//  NXURLParser.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 30/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NXURLParser.h"

@interface NXURLParser ()



@end

@implementation NXURLParser

- (id) initWithURLString:(NSString *)url{
    self = [super init];
    if (self != nil) {
        NSString *string = url;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempString;
        NSMutableArray *vars = [NSMutableArray new];
        //ignore the beginning of the string and skip to the vars
        [scanner scanUpToString:@"?" intoString:nil];
//        while ([scanner scanUpToString:@"&" intoString:&tempString])
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"&#"];
        while ([scanner scanUpToCharactersFromSet:charSet intoString:&tempString])
        {
            [vars addObject:tempString];
        }
        
        _variables = [NSArray arrayWithArray:vars];
    }
    return self;
}

- (NSString *)valueForVariable:(NSString *)varName
{
    for (NSString *var in _variables)
    {
        if ([var length] > [varName length]+1 &&
            [[var substringWithRange:NSMakeRange(0, [varName length]+1)] isEqualToString:[varName stringByAppendingString:@"="]])
        {
            NSString *varValue = [var substringFromIndex:[varName length]+1];
            return varValue;
        }
    }
    return nil;
}


@end
