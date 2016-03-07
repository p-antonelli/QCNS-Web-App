//
//  NXHTTPAction.m
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXHTTPAction.h"
#import "NSNotificationCenter+Additions.h"




// HTTP Methods
static NSString *const kGetMethod = @"GET";
static NSString *const kPutMethod = @"PUT";
static NSString *const kPostMethod = @"POST";
static NSString *const kDeleteMethod = @"DELETE";
static NSString *const kPatchMethod = @"PATCH";

// States
static NSString *const kWaitingState = @"WAITING";
static NSString *const kRunningState = @"RUNNING";
static NSString *const kSucceededState = @"SUCCEEDED";
static NSString *const kFailedState = @"FAILED";
static NSString *const kCancelledState = @"CANCELLED";

// Notification
static NSString *const kNotificationSuffix = @"NOTIFICATION";



@interface NXHTTPAction ()

// HTTP method
@property (nonatomic, readonly) NSString *httpMethodString;

// State
@property (readwrite) NXHTTPActionState state;

// Response data
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSDictionary *responseHeaders;

@end



@implementation NXHTTPAction

@synthesize state = _state;

#pragma mark - Object lifecycle
static NSDictionary *methodDict;
static NSDictionary *stateDict;
+ (void)initialize
{
    if (self == [NXHTTPAction class])
    {
        methodDict = @{
                       @(NXHTTPMethodGet) : kGetMethod,
                       @(NXHTTPMethodPut) : kPutMethod,
                       @(NXHTTPMethodPost) : kPostMethod,
                       @(NXHTTPMethodDelete) : kDeleteMethod,
                       @(NXHTTPMethodPatch) : kPatchMethod
                       };
        
        stateDict = @{
                      @(NXHTTPActionStateWaiting) : kWaitingState,
                      @(NXHTTPActionStateRunning) : kRunningState,
                      @(NXHTTPActionStateSucceeded) : kSucceededState,
                      @(NXHTTPActionStateFailed) : kFailedState,
                      @(NXHTTPActionStateCancelled) : kCancelledState
                      };
    }
}

#pragma mark - Constructors
+ (instancetype)action
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.httpHeaderFields = [NSMutableDictionary dictionaryWithCapacity:0];
        self.acceptGZipEncoding = YES;
    }
    return self;
}

#pragma mark - Action lifecycle
- (void)start
{
    // Prepare operation
    [self prepareOperation];
    
    // Start the action
    [_operation start];
    
    // Update state
    self.state = NXHTTPActionStateRunning;
    
    // Notify delegate
    if ([_delegate respondsToSelector:@selector(actionDidStart:)])
    {
        [_delegate actionDidStart:self];
    }
}

- (void)cancel
{
    // Cancel operation
    [self.operation cancel];
    
    // Update state
    self.state = NXHTTPActionStateCancelled;
    
    // Notify delegate
    if ([_delegate respondsToSelector:@selector(actionCancelled:)])
    {
        [_delegate actionCancelled:self];
    }
}

#pragma mark - Configuration
- (void)prepareOperation
{
    // Build operation
    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:[self buildRequest]];
    
    // Set completion and failure blocks
    __weak NXHTTPAction *weakSelf = self;
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id data) {
        
        // Side data
        weakSelf.error = nil;
        weakSelf.data = operation.responseObject;
        weakSelf.responseHeaders = operation.response.allHeaderFields;
        
        // In a background thread, handle data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            // Handle downloaded data
#if (APP_DEV)
            NSDate *start = [NSDate date];
#endif
            
            [weakSelf handleDownloadedData:data];

#if (APP_DEV)
            NSDate *end = [NSDate date];
            NSTimeInterval executionTime = [end timeIntervalSinceDate:start];
            NSLog(@"%@ : %f", [[weakSelf class] description], executionTime);
#endif
            
            // update state
            weakSelf.state = NXHTTPActionStateSucceeded;
            
            // Notify delegate
            if ([weakSelf.delegate respondsToSelector:@selector(actionDidComplete:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate actionDidComplete:weakSelf];
                });
            }
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // Side data
        weakSelf.error = error;
        weakSelf.data = operation.responseObject;
        weakSelf.responseHeaders = operation.response.allHeaderFields;
        
        // In a background thread, handle error
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            // Handle error
            [weakSelf handleOperationDidFailWithError:error data:operation.responseObject];
            
            // Update state
            weakSelf.state = NXHTTPActionStateFailed;
            
            // Notify delegate
            if ([weakSelf.delegate respondsToSelector:@selector(action:didFailWithError:data:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate action:weakSelf didFailWithError:error data:operation.responseObject];
                });
            }
            
        });
    }];
}

