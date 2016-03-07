//
//  NSDate+ISO8601.m
//  Feezly
//
//  Created by Paul Antonelli on 16/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSDate+ISO8601.h"

#define kISO_8601_ShortFomatString      @"yyyy-MM-dd"

//#define kISO_8601_Default_FomatString   @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"           // the real iso8601
#define kISO_8601_Default_FomatString   @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"           // the real iso8601
//#define kISO_8601_Other_FomatString     @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"         // the one used by BO
#define kISO_8601_Other_FomatString     @"yyyy-MM-dd'T'HH:mm:ssZ"         // the one used by BO
#define kISO_8601_FomatString           kISO_8601_Other_FomatString             // the choosen one for this code


@implementation NSDate (ISO8601)

static NSDateFormatter *dateFormatter = nil;

+ (void)buildFormatter
{
    dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    
    [dateFormatter setDateFormat:kISO_8601_FomatString];

}

- (NSString *)iso8601ShortString
{
    if (!dateFormatter)
    {
        [[self class] buildFormatter];
    }
    
    [dateFormatter setDateFormat:kISO_8601_ShortFomatString];
    
    return [dateFormatter stringFromDate:self];
    
}

- (NSString *)iso8601String
{
    if (!dateFormatter)
    {
        [[self class] buildFormatter];
    }
    
    [dateFormatter setDateFormat:kISO_8601_FomatString];

    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)dateFromISO8601String:(NSString *)dateString
{
//    DDLogError(@"dateString : |%@|",dateString);
    if (!dateString)
    {
        return nil;
    }
    
    if (!dateFormatter)
    {
        [[self class] buildFormatter];
    }
    
    [dateFormatter setDateFormat:kISO_8601_FomatString];
    
//    DDLogError(@"date format : %@", kISO_8601_FomatString);
//    DDLogError(@"date formater : %@", dateFormatter);
//    DDLogError(@"date : %@", [dateFormatter dateFromString:dateString]);
    
    NSDate *res = [dateFormatter dateFromString:dateString];
    if (!res)
    {
        DDLogError(@"################## DATE FALL BACK : %@", dateString);
        
//        DDLogError(@"new date format : %@", kISO_8601_Default_FomatString);
//        DDLogError(@"date formater : %@", dateFormatter);
//        DDLogError(@"date : %@", [dateFormatter dateFromString:dateString]);
        
        [dateFormatter setDateFormat:kISO_8601_Default_FomatString];
        res = [dateFormatter dateFromString:dateString];
    }
    
    return res;
}

+ (NSDate *)dateFromShortString:(NSString *)dateString
{
    if (!dateString)
    {
        return nil;
    }
    
    if (!dateFormatter)
    {
        [[self class] buildFormatter];
    }
    
    
    [dateFormatter setDateFormat:kISO_8601_ShortFomatString];
    
    return [dateFormatter dateFromString:dateString];
}


@end
