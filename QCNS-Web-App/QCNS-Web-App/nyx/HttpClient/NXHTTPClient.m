//
//  NXHTTPClient.m
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXHTTPClient.h"
#import "NXHTTPAction.h"



#define MAX_CONCURRENT_JOBS     4



@interface NXHTTPClient () <NXHTTPActionDelegate>

// Lock
@property (nonatomic, strong) NSLock *lock;

// Queues
@property (nonatomic, strong) NSMutableArray *waitingQueue;
@property (nonatomic, strong) NSMutableArray *runningQueue;
@property (nonatomic, strong) NSMutableArray *dependenciesQueue;

@end



@implementation NXHTTPClient

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    static NXHTTPClient *sharedInstance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedInstance = [[NXHTTPClient alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Constructor
- (id)init
{
    if (self = [super init])
    {
        // Initialize queues
        _waitingQueue = [NSMutableArray array];
        _runningQueue = [NSMutableArray array];
        _dependenciesQueue = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Queue management
- (void)addNewHTTPAction:(NXHTTPAction *)action
{
    [self addNewHTTPAction:action flush:YES];
}

- (void)addNewHTTPAction:(NXHTTPAction *)action flush:(BOOL)flush
{
    // Lock the lock
    [_lock lock];
    
    // Action
    if (action.hasDependencies)
    {
        [_dependenciesQueue addObject:action];
    }
    else
    {
        [_waitingQueue addObject:action];
    }
    
    // Unlock the lock
    [_lock unlock];
    
    // Flush
    if (flush)
    {
        [self flush];
    }
}

- (void)addNewHTTPActions:(NSArray *)actions flush:(BOOL)flush
{
    // Dispatch actions to correct queues
    NSMutableArray *toDependenciesQueue = [NSMutableArray array];
    NSMutableArray *toWaitingQueue = [NSMutableArray array];
    for (NXHTTPAction *action in actions)
    {
        // Action
        if (action.hasDependencies)
        {
            [_dependenciesQueue addObject:action];
        }
        else
        {
            [_waitingQueue addObject:action];
        }
    }
    
    // One shot add action to the right queue
    [_lock lock];
    [_dependenciesQueue addObjectsFromArray:toDependenciesQueue];
    [_waitingQueue addObjectsFromArray:toWaitingQueue];
    [_lock unlock];
    
    // Flush
    if (flush)
    {
        [self flush];
    }
}

- (void)clearWaitingQueue
{
    // Clear queue
    [_lock lock];
    [_waitingQueue removeAllObjects];
    [_lock unlock];
}

- (void)cancelAllActions
{
    // Clear waiting queue
    [self clearWaitingQueue];
    
    // Lock the lock
    [_lock lock];
    
    // Cancel running action
    for (NXHTTPAction *action in _runningQueue)
    {
        [action cancel];
    }
    
    // Unlock the lock
    [_lock unlock];
}

- (void)flush
{
    // Dependency management
    NSMutableArray *dependenciesToRemove = [NSMutableArray array];
    for (NXHTTPAction *action in _dependenciesQueue)
    {
        // Determine if action should be added to waiting queue
        BOOL shouldAddAction = YES;
        for (NXHTTPAction *dependency in action.dependencies)
        {
            if ([_runningQueue containsObject:dependency] || [_waitingQueue containsObject:dependency])
            {
                shouldAddAction = NO;
                break;
            }
        }
        
        // Add to waiting queue
        if (shouldAddAction)
        {
            [_lock lock];
            [_waitingQueue addObject:action];
            [_lock unlock];
            [dependenciesToRemove addObject:action];
        }
    }
    [_lock lock];
    [_dependenciesQueue removeObjectsInArray:dependenciesToRemove];
    [_lock unlock];
    
    
    // Transfer actions from waiting queue to running queue
    NXHTTPAction *action;
    while (_runningQueue.count != MAX_CONCURRENT_JOBS && _waitingQueue.count)
    {
        // Dequeue action
        action = [_waitingQueue lastObject];
        action.delegate = self;
        
        // Queue management
        [_lock lock];
        [_runningQueue addObject:action];
        [_waitingQueue removeObject:action];
        [_lock unlock];
        
        // Start action
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [action start];
        });
    }
}

#pragma mark - NXHTTPActionDelegate methods
- (void)actionDidComplete:(NXHTTPAction *)action
{
    // Remove object from running queue
    [_lock lock];
    [_runningQueue removeObject:action];
    [_lock unlock];
    
    // Flush
    [self flush];
}

- (void)action:(NXHTTPAction *)action didFailWithError:(NSError *)error data:(id)data
{
    // Remove object from running queue
    [_lock lock];
    [_runningQueue removeObject:action];
    [_lock unlock];
    
    // Detect dependencies to remove
    NSMutableArray *dependenciesToRemove = [NSMutableArray array];
    for (NXHTTPAction *dependentAction in self.dependenciesQueue)
    {
        if ([dependentAction.dependencies containsObject:action])
        {
            [dependenciesToRemove addObject:dependentAction];
            [dependentAction cancel];
        }
    }
    
    // Remove dependencies
    [_lock lock];
    [self.dependenciesQueue removeObjectsInArray:dependenciesToRemove];
    [_lock unlock];
    
    // Flush
    [self flush];
}

- (void)actionCancelled:(NXHTTPAction *)action
{
    // Remove action object
    [_lock lock];
    [_runningQueue removeObject:action];
    [_lock unlock];
}

@end
