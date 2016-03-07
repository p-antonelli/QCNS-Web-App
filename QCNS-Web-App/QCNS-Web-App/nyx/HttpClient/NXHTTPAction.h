//
//  NXHTTPAction.h
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, NXHTTPMethod)
{
    NXHTTPMethodGet = 0, // default
    NXHTTPMethodPut,
    NXHTTPMethodPost,
    NXHTTPMethodDelete,
    NXHTTPMethodPatch
};

typedef NS_ENUM(NSInteger, NXHTTPActionState)
{
    NXHTTPActionStateWaiting = 0, // default
    NXHTTPActionStateRunning,
    NXHTTPActionStateSucceeded,
    NXHTTPActionStateFailed,
    NXHTTPActionStateCancelled
};



@class NXHTTPAction;



@protocol NXHTTPActionDelegate <NSObject>

@optional

// Called when action did start running
- (void)actionDidStart:(NXHTTPAction *)action;

// Called when action did finish with success
- (void)actionDidComplete:(NXHTTPAction *)action;

// Called when action failed
- (void)action:(NXHTTPAction *)action didFailWithError:(NSError *)error data:(id)data;

// Called when action is cancelled
- (void)actionCancelled:(NXHTTPAction *)action;

@end



@interface NXHTTPAction : NSObject

// Constructor
+ (instancetype)action;

// Notifications
+ (NSString *)notificationNameForState:(NXHTTPActionState)state;

// Configuration
- (void)prepareOperation;

// Builder methods
- (NSMutableURLRequest *)buildRequest;
- (NSURL *)actionURL;

// HTTP request lifecycle
- (void)start;
- (void)cancel;

// Received data management
- (void)handleDownloadedData:(id)data;
- (void)handleOperationDidFailWithError:(NSError *)error data:(id)data;

// Dependency management
- (void)addDependency:(NXHTTPAction *)dependency;

// Request config
@property (nonatomic, readwrite) NXHTTPMethod httpMethod;                          // default is NXHTTPMethodGet
@property (nonatomic, strong, readwrite) NSData *postData;                          // default is nil
@property (nonatomic, readwrite) BOOL acceptGZipEncoding;                           // default is YES
@property (nonatomic, strong, readwrite) NSMutableDictionary *httpHeaderFields;     // default is empty

// Current action state
@property (readonly) NXHTTPActionState state;

// Response data
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) id data;
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

// Dependencies
@property (nonatomic, strong, readonly) NSMutableArray *dependencies;
@property (nonatomic, readonly) BOOL hasDependencies;

// Operation
@property (nonatomic, strong) AFHTTPRequestOperation *operation;

// Delegate
@property (nonatomic, assign) id<NXHTTPActionDelegate> delegate;

@end