#pragma mark - Builders
- (NSMutableURLRequest *)buildRequest
{
    // Build URL request with action URL
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[self actionURL]];
    
    // Default method is GET, should be overidden if necessary
    [urlRequest setHTTPMethod:self.httpMethodString];
    
    // Set HTTP header fields if needed
    for (NSString *key in self.httpHeaderFields)
    {
        [urlRequest setValue:self.httpHeaderFields[key] forHTTPHeaderField:key];
    }
    
    // Set HTTP body if needed
    if (self.postData)
    {
        [urlRequest setValue:[NSString stringWithFormat:@"%u", (unsigned int)[self.postData length]] forHTTPHeaderField:@"Content-Length"];
        [urlRequest setHTTPBody:self.postData];
    }
    
    // Accept gzip encoding
    if (self.acceptGZipEncoding)
    {
        [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    return urlRequest;
}

- (NSURL *)actionURL
{
    @throw @"actionURL: method must be overidden";
}

#pragma mark - Received data management
- (void)handleDownloadedData:(id)data
{
#if (APP_DEV | APP_RECETTE)
    float responseSize = (float)self.operation.responseData.length / 1000.0f;
    NSLog(@"%@ handleDownloadedData: %@ (%.2fkb)", [self class], [self.operation.request.URL description], responseSize);
    NSLog(@"response string : %@", self.operation.responseString);
#endif
}

- (void)handleOperationDidFailWithError:(NSError *)error data:(id)data
{
#if (APP_DEV | APP_RECETTE)
    NSLog(@"%@ handleOperationDidFailWithError:data: %@", [self class], [self.operation.request.URL description]);
    NSLog(@"response string : %@", self.operation.responseString);    
#endif
}

#pragma mark - Dependency managmeent
- (void)addDependency:(NXHTTPAction *)dependency
{
    if (!_dependencies)
    {
        _dependencies = [NSMutableArray array];
    }
    
    // Add action to dependencies
    if (![_dependencies containsObject:dependency])
    {
        [_dependencies addObject:dependency];
    }
}

- (BOOL)hasDependencies
{
    return ([_dependencies count] > 0);
}

#pragma mark - Getters
- (NXHTTPActionState)state
{
    @synchronized(self)
    {
        return _state;
    }
}

#pragma mark - Setters
- (void)setState:(NXHTTPActionState)state
{
    @synchronized(self)
    {
        _state = state;
        
        // Post a notification on main thread
        [NOTIFICATION_CENTER postNotificationOnMainThreadNamed:[[self class] notificationNameForState:_state] object:self];
    }
}

#pragma mark - Utils
+ (NSString *)notificationNameForState:(NXHTTPActionState)state
{
    NSString *stateString = stateDict[@(state)];
    NSAssert(stateString != nil, @"State should not be nil");
    
    return [NSString stringWithFormat:@"%@_%@_%@", [[self class] description], stateString, kNotificationSuffix];
}

- (NSString *)httpMethodString
{
    // Fall back on GET method if not found in methodDict
    return methodDict[@(_httpMethod)] ?: methodDict[@(NXHTTPMethodGet)];
}

@end
