//
//  NSString+trimLeadingWhitespace.h
//  Axalfred
//
//  Created by Paul Antonelli on 30/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (trimLeadingWhitespace)

- (NSString *)stringByTrimmingLeadingWhitespace;
- (NSString *)stringByTrimmingWhitespace;

@end
