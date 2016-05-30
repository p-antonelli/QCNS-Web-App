//
//  NSString+DecodeURL.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 30/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSString+DecodeURL.h"

@implementation NSString (DecodeURL)

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
