//
//  NSDate+NbYears.m
//  Pastis51
//
//  Created by Paul Antonelli on 22/05/13.
//  Copyright (c) 2013 Paul Antonelli. All rights reserved.
//

#import "NSDate+NbYears.h"

@implementation NSDate (NbYears)

- (NSInteger)nbYearsFromNow {
//    DDLogInfo(@"dateOfBirth %@", self);
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:self];

	if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
		(([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
		return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
	} else {
		return [dateComponentsNow year] - [dateComponentsBirth year];
	}
}


@end
