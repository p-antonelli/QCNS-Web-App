//
//  NXHTTPClient.h
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXHTTPAction.h"



@interface NXHTTPClient : NSObject

// Shared instance
+ (instancetype)sharedInstance;

// Add new HTTP action to queue
- (void)addNewHTTPAction:(NXHTTPAction *)action;
- (void)addNewHTTPAction:(NXHTTPAction *)action flush:(BOOL)flush;
- (void)addNewHTTPActions:(NSArray *)actions flush:(BOOL)flush;

// Flushes waiting queue into running queue
- (void)flush;

// Clear actions from waiting queue
- (void)clearWaitingQueue;

// Cancel running actions, also clears the waiting queue
- (void)cancelAllActions;

@end
