//
//  NXCustomFormatter.m
//  NXIOSLIB
//
//  Created by Paul Antonelli on 10/12/12.
//  Copyright (c) 2012 Paul Antonelli. All rights reserved.
//

#import "NXCustomFormatter.h"
#import <libkern/OSAtomic.h>

#define DATE_LOG_FORMAT @"dd-MM-yyyy | HH:mm:ss.SSS" // dateAndTime

@implementation NXCustomFormatter

- (NSString *)stringFromDate:(NSDate *)date { 
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [threadUnsafeDateFormatter setDateFormat:DATE_LOG_FORMAT];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
        
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:DATE_LOG_FORMAT];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    
    NSString *dateAndTime = [self stringFromDate:(logMessage->timestamp)];
    NSString *logMsg = logMessage->logMsg;
    
    NSString *file = nil;
    if (nil != logMessage->file) {
        file = [[NSString  stringWithUTF8String:logMessage->file] lastPathComponent];
    }
    
    return [NSString stringWithFormat:@"<%@ | %@:%d> [%s] %@", dateAndTime, file, logMessage->lineNumber, logMessage->function, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger
{
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end
