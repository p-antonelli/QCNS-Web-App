//
//  NXCustomFormatter.h
//  NXIOSLIB
//
//  Created by Paul Antonelli on 10/12/12.
//  Copyright (c) 2012 Paul Antonelli. All rights reserved.
//

#import "DDLog.h"

@interface NXCustomFormatter : NSObject <DDLogFormatter> {
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end
