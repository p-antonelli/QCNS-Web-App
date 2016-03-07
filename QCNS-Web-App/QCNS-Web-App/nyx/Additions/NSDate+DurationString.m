//
//  NSDate+DurationString.m
//  Versus
//
//  Created by Paul Antonelli on 14/01/13.
//  Copyright (c) 2013 Big Boss Studio. All rights reserved.
//

#import "NSDate+DurationString.h"

@implementation NSDate (DurationString)

- (NSString *)durationString {
    
    static NSCalendar *calendar = nil;
    static NSDate *now = nil;
    static NSDateComponents *components = nil;
    
    static NSUInteger flags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    
    static int nbYear = 0;
    static int nbMonth = 0;
    static int nbDay = 0;
    static int nbHour = 0;
    static int nbMin = 0;
    static int nbSec = 0;
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    now = [NSDate date];
    components = [calendar components:flags fromDate:self toDate:now options:0];
    
    nbYear = (int)[components year];
    nbMonth = (int)[components month];
    nbDay = (int)[components day];
    nbHour = (int)[components hour];
    nbMin = (int)[components minute];
    nbSec = (int)[components second];
    
    NSString *resultStr = nil;
    
    if (nbYear > 0) {
        
        if (nbYear == 1) {
//            resultStr = @"plus d'un an";
            resultStr = @"un an";
        } else {
//            resultStr = [NSString stringWithFormat:@"plus de %d ans", nbYear];
            resultStr = [NSString stringWithFormat:@"%d ans", nbYear];
        }
        
    } else if (nbMonth > 0 ) {
        
        if (nbMonth == 1) {
//            resultStr = @"plus d'un mois";
            resultStr = @"un mois";
        } else {
//            resultStr = [NSString stringWithFormat:@"plus de %d mois", nbMonth];
            resultStr = [NSString stringWithFormat:@"%d mois", nbMonth];
        }
        
    } else if (nbDay > 0) {
        
        if (nbDay == 1) {
            resultStr = @"un jour";
        } else {
//            resultStr = [NSString stringWithFormat:@"plus de %d jours", nbDay];
            resultStr = [NSString stringWithFormat:@"%d jours", nbDay];
        }
        
    } else if (nbHour > 0) {
        
        if (nbHour == 1) {
//            resultStr = @"plus d'une heure";
            resultStr = @"une heure";
        } else {
//            resultStr = [NSString stringWithFormat:@"plus de %d heures", nbHour];
            resultStr = [NSString stringWithFormat:@"%d heures", nbHour];
        }
        
    } else if (nbMin > 0) {
        
        if (nbMin == 1) {
            resultStr = @"une minute";
        } else {
            resultStr = [NSString stringWithFormat:@"%d minutes", nbMin];
        }
        
    } else {
        resultStr = @"moins d'une minute";
    }
    
    return [NSString stringWithFormat:@"Il y a %@", resultStr];
}


@end
