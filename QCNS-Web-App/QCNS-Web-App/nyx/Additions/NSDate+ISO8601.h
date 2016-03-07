//
//  NSDate+ISO8601.h
//  Feezly
//
//  Created by Paul Antonelli on 16/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

- (NSString *)iso8601String;
- (NSString *)iso8601ShortString;
+ (NSDate *)dateFromISO8601String:(NSString *)dateString;
+ (NSDate *)dateFromShortString:(NSString *)dateString;

@end
